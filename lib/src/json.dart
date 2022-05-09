import 'dart:convert';

import 'package:darty_json_safe/src/json_key.dart';

typedef JSONDouble = double;
typedef JSONInt = int;
typedef JSONString = String;
typedef JSONBool = bool;
typedef JSONNum = num;
typedef JSONObject = Map<dynamic, dynamic>;
typedef JSONArray = List<dynamic>;

/// JSON解析器
class JSON {
  dynamic _rawValue;

  /// 解析的值
  dynamic get rawValue => _rawValue;

  /// 存储关联上一个JSON的数据 用于在设置值的时候更新最顶层的JSON
  final JSONKey? _key;

  /// 创建一个新的JSON解析器
  /// [rawValue] 解析的值 默认为空字典
  /// [key] 关联上一个JSON的数据 用于在设置值的时候更新最顶层的JSON
  JSON([this._rawValue = const {}, this._key]);

  /// 通过[key] 获取下一个JSON 不存在则返回空的JSON
  JSON operator [](dynamic key) {
    JSON? json;

    /// 尝试从数组获取 获取到则直接返回
    json = tryFromArray(key);
    if (json != null) return json;

    /// 尝试从字典获取 获取到则直接返回
    json = tryFromObject(key);
    if (json != null) return json;

    /// 尝试根据数组Key获取 获取到则返回
    json = tryFromKeyPath(key);
    if (json != null) return json;

    /// 获取不到返回空的JSON
    return JSON();
  }

  /// 根据[key] 更新[value]
  /// [key] 关联的键
  /// [value] 关联的值
  void operator []=(dynamic key, dynamic value) {
    /// 尝试设置到字典中
    trySetObject(key, value);

    /// 尝试设置到数组中
    trySetArray(key, value);

    /// 尝试根据Key数组进行设置
    trySetKeyPath(key, value);
  }

  /// 循环读取List中的所有值
  void forEachList(void Function(int, JSON) callback) {
    final list = listValue;
    for (var i = 0; i < list.length; i++) {
      callback(i, JSON(list[i]));
    }
  }

  /// 循环读取Map中的所有值
  void forEachMap(void Function(String, JSON) callback) {
    final map = mapValue;
    map.forEach((key, value) {
      callback(key, JSON(value));
    });
  }

  /// 检测对应Key 的值是否存在
  bool exists() => _rawValue != null;

  /// 更新值
  set _value(dynamic value) {
    _rawValue = value;

    /// 检测当前JSON是否关联了上一个JSON 如果关联了则更新最顶层的JSON 否则不更新
    final key = _key;
    if (key == null) return;
    key.parentJSON[key.key] = value;
  }
}

extension JSONGetOperations on JSON {
  JSON? tryFromArray(dynamic key) {
    if (key is List) return null;
    final list = this.list;
    if (list == null) return null;
    final index = JSON(key).int;
    if (index == null) return null;
    if (index < 0 || index >= list.length) return null;
    return JSON(list[index], JSONKey(this, index));
  }

  JSON? tryFromObject(dynamic key) {
    if (key is List) return null;
    final map = this.map;
    if (map == null) return null;
    return JSON(map[key], JSONKey(this, key));
  }

  JSON? tryFromKeyPath(dynamic key) {
    final keyPaths = JSON(key).list;
    if (keyPaths == null) return null;
    JSON? json = this;
    for (var i = 0; i < keyPaths.length; i++) {
      if (json == null) return null;
      json = json[keyPaths[i]];
    }
    return json;
  }
}

extension JSONSetOperations on JSON {
  void trySetArray(dynamic key, dynamic value) {
    if (key is List) return;
    final list = this.list;
    if (list == null) return;
    final index = JSON(key).int;
    if (index == null) return;
    if (index < 0 || index >= list.length) return;
    list[index] = value;
    _value = list;
  }

  void trySetObject(dynamic key, dynamic value) {
    if (key is List) return;
    final map = this.map;
    if (map == null) return;
    if (value is JSON) {
      value = value.rawValue;
    }
    map[key] = value;
    _value = map;
  }

  void trySetKeyPath(dynamic key, dynamic value) {
    if (key is! List) return;
    final keyPaths = JSON(key).list;
    if (keyPaths == null) return;
    JSON json = this[keyPaths];
    json._value = value;
  }
}

/// 转换为Double类型
extension JSONToDouble on JSON {
  /// 转换为一个可能为空的double类型
  JSONDouble? get double {
    if (rawValue is bool) return rawValue ? 1 : 0;
    return JSONDouble.tryParse(rawValue.toString());
  }

  /// 转换为一个默认为为0 不为空的double类型
  JSONDouble get doubleValue {
    return double ?? 0;
  }

  bool get isDouble => double != null;
}

/// 转换为Int类型
extension JSONToInt on JSON {
  /// 转换为一个可能为空的int类型
  JSONInt? get int {
    if (rawValue is bool) return rawValue ? 1 : 0;
    return JSONInt.tryParse(rawValue.toString());
  }

  /// 转换为一个默认为为0 不为空的int类型
  JSONInt get intValue {
    return int ?? 0;
  }

  bool get isInt => int != null;
}

/// 转换为Bool类型
extension JSONToBool on JSON {
  /// 转换为一个可能为空的bool类型
  JSONBool? get bool {
    final intValue = this.int;
    if (intValue == null) return null;
    return intValue == 0 ? false : true;
  }

  /// 转换为一个默认为为false 不为空的bool类型
  JSONBool get boolValue {
    return bool ?? false;
  }

  JSONBool get isBool => bool != null;
}

/// 转换为Number类型
extension JSONToNumber on JSON {
  /// 转换为一个可能为空的Number类型
  JSONNum? get num {
    if (rawValue is bool) return rawValue ? 1 : 0;
    return JSONNum.tryParse(rawValue.toString());
  }

  /// 转换为一个默认为为0 不为空的Number类型
  JSONNum get numValue {
    return num ?? 0;
  }

  bool get isNum => num != null;
}

/// 转换为Array类型
extension JSONToArray on JSON {
  /// 转换为一个可能为空的Array类型
  JSONArray? get list {
    if (rawValue is String) {
      return JSON(jsonDecode(rawValue)).list;
    }
    if (rawValue is! JSONArray) return null;
    return rawValue;
  }

  /// 转换为一个默认为为空的Array类型
  JSONArray get listValue {
    return list ?? [];
  }

  bool get isList => list != null;
}

/// 转换为 Map类型
extension JSONToMap on JSON {
  /// 转换为一个可能为空的Map类型
  JSONObject? get map {
    if (rawValue is String) {
      return JSON(jsonDecode(rawValue)).map;
    }
    if (rawValue is! Map) return null;
    return rawValue;
  }

  /// 转换为一个默认为为空的Map类型
  JSONObject get mapValue {
    return map ?? {};
  }

  bool get isMap => map != null;
}

extension JSONToString on JSON {
  /// 转换为一个可能为空的String类型
  JSONString? get string {
    if (rawValue is JSONDouble) return rawValue.toString();
    if (rawValue is JSONInt) return rawValue.toString();
    if (rawValue is JSONBool) return rawValue.toString();
    if (rawValue is JSONNum) return rawValue.toString();
    if (rawValue is String) return rawValue;
    if (rawValue is JSONArray) return jsonEncode(rawValue);
    if (rawValue is JSONObject) return jsonEncode(rawValue);
    return null;
  }

  /// 转换为一个默认为为空的String类型
  JSONString get stringValue {
    return string ?? "";
  }

  bool get isString => string != null;
}

extension IntToJSON on int {
  JSON get json {
    return JSON(this);
  }
}

extension DoubleToJSON on double {
  JSON get json {
    return JSON(this);
  }
}

extension BoolToJSON on bool {
  JSON get json {
    return JSON(this);
  }
}

extension NumberToJSON on num {
  JSON get json {
    return JSON(this);
  }
}

extension StringToJSON on String {
  JSON get json {
    return JSON(this);
  }
}

extension ListToJSON on List {
  JSON get json {
    return JSON(this);
  }
}

extension MapToJSON on Map {
  JSON get json {
    return JSON(this);
  }
}

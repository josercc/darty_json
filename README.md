一款仿照 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 的 Dart 数据解析库

## 为什么要开发这个库？

因为有一些场景直接通过 JSONObject 取值更加方便。
比如下面的一串JSON字符串

```json
{"a":1,"b":2,"c":3}
```

如果按照系统自带的获取对应的值

```dart
int? a = jsonObject['a'] as? int;
```

此时如果返回的数据变更如下

```json
{"a":'1',"b":'2',"c":'3'}

{"a":{},"b":{},"c":{}}
```

之前的代码就会报错

还有很多情况，系统的 JSONObject 是做不到的。我们看一下通过这个库可以干什么吧。

### 直接从数组获取 Double 值

```dart
final value = JSON([1])[0].doubleValue

/// 此时 value 是 1
```

### 从一组对象获取名字组成数组

```dart
final jsonText = '''
      [{"name":"Google","url":"http://www.google.com"},{"name":"Baidu","url":"http://www.baidu.com"},{"name":"SoSo","url":"http://www.SoSo.com"}]
      ''';
final json = JSON(jsonText);
final names =
    json.listValue.map((e) => JSON(e)['name'].stringValue).toList();
/// 此时 names 是 ['Google', 'Baidu', 'SoSo']
```

### 从字典获取对应的值

```dart
final jsonText = '''
      {"name":"Google","url":"http://www.google.com"}
      ''';
final name = JSON(jsonText)['name'].stringValue;
/// 此时 name 值 Google
```

### 根据路径获取对应的值

```dart
final jsonText = '''
[{"list":[{"name":"king"}]}]
''';
final keyPaths = [0, 'list', 0, 'name'];
final name = JSON(jsonText)[keyPaths].stringValue;
final name1 = JSON(jsonText)[0]['list'][0]['name'].stringValue
/// 此时 name 和 name1 的值都是 king
```

### 类型转换

```dart
JSON(1).stringValue; /// '1'
JSON(1.1).stringValue; /// '1.1'
JSON(true).intValue; /// 1
JSON('1').stringValue; /// '1'
```

### 超出边界取值

```dart
final JSON json = JSON('[1,2,3]');
json[3].int; /// null
```

### 循环打印数组元素

```dart
final JSON json = JSON('[1,2,3]');
json.forEachList((index, e) {
    if (index == 0) {
        e.int; /// 1
    } else if (index == 1) {
        e.int; /// 2
    } else if (index == 2) {
        e.int; /// 3
    }
});
```

### 循环打印字典

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json.forEachMap((key, e) {
    if (key == 'a') {
        e.int; /// 1
    } else if (key == 'b') {
        e.int; /// 2
    } else if (key == 'c') {
        e.int; /// 3
    }
});
```

### 字典值不存在

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'].int; /// null
```

### 设置字典的值

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'] = JSON(4);
json['d'].int; /// 4

json['d'] = JSON('5');
json['d'].int; /// '5'

json['d'] = 5;
json['d'].int; /// 5
```

### 获取对应的Key的值是否存在

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['a'].exists(); /// true
```

### 设置数组值超出边界

```dart
final JSON json = JSON('[1,2,3]');
json[0] = 100;
json[1] = 200;
json[2] = 300;
json[99999] = 400;
json; /// [100,200,300]
```

### 设置Key不在字典存在

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'] = 100;
json; /// {'a': 1, 'b': 2, 'c': 3, 'd': 100}
```

### 通过路径更新值

```dart
final jsonText = '''
{"list":[{"user":{"name":"value"}}]}
''';
final json = JSON(jsonText);
json['list'][0]['user']['name'] = 'new value';
json; /// {"list":[{"user":{"name":"new value"}}]}
```

### 直接通过Key数组更新值

```dart
final jsonText = '''
{"list":[{"user":{"name":"value"}}]}
''';
final json = JSON(jsonText);
json[['list', 0, 'user', 'name']] = 'new value';
json; /// {"list":[{"user":{"name":"new value"}}]}
```

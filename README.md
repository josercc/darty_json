一款仿照 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 的 Dart 数据解析库(An imitation of [swiftyjson](https://github.com/SwiftyJSON/SwiftyJSON)Dart data parsing library)

## 为什么要开发这个库？(Why develop this library?)

因为有一些场景直接通过 JSONObject 取值更加方便。(Because it is more convenient to get values directly through jsonobject in some scenarios.)
比如下面的一串JSON字符串(For example, the following string of JSON strings)

```json
{"a":1,"b":2,"c":3}
```

如果按照系统自带的获取对应的值(If the corresponding value is obtained according to the system's own)

```dart
int? a = jsonObject['a'] as int?;
```

此时如果返回的数据变更如下(At this time, if the returned data is changed as follows)

```json
{"a":'1',"b":'2',"c":'3'}

{"a":{},"b":{},"c":{}}
```

之前的代码就会报错(The previous code will report an error)

还有很多情况，系统的 JSONObject 是做不到的。我们看一下通过这个库可以干什么吧。(In many other cases, the jsonobject of the system cannot be done. Let's see what we can do through this library.)

### 直接从数组获取 Double 值(Get the double value directly from the array)

```dart
final value = JSON([1])[0].doubleValue

/// 此时 value 是 1(At this point, value is 1)
```

### 从一组对象获取名字组成数组(Get names from a set of objects to form an array)

```dart
final jsonText = '''
      [{"name":"Google","url":"http://www.google.com"},{"name":"Baidu","url":"http://www.baidu.com"},{"name":"SoSo","url":"http://www.SoSo.com"}]
      ''';
final json = JSON(jsonText);
final names =
    json.listValue.map((e) => JSON(e)['name'].stringValue).toList();
/// 此时 names 是 ['Google', 'Baidu', 'SoSo'](At this time, the names are ['Google', 'Baidu', 'soso'])
```

### 从字典获取对应的值(Get the corresponding value from the dictionary)

```dart
final jsonText = '''
      {"name":"Google","url":"http://www.google.com"}
      ''';
final name = JSON(jsonText)['name'].stringValue;
/// 此时 name 值 Google(At this time, the name value is Google)
```

### 根据路径获取对应的值(Get the corresponding value according to the path)

```dart
final jsonText = '''
[{"list":[{"name":"king"}]}]
''';
final keyPaths = [0, 'list', 0, 'name'];
final name = JSON(jsonText)[keyPaths].stringValue;
final name1 = JSON(jsonText)[0]['list'][0]['name'].stringValue
/// 此时 name 和 name1 的值都是 king(At this time, the values of name and name1 are king)
```

### 类型转换(Type conversion)

```dart
JSON(1).stringValue; /// '1'
JSON(1.1).stringValue; /// '1.1'
JSON(true).intValue; /// 1
JSON('1').stringValue; /// '1'
```

### 超出边界取值(Value beyond boundary)

```dart
final JSON json = JSON('[1,2,3]');
json[3].int; /// null
```

### 循环打印数组元素(Loop print array elements)

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

### 循环打印字典(Circular printing dictionary)

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

### 字典值不存在(Dictionary value does not exist)

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'].int; /// null
```

### 设置字典的值(Sets the value of the dictionary)

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'] = JSON(4);
json['d'].int; /// 4

json['d'] = JSON('5');
json['d'].int; /// '5'

json['d'] = 5;
json['d'].int; /// 5
```

### 获取对应的Key的值是否存在(Get whether the value of the corresponding key exists)

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['a'].exists(); /// true
```

### 设置数组值超出边界(Set array value out of bounds)

```dart
final JSON json = JSON('[1,2,3]');
json[0] = 100;
json[1] = 200;
json[2] = 300;
json[99999] = 400;
json; /// [100,200,300]
```

### 设置Key不在字典存在(The setting key does not exist in the dictionary)

```dart
final JSON json = JSON('{"a":1,"b":2,"c":3}');
json['d'] = 100;
json; /// {'a': 1, 'b': 2, 'c': 3, 'd': 100}
```

### 通过路径更新值(Update value by path)

```dart
final jsonText = '''
{"list":[{"user":{"name":"value"}}]}
''';
final json = JSON(jsonText);
json['list'][0]['user']['name'] = 'new value';
json; /// {"list":[{"user":{"name":"new value"}}]}
```

### 直接通过Key数组更新值(Update the value directly through the key array)

```dart
final jsonText = '''
{"list":[{"user":{"name":"value"}}]}
''';
final json = JSON(jsonText);
json[['list', 0, 'user', 'name']] = 'new value';
json; /// {"list":[{"user":{"name":"new value"}}]}
```

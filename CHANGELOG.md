- 1.0.1

  fix 1.0.0 error

- 1.0.0

  修改库名字 darty_json to darty_json_safe

  JSON 类新增as()方法转换成对应类型 unwrap()方法转换为Unwrap类 Unwarp 新增 json get属
  性转换为JSON

  修复了超出边界取值没有返回空的问题
- 0.2.0

Unwrap adds a new DefaultValue method to set the default value

```dart
final value = Unwrap(null).map((e) => "hello $e").defaultValue("");
/// value is ""
```

- 0.1.0

* New 'Unwrap' class for unpacking

```dart
String? name = "king";
Unwrap(name).map((e) => "hello $e"); /// hello king
```

- 0.0.2

* fix double to int error

- 0.0.1

* Release the first available version. For version description, refer to readme

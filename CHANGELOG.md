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


import 'package:darty_json_safe/darty_json_safe.dart';

class JSONKey {
  final JSON parentJSON;
  final dynamic key;

  const JSONKey(this.parentJSON, this.key);
}

import 'package:darty_json/darty_json.dart';

class JSONKey {
  final JSON parentJSON;
  final dynamic key;

  const JSONKey(this.parentJSON, this.key);
}

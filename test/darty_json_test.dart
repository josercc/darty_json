import 'package:darty_json_safe/darty_json.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('Getting a double from a JSON Array', () {
      final value = JSON([1])[0].doubleValue;
      expect(value, 1);
    });

    test('Getting an array of string from a JSON Array', () {
      final jsonText = '''
      [{"name":"Google","url":"http://www.google.com"},{"name":"Baidu","url":"http://www.baidu.com"},{"name":"SoSo","url":"http://www.SoSo.com"}]
      ''';
      final json = JSON(jsonText);
      final names =
          json.listValue.map((e) => JSON(e)['name'].stringValue).toList();
      expect(names, ['Google', 'Baidu', 'SoSo']);
    });

    test('Getting a string from a JSON Dictionary', () {
      final jsonText = '''
      {"name":"Google","url":"http://www.google.com"}
      ''';
      final name = JSON(jsonText)['name'].stringValue;
      expect(name, 'Google');
    });

    test('Getting a string using a path to the element', () {
      final jsonText = '''
      [{"list":[{"name":"king"}]}]
      ''';
      final keyPaths = [0, 'list', 0, 'name'];
      final name = JSON(jsonText)[keyPaths].stringValue;
      expect(name, 'king');

      expect(JSON(jsonText)[0]['list'][0]['name'].stringValue, 'king');
    });

    test('With a hard way', () {
      expect(JSON(1).stringValue, '1');
      expect(JSON(1.1).stringValue, '1.1');
      expect(JSON(true).intValue, 1);
      expect(JSON('1').stringValue, '1');
      expect(JSON({}).string, '{}');
      expect(JSON([]).string, '[]');

      expect(JSON(1).int, 1);
      expect(JSON({}).int, null);

      expect(JSON(1).numValue, 1);
    });

    /// 测试超出边界
    test('index out of range', () {
      final JSON json = JSON('[1,2,3]');
      final value =  json[3].int;
      expect(value, null);
    });

    test('test foreach list', () {
      final JSON json = JSON('[1,2,3]');
      json.forEachList((index, e) {
        if (index == 0) {
          expect(e.int, 1);
        } else if (index == 1) {
          expect(e.int, 2);
        } else if (index == 2) {
          expect(e.int, 3);
        }
      });
    });

    test('test foreach map', () {
      final JSON json = JSON('{"a":1,"b":2,"c":3}');
      json.forEachMap((key, e) {
        if (key == 'a') {
          expect(e.int, 1);
        } else if (key == 'b') {
          expect(e.int, 2);
        } else if (key == 'c') {
          expect(e.int, 3);
        }
      });
    });

    test('test key not exit', () {
      final JSON json = JSON('{"a":1,"b":2,"c":3}');
      expect(json['d'].int, null);
    });

    test('set a json value in map', () {
      final JSON json = JSON('{"a":1,"b":2,"c":3}');
      json['d'] = JSON(4);
      expect(json['d'].int, 4);

      json['d'] = JSON('5');
      expect(json['d'].int, 5);

      json['d'] = 5;
      expect(json['d'].int, 5);
    });

    test('test value is exist', () {
      final JSON json = JSON('{"a":1,"b":2,"c":3}');
      expect(json['a'].exists(), true);
    });

    test('set index out of range', () {
      final JSON json = JSON('[1,2,3]');
      json[0] = 100;
      json[1] = 200;
      json[2] = 300;
      json[99999] = 400;
      expect(json.listValue, [100, 200, 300]);
    });

    test('test set key not exit', () {
      final JSON json = JSON('{"a":1,"b":2,"c":3}');
      json['d'] = 100;
      expect(json.mapValue, {'a': 1, 'b': 2, 'c': 3, 'd': 100});
    });

    test('test set value use path', (() {
      final jsonText = '''
      {"list":[{"user":{"name":"value"}}]}
      ''';
      final json = JSON(jsonText);
      json['list'][0]['user']['name'] = 'new value';
      expect(json['list'][0]['user']['name'].stringValue, 'new value');
    }));

    test('test set value use key path', () {
      final jsonText = '''
      {"list":[{"user":{"name":"value"}}]}
      ''';
      final json = JSON(jsonText);
      json[['list', 0, 'user', 'name']] = 'new value';
      expect(json['list'][0]['user']['name'].stringValue, 'new value');
    });

    /// 测试是否是isDouble
    test('test is double', (){
      final json = JSON('1');
      expect(json.isDouble, true);
    });

    test('test is int', (){
      final json = JSON('1');
      expect(json.isInt, true);
    });

    test('test int to bool', (){
      final json = JSON('1');
      expect(json.boolValue, true);
    });

    test('test is bool', (){
      expect(JSON('1').isBool, true);
    });

    test('test is num', (){
      expect(JSON(0.0).isNum, true);
    });

    test('test is list', (){
      expect(JSON([]).isList, true);
    });

    test('test is map', (){
      expect(JSON({}).isMap, true);
    });

    test('test is string', (){
      expect(JSON('').isString, true);
    });
    
    test('to json', (){
      expect(2.json.string, '2');
      expect(2.2.json.string, '2.2');
      expect(true.json.string, 'true');
      expect({}.json.string,'{}');
      expect([].json.string, '[]');

      num number = 1;
      expect(number.json.string, '1');
    });
  });
}

/// 解包转换
class Unwrap<T> {
  /// 包的值
  final T? value;

  /// 构造函数
  /// [value] 包的值
  Unwrap(this.value);

  /// 解包构造成其他的值
  /// [callback] 构造其他值的回调
  Unwrap<S> map<S>(S? Function(T e) callback) {
    final value = this.value;
    if (value == null) return Unwrap<S>(null);
    return Unwrap<S>(callback(value));
  }

  T defaultValue(T value) {
    return this.value ?? value;
  }
}

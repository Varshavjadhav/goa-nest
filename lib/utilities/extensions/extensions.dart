import '../ui_config/app_size_config.dart';

extension CapitalizeFirst on String {
  String get capitalizeFirst {
    return isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension CamelCaseExtension on String {
  String toCamelCase() {
    return split(
      RegExp(r'[\s_-]+'),
    ).where((word) => word.isNotEmpty).map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }
}

extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension StringTrimFirstExtension on String {
  /// Always removes the first character
  String removeFirstChar() {
    if (isEmpty) return this;
    return length == 1 && this[0] == '/' ? '/' : substring(1);
  }
}

extension DateTimeExtensions on DateTime {
  String get dateOnly {
    return DateTime(day, month, year).toString().split(" ").first;
  }
}

extension SizeExtension on num {
  double get h => SizeConfig.getProportionateScreenHeight(toDouble());

  double get w => SizeConfig.getProportionateScreenWidth(toDouble());

  double get sp => SizeConfig.getProportionateTextSize(toDouble());

  double get r => SizeConfig.getProportionateRadius(toDouble());

  double get p => SizeConfig.getProportionatePadding(toDouble());
}

extension NullableStringExtension on String? {
  String orDefault(String defaultValue) {
    final value = this;
    if (value == null || value.trim().isEmpty) {
      return defaultValue;
    }
    return value;
  }
}

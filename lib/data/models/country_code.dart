class CountryCode {
  final String code;
  final String name;
  final String flag;
  final String dialCode;

  const CountryCode({
    required this.code,
    required this.name,
    required this.flag,
    required this.dialCode,
  });

  @override
  String toString() {
    return '$name ($dialCode)';
  }

  /// Factory method untuk membuat dari JSON
  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      dialCode: json['dialCode'] ?? '',
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'flag': flag,
      'dialCode': dialCode,
    };
  }
}
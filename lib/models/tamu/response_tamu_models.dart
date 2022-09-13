class ResponseTamu <T> {
  int? code;
  String? status;
  String? message;
  T? data;

  ResponseTamu(
      {required this.code,
      required this.status,
      required this.message,
      required this.data});

  factory ResponseTamu.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) map) {
    return ResponseTamu<T>(
        code: json['code'],
        status: json['status'],
        message: json['message'],
        data: map(json['data'] ?? {}));
  }
}

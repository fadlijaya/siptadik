class ResponseAgenda <T> {
  int? code;
  String? status;
  String? message;
  T? data;

  ResponseAgenda(
      {required this.code,
      required this.status,
      required this.message,
      required this.data});

  factory ResponseAgenda.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) map) {
    return ResponseAgenda<T>(
        code: json['code'],
        status: json['status'],
        message: json['message'],
        data: map(json['data'] ?? {}));
  }
}

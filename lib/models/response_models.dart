class Response {
  int? code;
  String? status;
  String? message;
  bool? data;

  Response(
      {required this.code,
      required this.status,
      required this.message,
      required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        code: json['code'],
        status: json['status'],
        message: json['message'],
        data: json['data']);
  }
}

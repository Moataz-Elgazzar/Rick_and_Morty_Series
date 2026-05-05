class ErrorModel {
  final int statusCode;
  final String errorMessage;
  ErrorModel({required this.statusCode, required this.errorMessage});

  factory ErrorModel.fromJson(Map json) {
    return ErrorModel(statusCode: json['statusCode'], errorMessage: json['errorMessage']);
  }
}

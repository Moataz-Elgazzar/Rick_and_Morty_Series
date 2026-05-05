import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';

class OriginModel {
  final String name;
  final String url;

  OriginModel({required this.name, required this.url});

  factory OriginModel.fromJson(Map<String, dynamic> json) {
    return OriginModel(
      name: json[ApiKeys.name] ,
      url: json[ApiKeys.url] ,
    );
  }
}
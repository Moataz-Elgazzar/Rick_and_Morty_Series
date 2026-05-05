import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';

class LocationModel {
  final String name;
  final String url;

  LocationModel({
    required this.name,
    required this.url,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json[ApiKeys.name],
      url: json[ApiKeys.url],
    );
  }
}
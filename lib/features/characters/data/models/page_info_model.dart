import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/page_info_entity.dart';

class PageInfoModel extends PageInfoEntity{
  PageInfoModel({required super.count, required super.pages, required super.next, required super.prev});
  factory PageInfoModel.fromJson(Map<String, dynamic> json) {
    return PageInfoModel(
      count: json[ApiKeys.count],
      pages: json[ApiKeys.pages],
      next: json[ApiKeys.next],
      prev: json[ApiKeys.prev],
    );
  }
}
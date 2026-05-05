import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';
import 'package:rick_and_morty_series/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_series/features/characters/data/models/page_info_model.dart';

class CharacterResponseModel {
  final PageInfoModel info;
  final List<CharacterModel> results;
  CharacterResponseModel({required this.info, required this.results});
  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    return CharacterResponseModel(
      info: PageInfoModel.fromJson(json[ApiKeys.info]),
      results: (json[ApiKeys.results] as List).map((character) => CharacterModel.fromJason(character)).toList(),
    );
  }
}
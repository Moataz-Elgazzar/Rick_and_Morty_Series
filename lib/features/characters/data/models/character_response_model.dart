import 'package:rick_and_morty_series/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_series/features/characters/data/models/page_info_model.dart';

class CharacterResponseModel {
  final PageInfoModel info;
  final List<CharacterModel> results;
  CharacterResponseModel({required this.info, required this.results});
}
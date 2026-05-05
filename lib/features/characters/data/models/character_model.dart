import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';
import 'package:rick_and_morty_series/features/characters/data/models/sub_models/location_model.dart';
import 'package:rick_and_morty_series/features/characters/data/models/sub_models/origin_model.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  final int id;
  final OriginModel origin;
  final LocationModel location;
  final List<String> episode;
  final String url;
  final String created;
  CharacterModel({required this.origin,required this.location,required this.episode,required this.url,required this.created, required this.id, required super.name, required super.status, required super.species, required super.type, required super.image, required super.gender});

  factory CharacterModel.fromJason(Map<String , dynamic> json){
    return CharacterModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      status: json[ApiKeys.status],
      species: json[ApiKeys.species],
      type: json[ApiKeys.type],
      image: json[ApiKeys.image],
      gender: json[ApiKeys.gender],
      origin: OriginModel.fromJson(json[ApiKeys.origin]),
      location: LocationModel.fromJson(json[ApiKeys.location]),
      episode: json[ApiKeys.episode] != null ? List<String>.from(json[ApiKeys.episode]) : [],
      url: json[ApiKeys.url],
      created: json[ApiKeys.created],
    );
  }
}

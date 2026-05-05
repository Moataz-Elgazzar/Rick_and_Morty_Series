import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_series/core/error/failure.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty_series/features/characters/domain/repositories/character_repositories.dart';

class GetAllCharacter {
  final CharacterRepositories characterRepositories;
  GetAllCharacter(this.characterRepositories);
  Future<Either<Failure, List<CharacterEntity>>> call({required int page}) async {
    return await characterRepositories.getAllCharacters(page: page);
  }
}

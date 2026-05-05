import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_series/core/error/failure.dart';
import 'package:rick_and_morty_series/features/domain/entities/character_entity.dart';

abstract class CharacterRepositories {
  Future<Either<Failure, List<CharacterEntity>>> getAllCharacters({required int page});
}
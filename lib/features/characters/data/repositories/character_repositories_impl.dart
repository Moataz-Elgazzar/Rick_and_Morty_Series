import 'package:dartz/dartz.dart';
import 'package:rick_and_morty_series/core/connection/network_info.dart';
import 'package:rick_and_morty_series/features/characters/data/datasources/get_all_character_remote_data_source.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty_series/features/characters/domain/repositories/character_repositories.dart';

class CharacterRepositoriesImpl implements CharacterRepositories {
  final NetworkInfo networkInfo;
  final GetAllCharacterRemoteDataSource allCharacterRemoteDataSource;
  CharacterRepositoriesImpl({required this.networkInfo, required this.allCharacterRemoteDataSource});
  @override
  Future<Either<Fail, List<CharacterEntity>>> getAllCharacters({required int page}) async {
    if (await networkInfo.isConnected) {
        final remoteCharacter = await allCharacterRemoteDataSource.getAllCharactersForEachPage(page);
        return Right(remoteCharacter.results); 
    }
      else {
        return Left(Fail("No Internet Connection"));
      }
  }
}

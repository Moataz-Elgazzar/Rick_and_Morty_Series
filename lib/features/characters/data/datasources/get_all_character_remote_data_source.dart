import 'package:rick_and_morty_series/core/service/dio_endpoint.dart';
import 'package:rick_and_morty_series/core/service/dio_provider.dart';
import 'package:rick_and_morty_series/features/characters/data/models/character_response_model.dart';

class GetAllCharacterRemoteDataSource {
 Future<CharacterResponseModel> getAllCharactersForEachPage(int page) async {
final response = await DioProvider.get(path: "${DioEndpoint.baseUrl}/${DioEndpoint.characterEndpoint}", queryParameters: {'page': page});
if (response.statuscode == 200){
  return CharacterResponseModel.fromJson(response.data);
}else{
  throw Exception('Failed to load characters');
}
 }
}
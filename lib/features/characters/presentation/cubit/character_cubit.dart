import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';
import 'package:rick_and_morty_series/features/characters/domain/usercases/get_all_character.dart';
import 'package:rick_and_morty_series/features/characters/presentation/cubit/character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit(this.useCase) : super(CharacterInitialState());

  final GetAllCharacter useCase;

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasNext = true;

  List<CharacterEntity> characters = [];
  List<CharacterEntity> allCharactersBackup = [];

  Future<void> getFirstPage() async {
    emit(CharacterLoadingState());

    currentPage = 1;
    hasNext = true;
    characters = [];

    final result = await useCase.call(page: currentPage);

    result.fold((f) => emit(CharacterErrorState(message: f.toString())), (data) {
      characters = data;
      allCharactersBackup = data;
      emit(CharacterSuccessState(characters: characters));
    });
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasNext) return;

    isLoadingMore = true;

    final nextPage = currentPage + 1;

    final result = await useCase.call(page: nextPage);

    result.fold(
      (f) {
        isLoadingMore = false;
      },
      (data) {
        currentPage = nextPage;

        if (data.isEmpty) {
          hasNext = false;
        } else {
          characters.addAll(data);
        }

        isLoadingMore = false;

        // مهم: emit lightweight update
        emit(CharacterSuccessState(characters: List.from(characters)));
      },
    );
  }

  void searchCharacters(String value) {
    if (value.isEmpty) {
      emit(CharacterSuccessState(characters: allCharactersBackup));
      return;
    }

    final filtered = allCharactersBackup.where((c) => c.name.toLowerCase().contains(value.toLowerCase())).toList();

    emit(CharacterSuccessState(characters: filtered));
  }
}
 
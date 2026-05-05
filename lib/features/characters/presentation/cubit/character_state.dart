class CharacterState {}

class CharacterInitialState extends CharacterState {}


class CharacterLoadingState extends CharacterState {}


class CharacterSuccessState extends CharacterState {
  final List characters;

  CharacterSuccessState({ required this.characters});
}

class CharacterErrorState extends CharacterState {
  final String message;

  CharacterErrorState({ required this.message});
}
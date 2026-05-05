import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_series/features/characters/data/models/character_model.dart';
import 'package:rick_and_morty_series/features/characters/presentation/pages/character_details_screen.dart';
import 'package:rick_and_morty_series/features/characters/presentation/pages/main_screen.dart';

class Routs {
  static const String mainScreen = "/";
  static const String characterScreen = "/character_screen";
  static const String locationScreen = "/location_screen";
  static const String settingsScreen = "/settings_screen";
  static const String characterDetailsScreen = "/character_details_screen";

  static GoRouter route = GoRouter(
    routes: [
      GoRoute(path: mainScreen, builder: (context, state) => const MainScreen()),
      GoRoute(
        path: characterDetailsScreen,
        builder: (context, state) {
          final character = state.extra;
          return CharacterDetailsScreen(character: character as CharacterModel);
        },
      ),
    ],
  );
}

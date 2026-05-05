import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_series/core/connection/network_info.dart';
import 'package:rick_and_morty_series/core/utils/colors.dart';
import 'package:rick_and_morty_series/features/characters/data/datasources/get_all_character_remote_data_source.dart';
import 'package:rick_and_morty_series/features/characters/data/repositories/character_repositories_impl.dart';
import 'package:rick_and_morty_series/features/characters/domain/usercases/get_all_character.dart';
import 'package:rick_and_morty_series/features/characters/presentation/cubit/character_cubit.dart';
import 'package:rick_and_morty_series/features/characters/presentation/pages/character_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final CharacterCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = CharacterCubit(
      GetAllCharacter(
        characterRepositories: CharacterRepositoriesImpl(networkInfo: NetworkInputImpl(DataConnectionChecker()), allCharacterRemoteDataSource: GetAllCharacterRemoteDataSource()),
      ),
    );

    cubit.getFirstPage();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  final List<Widget> screens = [
    const CharactersScreen(),
    //LocationsScreen(),
    //SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,

        body: screens[currentIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: AppColors.cardColor.withOpacity(0.7),
            border: Border(top: BorderSide(color: AppColors.primaryGreen.withOpacity(0.2))),
            boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.15), blurRadius: 20)],
          ),

          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            backgroundColor: Colors.transparent,
            elevation: 0,

            selectedItemColor: AppColors.primaryGreen,
            unselectedItemColor: Colors.white54,

            type: BottomNavigationBarType.fixed,

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person_search), label: "Characters"),
              BottomNavigationBarItem(icon: Icon(Icons.public), label: "Locations"),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}

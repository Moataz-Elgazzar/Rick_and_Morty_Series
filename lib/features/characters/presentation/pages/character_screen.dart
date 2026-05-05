import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_series/core/routes/navigator.dart';
import 'package:rick_and_morty_series/core/routes/routs.dart';
import 'package:rick_and_morty_series/core/utils/colors.dart';
import 'package:rick_and_morty_series/features/characters/presentation/cubit/character_cubit.dart';
import 'package:rick_and_morty_series/features/characters/presentation/cubit/character_state.dart';
import 'package:rick_and_morty_series/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_and_morty_series/features/characters/presentation/widgets/search_bar.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        context.read<CharacterCubit>().loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CharacterCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Rick & Morty Multiverse", style: TextStyle(color: AppColors.primaryGreen.withOpacity(0.8))),
        centerTitle: false,
        actions: [ClipRRect(child: Image.asset("assets/images/Border.png", width: 50, height: 50, fit: BoxFit.cover))],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NeonSearchBar(onChanged: (value) => cubit.searchCharacters(value)),

            Expanded(
              child: BlocBuilder<CharacterCubit, CharacterState>(
                builder: (context, state) {
                  if (state is CharacterLoadingState && cubit.characters.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CharacterErrorState) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.white)),
                    );
                  }

                  if (state is CharacterSuccessState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _controller,
                      itemCount: state.characters.length + (cubit.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.characters.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final character = state.characters[index];

                        return NeonCharacterCard(
                          character: character,
                          onTap: () {
                            pushTo(context, Routs.characterDetailsScreen, extra: character);
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

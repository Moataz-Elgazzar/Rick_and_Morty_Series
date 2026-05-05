import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_series/core/utils/colors.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';

class header extends StatelessWidget {
  final CharacterEntity character;

  const header({super.key, required this.character});

  Color getStatusColor() {
    switch (character.status.toLowerCase()) {
      case "alive":
        return AppColors.primaryGreen;
      case "dead":
        return AppColors.errorRed;
      default:
        return AppColors.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "C-137 Prototype",
            style: TextStyle(
              color: color,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            character.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _badge(character.status, color),
              const SizedBox(width: 10),
              _badge(character.species, Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
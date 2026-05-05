import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';

class statsGrid extends StatelessWidget {
  final CharacterEntity character;

  const statsGrid({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _glassCard("Species", character.species),
          _glassCard("Gender", character.gender),
          _glassCard("Origin", character.type.isEmpty ? "Unknown" : character.type),
        ],
      ),
    );
  }

  Widget _glassCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF050B18).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FF41).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF41).withOpacity(0.08),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Colors {
}
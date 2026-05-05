import 'package:flutter/material.dart';
import 'package:rick_and_morty_series/core/utils/colors.dart';
import 'package:rick_and_morty_series/features/characters/domain/entities/character_entity.dart';

class NeonCharacterCard extends StatelessWidget {
  final CharacterEntity character;
  final VoidCallback? onTap;

  const NeonCharacterCard({super.key, required this.character, this.onTap});

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 20, spreadRadius: 1)],
        ),
        child: Row(
          children: [
            // 🖼️ Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.cardColor.withOpacity(0.7), AppColors.cardColor.withOpacity(0.3)]),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: color.withOpacity(0.4)),
                boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 30, spreadRadius: 2)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(character.image, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(width: 12),

            // 📄 Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text("${character.species} • ${character.gender}", style: const TextStyle(color: Colors.white54, fontSize: 12)),

                  const SizedBox(height: 8),

                  // 🔥 Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: color, blurRadius: 8)],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          character.status.toUpperCase(),
                          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ➡️ Arrow glow
            Icon(Icons.chevron_right, color: color.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}

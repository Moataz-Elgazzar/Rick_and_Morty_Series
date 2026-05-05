import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class episodesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final episodes = [
      "S01E01 - Pilot",
      "S01E06 - Rick Potion #9",
      "S03E01 - Rickshank Redemption",
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Appears In",
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...episodes.map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF050B18).withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00FF41).withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.movie_filter, color: Color(0xFF00FF41)),
                  const SizedBox(width: 10),
                  Text(e, style: const TextStyle(color: Color(0xFFFFFFFF))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
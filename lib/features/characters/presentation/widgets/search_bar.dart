import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rick_and_morty_series/core/utils/colors.dart';

class NeonSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const NeonSearchBar({super.key, this.onChanged});

  @override
  State<NeonSearchBar> createState() => _NeonSearchBarState();
}

class _NeonSearchBarState extends State<NeonSearchBar> {
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onChanged?.call(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.08), blurRadius: 20)],
      ),
      child: TextField(
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Scan multiverse for entities...",
          hintStyle: TextStyle(color: Colors.white54),
          icon: Icon(Icons.search, color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}

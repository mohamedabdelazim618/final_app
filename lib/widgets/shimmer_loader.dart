import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppState>().themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0D8C8),
        highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F0E8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.1,
            crossAxisSpacing: 12, mainAxisSpacing: 12,
          ),
          itemCount: 8,
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

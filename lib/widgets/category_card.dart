import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/app_state.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;
  const CategoryCard(
      {super.key,
      required this.category,
      required this.index,
      required this.onTap});

  static const _gradients = [
    [Color(0xFF1B5E20), Color(0xFF2E7D32)],
    [Color(0xFF0D47A1), Color(0xFF1565C0)],
    [Color(0xFF4A148C), Color(0xFF6A1B9A)],
    [Color(0xFF880E4F), Color(0xFFAD1457)],
    [Color(0xFFBF360C), Color(0xFFE64A19)],
    [Color(0xFF006064), Color(0xFF00838F)],
    [Color(0xFF1A237E), Color(0xFF283593)],
    [Color(0xFF33691E), Color(0xFF558B2F)],
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isFav = state.isFavorite(category.id);
    final g = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: g),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: g[0].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Stack(
          children: [
            Positioned(right: -20, bottom: -20, child: _circle(80, 0.08)),
            Positioned(left: -10, top: -10, child: _circle(55, 0.05)),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => state.toggleFavorite(category.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_outline,
                          color: isFav ? Colors.red.shade300 : Colors.white54,
                          size: 20,
                        ),
                      ),
                      Text(category.iconEmoji,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Text(
                    category.title,
                    style: GoogleFonts.cairo(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, curve: Curves.easeOut);
  }

  Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(opacity)),
      );
}

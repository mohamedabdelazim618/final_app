import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import 'athkar_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDark = state.themeMode == ThemeMode.dark;
    final favs  = state.favoriteCategories;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        title: Text('المفضلة',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: favs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  Text('لا توجد أذكار مفضلة',
                      style: GoogleFonts.cairo(
                          fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('اضغط على ❤️ في أي بطاقة لإضافتها',
                      style: GoogleFonts.cairo(
                          fontSize: 14, color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favs.length,
              itemBuilder: (ctx, i) => CategoryCard(
                category: favs[i],
                index: i,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AthkarScreen(category: favs[i])),
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../widgets/shimmer_loader.dart';
import 'athkar_screen.dart';
import 'favorites_screen.dart';
import 'tasbih_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: IndexedStack(index: _tab, children: [
        _buildMain(state),
        const FavoritesScreen(),
        const TasbihScreen(),
      ]),
      bottomNavigationBar: _buildNav(state),
    );
  }

  Widget _buildMain(AppState state) {
    final isDark = state.themeMode == ThemeMode.dark;
    return CustomScrollView(slivers: [
      // ── SliverAppBar ──
      SliverAppBar(
        expandedHeight: 175,
        floating: false,
        pinned: true,
        backgroundColor: isDark ? AppTheme.bgDark : AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: Icon(
                state.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white),
            onPressed: state.toggleTheme,
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppTheme.bgDark, const Color(0xFF1A3A1A)]
                    : [AppTheme.primaryGreen, AppTheme.lightGreen],
              ),
            ),
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text('☪',
                        style:
                            TextStyle(fontSize: 36, color: AppTheme.accentGold))
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 6),
                Text('أذكار اليوم والليلة',
                        style: GoogleFonts.scheherazadeNew(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3),
                Text('أذكار من الكتاب والسنة',
                        style: GoogleFonts.cairo(
                            fontSize: 13, color: Colors.white70))
                    .animate()
                    .fadeIn(delay: 200.ms),
              ],
            )),
          ),
        ),
      ),

      // ── Search ──
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: TextField(
          controller: _searchCtrl,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: 'ابحث عن ذكر...',
            hintTextDirection: TextDirection.rtl,
            hintStyle: GoogleFonts.cairo(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _query = '');
                    })
                : null,
            filled: true,
            fillColor: isDark ? AppTheme.bgCardDark : Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      )),

      // ── Quick chips ──
      SliverToBoxAdapter(
          child: SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _chip('🌅 الصباح', 27, state),
            _chip('🌙 المساء', 27, state),
            _chip('😴 النوم', 28, state),
            _chip('🕌 الصلاة', 25, state),
            _chip('🙏 الاستغفار', 129, state),
          ],
        ),
      )),

      // ── Grid ──
      if (state.isLoading)
        SliverToBoxAdapter(child: ShimmerLoader())
      else if (state.error != null)
        SliverToBoxAdapter(child: _buildError(state))
      else
        _buildGrid(state),
    ]);
  }

  Widget _chip(String label, int id, AppState state) {
    return GestureDetector(
      onTap: () {
        final cat = state.categories.firstWhere((c) => c.id == id,
            orElse: () => state.categories.first);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => AthkarScreen(category: cat)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: context.watch<AppState>().themeMode == ThemeMode.dark
              ? AppTheme.bgCardDark
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.5), width: 1.5),
        ),
        child: Text(label,
            style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.watch<AppState>().themeMode == ThemeMode.dark
                    ? Colors.white
                    : AppTheme.primaryGreen)),
      ),
    );
  }

  Widget _buildGrid(AppState state) {
    final items = _query.isEmpty
        ? state.categories
        : state.categories.where((c) => c.title.contains(_query)).toList();
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 100),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => CategoryCard(
            category: items[i],
            index: i,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AthkarScreen(category: items[i]))),
          ),
          childCount: items.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.1,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
      ),
    );
  }

  Widget _buildError(AppState state) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('تعذّر تحميل البيانات',
                style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state.fetchCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
            ),
          ]),
        ),
      );

  Widget _buildNav(AppState state) {
    final isDark = state.themeMode == ThemeMode.dark;
    return NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (i) => setState(() => _tab = i),
      backgroundColor: isDark ? AppTheme.bgCardDark : Colors.white,
      indicatorColor: AppTheme.primaryGreen.withOpacity(0.15),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book, color: AppTheme.primaryGreen),
          label: 'الأذكار',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite, color: AppTheme.primaryGreen),
          label: 'المفضلة',
        ),
        NavigationDestination(
          icon: Icon(Icons.circle_outlined),
          selectedIcon: Icon(Icons.adjust, color: AppTheme.primaryGreen),
          label: 'السبحة',
        ),
      ],
    );
  }
}

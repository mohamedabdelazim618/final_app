import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/category.dart';
import '../models/dhikr.dart';
import '../services/api_service.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dhikr_card.dart';

class AthkarScreen extends StatefulWidget {
  final Category category;
  const AthkarScreen({super.key, required this.category});
  @override
  State<AthkarScreen> createState() => _AthkarScreenState();
}

class _AthkarScreenState extends State<AthkarScreen> {
  List<Dhikr> _athkar = [];
  bool _isLoading = true;
  String? _error;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _playingId;

  String _safe(String url) =>
      kIsWeb ? url.replaceFirst('http://', 'https://') : url;

  @override
  void initState() {
    super.initState();
    _load();
    _audioPlayer.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      setState(() => _isPlaying = s == PlayerState.playing);
      if (s == PlayerState.completed) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() { _audioPlayer.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      final list = await ApiService.instance.fetchAthkar(widget.category.textUrl);
      if (mounted) setState(() { _athkar = list; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _isLoading = false; });
    }
  }

  Future<void> _toggle(String url, int id) async {
    try {
      if (_playingId == id && _isPlaying) {
        await _audioPlayer.pause(); setState(() => _playingId = null);
      } else {
        setState(() => _playingId = id);
        await _audioPlayer.play(UrlSource(_safe(url)));
      }
    } catch (_) {
      setState(() => _playingId = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('تعذّر تشغيل الصوت', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state  = context.watch<AppState>();
    final isDark = state.themeMode == ThemeMode.dark;
    final isFav  = state.isFavorite(widget.category.id);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: CustomScrollView(slivers: [
        // ── AppBar ──
        SliverAppBar(
          expandedHeight: 150, pinned: true,
          backgroundColor: isDark ? AppTheme.bgDark : AppTheme.primaryGreen,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline,
                  color: isFav ? Colors.red : Colors.white),
              onPressed: () => state.toggleFavorite(widget.category.id),
            ),
            if (_athkar.isNotEmpty)
              IconButton(
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, color: Colors.white),
                onPressed: _isPlaying
                    ? () => _audioPlayer.stop()
                    : () async {
                        final f = _athkar.firstWhere((d) => d.audioUrl.isNotEmpty,
                            orElse: () => _athkar.first);
                        if (f.audioUrl.isEmpty) return;
                        setState(() => _playingId = f.id);
                        await _audioPlayer.play(UrlSource(_safe(f.audioUrl)));
                      },
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: isDark
                      ? [AppTheme.bgCardDark, AppTheme.bgDark]
                      : [AppTheme.primaryGreen, AppTheme.lightGreen],
                ),
              ),
              child: SafeArea(
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(widget.category.iconEmoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(widget.category.title,
                        style: GoogleFonts.scheherazadeNew(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center),
                  ],
                )),
              ),
            ),
          ),
        ),

        // ── Web notice ──
        if (kIsWeb)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'قد لا يعمل الصوت على الويب بسبب سياسة HTTPS.',
                  style: GoogleFonts.cairo(fontSize: 11, color: Colors.amber.shade900),
                  textAlign: TextAlign.right,
                )),
              ]),
            ),
          ),

        // ── Body ──
        if (_isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)))
        else if (_error != null)
          SliverFillRemaining(child: _buildError())
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => DhikrCard(
                  dhikr: _athkar[i], index: i,
                  isPlaying: _playingId == _athkar[i].id && _isPlaying,
                  onPlayTap: _athkar[i].audioUrl.isNotEmpty
                      ? () => _toggle(_athkar[i].audioUrl, _athkar[i].id)
                      : null,
                  onCopyTap: () {
                    Clipboard.setData(ClipboardData(text: _athkar[i].arabicText));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('تم النسخ', style: GoogleFonts.cairo()),
                      backgroundColor: AppTheme.primaryGreen,
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ));
                  },
                ),
                childCount: _athkar.length,
              ),
            ),
          ),
      ]),
    );
  }

  Widget _buildError() => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.error_outline, size: 64, color: Colors.grey),
      const SizedBox(height: 16),
      Text('تعذّر تحميل الأذكار',
          style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey)),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _load,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
      ),
    ],
  ));
}

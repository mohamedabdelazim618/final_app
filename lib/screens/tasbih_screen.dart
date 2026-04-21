import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});
  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count  = 0;
  int _target = 33;
  int _rounds = 0;
  int _selected = 0;

  late AnimationController _animCtrl;
  late Animation<double>   _scaleAnim;

  static const _adhkar = [
    {'text': 'سُبْحَانَ اللَّهِ',            'target': 33},
    {'text': 'اَلْحَمْدُ لِلَّهِ',           'target': 33},
    {'text': 'اللَّهُ أَكْبَرُ',             'target': 34},
    {'text': 'لَا إِلَهَ إِلَّا اللَّهُ',   'target': 100},
    {'text': 'أَسْتَغْفِرُ اللَّهَ',         'target': 100},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.91).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _tap() {
    HapticFeedback.lightImpact();
    _animCtrl.forward().then((_) => _animCtrl.reverse());
    setState(() {
      _count++;
      if (_count >= _target) {
        _rounds++;
        _count = 0;
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _reset() => setState(() { _count = 0; _rounds = 0; });

  void _selectAdhkar(int i) => setState(() {
    _selected = i;
    _target   = _adhkar[i]['target'] as int;
    _count    = 0;
    _rounds   = 0;
  });

  @override
  Widget build(BuildContext context) {
    final state  = context.watch<AppState>();
    final isDark = state.themeMode == ThemeMode.dark;
    final progress = _count / _target;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        title: Text('السبحة الإلكترونية',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'إعادة تعيين'),
        ],
      ),
      body: Column(children: [
        // ── Adhkar selector chips ──
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _adhkar.length,
            itemBuilder: (_, i) {
              final sel = i == _selected;
              return GestureDetector(
                onTap: () => _selectAdhkar(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppTheme.primaryGreen
                        : (isDark ? AppTheme.bgCardDark : Colors.white),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: sel
                          ? AppTheme.primaryGreen
                          : AppTheme.accentGold.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    _adhkar[i]['text'] as String,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 14,
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      color: sel
                          ? Colors.white
                          : (isDark ? Colors.white : AppTheme.textDark),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Counter ──
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rounds display
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('الجولات: ',
                    style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey)),
                Text('$_rounds',
                    style: GoogleFonts.cairo(
                        fontSize: 18, fontWeight: FontWeight.bold,
                        color: AppTheme.accentGold)),
              ]),
              const SizedBox(height: 20),

              // Ring + button
              Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 250, height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    backgroundColor:
                        isDark ? Colors.white12 : Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.primaryGreen),
                  ),
                ),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: GestureDetector(
                    onTap: _tap,
                    child: Container(
                      width: 210, height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(colors: [
                          Color(0xFF4CAF50),
                          Color(0xFF2E7D32),
                          Color(0xFF1B5E20),
                        ]),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.45),
                            blurRadius: 24, spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$_count',
                              style: GoogleFonts.cairo(
                                  fontSize: 68,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white)),
                          Text('من $_target',
                              style: GoogleFonts.cairo(
                                  fontSize: 15, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 28),

              // Current dhikr label
              Text(
                _adhkar[_selected]['text'] as String,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.primaryGreen,
                ),
              ).animate(key: ValueKey(_selected)).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 10),
              Text('اضغط على الدائرة للتسبيح',
                  style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
      ]),
    );
  }
}

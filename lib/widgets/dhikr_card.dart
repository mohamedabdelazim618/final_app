import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class DhikrCard extends StatefulWidget {
  final Dhikr dhikr;
  final int index;
  final bool isPlaying;
  final VoidCallback? onPlayTap;
  final VoidCallback onCopyTap;
  const DhikrCard({super.key, required this.dhikr, required this.index,
      required this.isPlaying, this.onPlayTap, required this.onCopyTap});
  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  int _tapCount = 0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppState>().themeMode == ThemeMode.dark;
    final repeat = widget.dhikr.repeat;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.bgCardDark : AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Header row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  if (widget.onPlayTap != null)
                    _iconBtn(widget.isPlaying ? Icons.stop : Icons.play_arrow,
                        AppTheme.primaryGreen, widget.onPlayTap!),
                  const SizedBox(width: 4),
                  _iconBtn(Icons.copy_outlined, Colors.grey, widget.onCopyTap),
                ]),
                Row(children: [
                  if (repeat > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.5)),
                      ),
                      child: Text('$repeat×',
                          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(color: AppTheme.primaryGreen, borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center,
                    child: Text('${widget.index + 1}',
                        style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
              ],
            ),
          ),

          // ── Arabic text ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: Text(widget.dhikr.arabicText,
                    style: GoogleFonts.scheherazadeNew(fontSize: 22, height: 1.9,
                        color: isDark ? Colors.white : AppTheme.textDark),
                    textAlign: TextAlign.justify, maxLines: 4, overflow: TextOverflow.ellipsis),
                secondChild: Text(widget.dhikr.arabicText,
                    style: GoogleFonts.scheherazadeNew(fontSize: 22, height: 1.9,
                        color: isDark ? Colors.white : AppTheme.textDark),
                    textAlign: TextAlign.justify),
              ),
            ),
          ),

          // ── Expand toggle ──
          if (widget.dhikr.arabicText.length > 200)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(children: [
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.primaryGreen, size: 18),
                  Text(_expanded ? 'أقل' : 'المزيد',
                      style: GoogleFonts.cairo(fontSize: 13, color: AppTheme.primaryGreen)),
                ]),
              ),
            ),

          // ── Repeat dots counter ──
          if (repeat > 1) ...[
            const Divider(height: 1, color: Color(0xFFEEE8D8)),
            GestureDetector(
              onTap: () => setState(() => _tapCount = (_tapCount + 1) % (repeat + 1)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.06),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(repeat, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i < _tapCount ? 14 : 10,
                    height: i < _tapCount ? 14 : 10,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _tapCount ? AppTheme.primaryGreen : Colors.grey.shade300,
                    ),
                  )),
                ),
              ),
            ),
          ] else
            const SizedBox(height: 12),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: widget.index * 60))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) =>
      InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(8),
        child: Padding(padding: const EdgeInsets.all(4), child: Icon(icon, size: 22, color: color)),
      );
}

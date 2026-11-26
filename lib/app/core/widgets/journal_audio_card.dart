import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/core/services/hive_service.dart';
import 'package:open_jot/app/core/widgets/audio_spectrum_waveform.dart';

String formatAudioDuration(Duration duration) {
  if (duration == Duration.zero) {
    return AppConstants.emptyDuration;
  }
  final totalSeconds = duration.inSeconds.clamp(0, 359999);
  final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Shared layout shell for both music and voice recording cards.
class _JournalAudioCardShell extends StatelessWidget {
  const _JournalAudioCardShell({
    required this.decoration,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.compact,
    this.middleContent,
  });

  final BoxDecoration decoration;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final bool compact;
  final Widget? middleContent;

  @override
  Widget build(BuildContext context) {
    final bool hasMiddle = middleContent != null;
    final double iconCircleSize = compact
        ? (hasMiddle ? 26.w : 36.w)
        : (hasMiddle ? 40.w : 52.w);
    final double iconSize = compact
        ? (hasMiddle ? 14.sp : 19.sp)
        : (hasMiddle ? 22.sp : 28.sp);

    final iconBadge = Container(
      width: iconCircleSize,
      height: iconCircleSize,
      decoration: BoxDecoration(
        color: iconBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );

    return Container(
      decoration: decoration,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7.w : 14.w,
        vertical: compact ? 8.h : 18.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasMiddle) ...[
            iconBadge,
            Expanded(
              child: Center(child: middleContent),
            ),
          ] else
            Expanded(
              child: Center(child: iconBadge),
            ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: compact ? 10.sp : 13.5.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstants.font,
              decoration: TextDecoration.none,
              letterSpacing: -0.2,
            ),
          ),
          if (!compact) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.font,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Music / external audio card with centered icon badge above bottom title.
class JournalMusicCardContent extends StatelessWidget {
  const JournalMusicCardContent({
    super.key,
    required this.title,
    this.duration,
    this.compact = false,
  });

  final String title;
  final Duration? duration;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hasDuration = duration != null && duration! > Duration.zero;
    return _JournalAudioCardShell(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade900,
            const Color(0xFF14111D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      icon: Icons.music_note_rounded,
      iconColor: Colors.white,
      iconBackgroundColor: Colors.white.withOpacity(0.14),
      title: title,
      titleColor: Colors.white,
      subtitle: hasDuration
          ? formatAudioDuration(duration!)
          : AppConstants.audioTrack,
      subtitleColor: Colors.white.withOpacity(0.72),
      compact: compact,
    );
  }
}

/// Theme-adaptive voice recording card displaying mic badge and static spectrum.
class JournalRecordingCardContent extends StatelessWidget {
  const JournalRecordingCardContent({
    super.key,
    required this.title,
    required this.duration,
    this.filePath,
    this.compact = false,
  });

  final String title;
  final Duration duration;
  final String? filePath;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surfaceColor =
        isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final Color borderColor =
        isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFE5E5EA);
    final Color inkPrimary =
        isDark ? Colors.white : const Color(0xFF1C1C1E);
    final Color inkSecondary =
        isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366);
    final Color appleRecordRed =
        isDark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30);

    List<double>? levels;
    if (filePath != null && Get.isRegistered<HiveService>()) {
      levels = AudioSpectrumWaveform.loadWaveform(
        Get.find<HiveService>(),
        filePath!,
      );
    }
    levels ??= AudioSpectrumWaveform.fallbackLevelsForKey(
      filePath ?? title,
      targetCount: compact ? 16 : 32,
    );

    return _JournalAudioCardShell(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      icon: Icons.mic_rounded,
      iconColor: appleRecordRed,
      iconBackgroundColor:
          appleRecordRed.withOpacity(isDark ? 0.18 : 0.12),
      title: title,
      titleColor: inkPrimary,
      subtitle: formatAudioDuration(duration),
      subtitleColor: inkSecondary,
      compact: compact,
      middleContent: AudioSpectrumWaveform(
        levels: levels,
        activeColor: inkPrimary.withOpacity(isDark ? 0.88 : 0.82),
        inactiveColor: isDark
            ? Colors.white.withOpacity(0.22)
            : inkSecondary.withOpacity(0.28),
        barWidth: compact ? 1.8 : 2.8,
        minBarHeight: 2.5,
        height: compact ? 16.h : 34.h,
      ),
    );
  }
}

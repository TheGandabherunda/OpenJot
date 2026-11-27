import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/utils/bloub_mood.dart';
import 'package:open_jot/app/utils/mood_helper.dart';

void main() {
  group('BloubMood & MoodHelper', () {
    test('MoodHelper generates 7 distinct flat black circular Bloub SVGs',
        () async {
      await MoodHelper.init();

      final svgs = List<String>.generate(7, MoodHelper.getMoodSvgString);
      for (final svg in svgs) {
        expect(svg, contains('<svg'));
        expect(svg, contains('fill="${BloubGeometry.bodyHex}"'));
        expect(svg, isNot(contains('radialGradient')));
        // Ensure flutter_svg parses every generated SVG cleanly
        final pictureInfo = await vg.loadPicture(SvgStringLoader(svg), null);
        expect(pictureInfo.size.width, equals(512.0));
        expect(pictureInfo.size.height, equals(512.0));
        pictureInfo.picture.dispose();
      }
      expect(svgs.toSet().length, equals(7));
      // Mood 0: crying blue tears; Mood 1: sigh cloud; Mood 2: sleepy blue Z;
      // Mood 3: circular eyes; Mood 5: cool sunglasses + sparkle; Mood 6: tongue.
      expect(svgs[0], contains(BloubGeometry.blueAccentHex));
      expect(svgs[1], contains(BloubGeometry.sighHex));
      expect(svgs[2], contains(BloubGeometry.blueAccentHex));
      expect(svgs[3], contains('<circle'));
      expect(svgs[5], contains(BloubGeometry.sparkleHex));
      expect(svgs[6], contains(BloubGeometry.tongueHex));
    });

    test('BloubGeometry samples fractional progress and paints all effect phases cleanly',
        () async {
      for (final p in [0.0, 0.5, 1.0, 2.0, 3.0, 4.75, 5.0, 6.0]) {
        final pose = BloubGeometry.sampleMoodProgress(p);
        for (final phase in [0.05, 0.22, 0.45, 0.72]) {
          for (final blink in [1.0, 0.0]) {
            final recorder = ui.PictureRecorder();
            final canvas = Canvas(recorder);
            BloubGeometry.paint(
              canvas,
              const Size(180, 180),
              pose: pose,
              blinkFactor: blink,
              effectPhase: phase,
            );
            final picture = recorder.endRecording();
            final image = await picture.toImage(180, 180);
            expect(image.width, equals(180));
            expect(image.height, equals(180));
            image.dispose();
            picture.dispose();
          }
        }
      }

      // Also verify flat mood-colored fillColors paint cleanly for all 7 moods
      final colors = [
        const Color(0xFFAD46FF),
        const Color(0xFFF6339A),
        const Color(0xFF00A6F4),
        const Color(0xFF00BBA7),
        const Color(0xFF00BC7D),
        const Color(0xFF00C950),
        const Color(0xFFF0B100),
      ];
      for (var i = 0; i < 7; i++) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        BloubGeometry.paint(
          canvas,
          const Size(180, 180),
          pose: BloubGeometry.moodPoses[i],
          fillColor: colors[i],
          effectPhase: 0.35,
        );
        final picture = recorder.endRecording();
        final image = await picture.toImage(180, 180);
        expect(image.width, equals(180));
        image.dispose();
        picture.dispose();
      }
    });

    testWidgets(
        'AnimatedBloubMood animates inside slide transitions and respects visibility',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SlideTransition(
              position: AlwaysStoppedAnimation(Offset(0, 1)),
              child: Center(
                child: AnimatedBloubMood(moodProgress: 2.0, size: 120),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(AnimatedBloubMood), findsOneWidget);

      // Pause cleanly via animate=false and TickerMode(enabled: false)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TickerMode(
              enabled: false,
              child: Center(
                child: AnimatedBloubMood(
                  moodProgress: 5.0,
                  size: 120,
                  animate: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AnimatedBloubMood), findsOneWidget);
    });
  });
}

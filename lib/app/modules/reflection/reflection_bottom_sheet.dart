import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/constants.dart';
import 'package:open_jot/app/modules/reflection/reflection_prompts.dart';

import '../../core/theme.dart';
import '../../core/widgets/custom_button.dart';

class ReflectionBottomSheet extends StatefulWidget {
  const ReflectionBottomSheet({super.key});

  @override
  State<ReflectionBottomSheet> createState() => _ReflectionBottomSheetState();
}

class _ReflectionBottomSheetState extends State<ReflectionBottomSheet> {
  late String _currentPrompt;

  @override
  void initState() {
    super.initState();
    _currentPrompt = reflectionPrompts.first;
  }

  void _shufflePrompt() {
    final random = Random();
    final index = random.nextInt(reflectionPrompts.length);
    setState(() {
      _currentPrompt = reflectionPrompts[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final appThemeColors = AppTheme.colorsOf(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.75,
      child: Material(
        child: Scaffold(
          backgroundColor: appThemeColors.grey6,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(''),
            elevation: 0,
            leading: Padding(
              // Add padding around the container to "shrink" it visually
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: appThemeColors.grey5,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  // The icon button's own padding might need to be removed
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.close),
                  iconSize: 24,
                  color: appThemeColors.grey10,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: appThemeColors.grey7, // Or any other color
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: appThemeColors.grey5,
                              // You can change this color
                              borderRadius: BorderRadius.circular(
                                  24.0), // You can adjust the radius
                            ),
                            child: Text(
                              'REFLECTION',
                              style: TextStyle(
                                  color: appThemeColors.grey10,
                                  fontSize: 14,
                                  fontFamily: AppConstants.font,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            _currentPrompt,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: appThemeColors.grey10,
                                fontSize: 24,
                                fontFamily: AppConstants.font,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: appThemeColors.grey5,
                              // Choose your background color
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.shuffle),
                              // You might want to set an icon color for better contrast
                              color: appThemeColors.grey10,
                              onPressed: _shufflePrompt,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 40.h),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Reflect',
                    onPressed: () {
                      // Handle reflect button press
                    },
                    color: appThemeColors.primary,
                    textColor: appThemeColors.onPrimary,
                    textPadding: EdgeInsets.only(top: 12.h,bottom:12.h ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

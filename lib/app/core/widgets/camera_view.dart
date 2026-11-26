import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/theme.dart';
import 'custom_button.dart';

class CameraView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(XFile photo) onPhotoTaken;

  const CameraView({
    super.key,
    required this.scrollController,
    required this.onPhotoTaken,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
        enableAudio: false, // Explicitly disable audio
      );
      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        // Handle camera initialization error, e.g., show a message to the user
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isTakingPicture) {
      return;
    }
    try {
      final XFile file = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = file;
      });
    } catch (e) {
      // handle error
    }
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
    });
  }

  void _addPicture() {
    if (_capturedImage != null) {
      widget.onPhotoTaken(_capturedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final controller = _cameraController;

    if (controller == null || !_isCameraInitialized || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_capturedImage == null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: ColoredBox(
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: CameraPreview(controller),
                            ),
                            Positioned(
                              bottom: 20.h,
                              child: GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  width: 68.w,
                                  height: 68.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.92),
                                      width: 4.5,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(4.w),
                                  child: const DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: _buildPreview(colors),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildPreview(AppThemeColors colors) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Image.file(
                    File(_capturedImage!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: _retakePicture,
                  text: 'Retake',
                  color: colors.grey3,
                  textColor: colors.grey10,
                  textPadding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  onPressed: _addPicture,
                  text: 'Add',
                  color: Theme.of(context).primaryColor,
                  textColor: colors.grey8,
                  textPadding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}


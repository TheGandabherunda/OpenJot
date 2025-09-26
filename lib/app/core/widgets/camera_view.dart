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
      // This is the definitive fix for the camera preview.
      final cameraPreviewWidget = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: CameraPreview(controller),
        ),
      );

      return Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 440.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: cameraPreviewWidget,
                ),
              ),
              // Add space at the bottom so the capture button doesn't hide the view
              SizedBox(height: 100.h),
            ],
          ),
          Positioned(
            bottom: 16.h,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.9),
                    width: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        children: [
          _buildPreview(colors),
        ],
      );
    }
  }

  Widget _buildPreview(AppThemeColors colors) {
    return Column(
      children: [
        SizedBox(
          height: 440.h, // Fixed height for the preview image
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(_capturedImage!.path),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  onPressed: _addPicture,
                  text: 'Add',
                  color: Theme.of(context).primaryColor,
                  textColor: colors.grey8,
                  textPadding:
                  EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}


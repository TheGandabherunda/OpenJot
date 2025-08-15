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
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
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
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_capturedImage == null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ],
          ),
          // This button is outside the ListView, so it won't scroll.
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
      // After capture, the preview and buttons are in a simple ListView.
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
    // This Column is the content for the post-capture ListView.
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              onPressed: _retakePicture,
              text: 'Retake',
              color: colors.grey3,
              textColor: colors.grey10,
              textPadding:
              EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            CustomButton(
              onPressed: _addPicture,
              text: 'Add',
              color: Theme.of(context).primaryColor,
              textColor: colors.grey8,
              textPadding:
              EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
          ],
        ),
        SizedBox(height: 16.h), // Add some padding at the bottom
      ],
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../theme.dart';

class WriteJournalToolbarContent extends StatefulWidget {
  final IconData? selectedToolbarIcon;
  final ScrollController scrollController;

  const WriteJournalToolbarContent({
    super.key,
    required this.selectedToolbarIcon,
    required this.scrollController,
  });

  @override
  _WriteJournalToolbarContentState createState() =>
      _WriteJournalToolbarContentState();
}

class _WriteJournalToolbarContentState
    extends State<WriteJournalToolbarContent> {
  int _selectedSegment = 0;
  PermissionStatus? _permissionStatus;
  List<AssetEntity> _mediaAssets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final permission = _getPermissionForSegment(_selectedSegment);
    final status = await permission.request();
    setState(() {
      _permissionStatus = status;
    });
    if (status.isGranted) {
      _fetchMedia();
    }
  }

  Future<void> _fetchMedia() async {
    setState(() {
      _isLoading = true;
    });

    final type = _getRequestTypeForSegment(_selectedSegment);
    final albums = await PhotoManager.getAssetPathList(type: type);
    if (albums.isEmpty) {
      setState(() {
        _isLoading = false;
        _mediaAssets = [];
      });
      return;
    }

    final List<AssetEntity> assets = [];
    for (final album in albums) {
      final assetList = await album.getAssetListRange(start: 0, end: 100);
      assets.addAll(assetList);
    }

    setState(() {
      _mediaAssets = assets;
      _isLoading = false;
    });
  }

  Permission _getPermissionForSegment(int segment) {
    switch (segment) {
      case 0:
        return Permission.photos;
      case 1:
        return Permission.videos;
      case 2:
        return Permission.audio;
      default:
        return Permission.photos;
    }
  }

  RequestType _getRequestTypeForSegment(int segment) {
    switch (segment) {
      case 0:
        return RequestType.image;
      case 1:
        return RequestType.video;
      case 2:
        return RequestType.audio;
      default:
        return RequestType.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);

    if (widget.selectedToolbarIcon != Icons.image_rounded) {
      final Map<IconData, String> contentMap = {
        Icons.location_on_rounded: 'Content for Location',
        Icons.camera_alt_rounded: 'Content for Camera',
        Icons.mic_rounded: 'Content for Mic',
        Icons.format_quote_rounded: 'Content for Quote',
        Icons.sentiment_satisfied_rounded: 'Content for Emoji',
      };
      final contentText =
          contentMap[widget.selectedToolbarIcon] ?? 'No content selected.';
      return ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Text(
              contentText,
              style: TextStyle(color: colors.grey10),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          children: const {
            0: Text('Photos'),
            1: Text('Video'),
            2: Text('Music'),
          },
          onValueChanged: (int? value) {
            if (value != null) {
              setState(() {
                _selectedSegment = value;
              });
              _requestPermission();
            }
          },
          groupValue: _selectedSegment,
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: _buildMediaGrid(colors),
        ),
      ],
    );
  }

  Widget _buildMediaGrid(AppThemeColors colors) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionStatus!.isGranted) {
      if (_mediaAssets.isEmpty) {
        return Center(
          child: Text(
            'No ${_getTabName(_selectedSegment).toLowerCase()}s found.',
            style: TextStyle(color: colors.grey10),
          ),
        );
      }
      return GridView.builder(
        controller: widget.scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _mediaAssets.length,
        itemBuilder: (context, index) {
          final asset = _mediaAssets[index];
          if (asset.type == AssetType.audio) {
            return Container(
              color: colors.grey3,
              child: Icon(Icons.music_note, color: colors.grey10),
            );
          }
          return FutureBuilder<Uint8List?>(
            future: asset.thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                );
              }
              return Container(
                color: colors.grey3,
              );
            },
          );
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Permission to access ${_getTabName(_selectedSegment).toLowerCase()} is required to display them.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.grey10),
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Photo';
      case 1:
        return 'Video';
      case 2:
        return 'Music';
      default:
        return '';
    }
  }
}

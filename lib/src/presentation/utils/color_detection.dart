import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ColorDetection {
  final GlobalKey? currentKey;
  final StreamController<Color>? stateController;
  final GlobalKey? paintKey;

  img.Image? photo;

  ColorDetection({
    required this.currentKey,
    required this.stateController,
    required this.paintKey,
  });

  Future<dynamic> searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await loadSnapshotBytes();
    }
    return _calculatePixel(globalPosition);
  }

  _calculatePixel(Offset globalPosition) {
    //2D 데카르트 좌표계의 렌더 객체.
    // 각 상자의 크기는 너비와 높이로 표시됩니다.
    // 각 상자에는 왼쪽 위 모서리가 (0, 0)에 배치되는 고유한 좌표계가 있습니다.
    // 따라서 상자의 오른쪽 하단 모서리는 (너비, 높이)입니다.
    // 상자에는 왼쪽 위 모서리를 포함하여 오른쪽 아래 모서리까지 확장되지만 포함하지 않는 모든 점이 포함됩니다.
    RenderBox box = currentKey!.currentContext!.findRenderObject() as RenderBox;
    //논리적 픽셀 단위의 전역 좌표계에서 주어진 점을 이 상자의 로컬 좌표계로 변환합니다.
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    stateController!.add(Color(hex));
    return Color(hex);
  }

  Future<void> loadSnapshotBytes() async {
    // Capture an image of the current state of this render object and its children.
    // The returned ui.Image has uncompressed raw RGBA bytes in the dimensions of the render object, multiplied by the pixelRatio.
    RenderRepaintBoundary? boxPaint =
        paintKey!.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image capture = await boxPaint!.toImage();
    ByteData? imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes!);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}

// ignore_for_file: must_be_immutable
library stories_editor;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/rendering_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/main_view/main_view.dart';

export 'package:stories_editor/stories_editor.dart';

class StoriesEditor extends StatefulWidget {
  /// editor custom font families
  final List<String>? fontFamilyList;

  /// editor custom font families package
  final bool? isCustomFontList;

  /// giphy api key
  final String giphyKey;

  /// editor custom color gradients
  final List<List<Color>>? gradientColors;

  /// editor custom logo
  final Widget? middleBottomWidget;

  /// on done
  final Function(String)? onDone;

  /// on done button Text
  final Widget? onDoneButtonStyle;

  /// on back pressed
  final Future<bool>? onBackPress;

  /// editor custom color palette list
  final List<Color>? colorList;

  /// editor background color
  final Color? editorBackgroundColor;

  /// gallery thumbnail quality
  final int? galleryThumbnailQuality;

  final String? initText;

  const StoriesEditor(
      {Key? key,
      required this.giphyKey,
      required this.onDone,
      this.middleBottomWidget,
      this.colorList,
      this.gradientColors,
      this.fontFamilyList,
      this.isCustomFontList,
      this.onBackPress,
      this.onDoneButtonStyle,
      this.editorBackgroundColor,
      this.galleryThumbnailQuality,
      this.initText})
      : super(key: key);

  @override
  _StoriesEditorState createState() => _StoriesEditorState();
}

class _StoriesEditorState extends State<StoriesEditor> {
  @override
  void initState() {
    //이미지를 그릴 때 출력을 디더링할지
    //그라데이션이 더 부드럽게 보이도록 셰이더의 디더링도 제어
    Paint.enableDithering = true;
    //runApp 메소드의 시작 지점에서 Flutter 엔진과 위젯의 바인딩이 미리 완료되어 있게 만들어줌
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //변화가 발생할때 제공되는 프로바이더
      providers: [
        ChangeNotifierProvider(create: (_) => ControlNotifier()),
        ChangeNotifierProvider(create: (_) => ScrollNotifier()),
        ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
        ChangeNotifierProvider(create: (_) => GradientNotifier()),
        ChangeNotifierProvider(create: (_) => PaintingNotifier()),
        ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
        ChangeNotifierProvider(create: (_) => RenderingNotifier()),
      ],
      child: MainView(
        giphyKey: widget.giphyKey,
        onDone: widget.onDone,
        fontFamilyList: widget.fontFamilyList,
        isCustomFontList: widget.isCustomFontList,
        middleBottomWidget: widget.middleBottomWidget,
        gradientColors: widget.gradientColors,
        colorList: widget.colorList,
        onDoneButtonStyle: widget.onDoneButtonStyle,
        onBackPress: widget.onBackPress,
        editorBackgroundColor: widget.editorBackgroundColor,
        galleryThumbnailQuality: widget.galleryThumbnailQuality,
        initText: widget.initText,
      ),
    );
  }
}

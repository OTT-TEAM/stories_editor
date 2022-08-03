// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrollablePageView extends StatefulWidget {
  Widget mainView;
  Widget gallery;
  final bool scrollPhysics;
  PageController pageController;
  ScrollController gridController;
  ScrollablePageView(
      {Key? key,
      required this.mainView,
      required this.gallery,
      required this.scrollPhysics,
      required this.pageController,
      required this.gridController})
      : super(key: key);
  @override
  _ScrollablePageViewState createState() => _ScrollablePageViewState();
}

class _ScrollablePageViewState extends State<ScrollablePageView> {
  PageController? _pageController;
  ScrollController? _listScrollController;
  ScrollController? _activeScrollController;
  Drag? _drag;

  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController;
    _listScrollController = widget.gridController;
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _listScrollController!.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollController!.hasClients) {
      final RenderBox renderBox = _listScrollController!
          .position.context.storageContext
          .findRenderObject() as RenderBox;
      if (renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition)) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController!.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController!.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == _listScrollController &&
        details.primaryDelta! > 0 &&
        _activeScrollController!.position.pixels ==
            _activeScrollController!.position.minScrollExtent) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController!.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
    //사용자 정의의 제스쳐를 인식할때 사용.
    //일반적인 제스쳐는 GestureRecognizer를 사용
    //제스쳐 팩토리에 의해 묘사된 제스쳐를 탐지하는 위젯
    return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (VerticalDragGestureRecognizer instance) {
            if (widget.scrollPhysics) {
              instance
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel;
            } else {
              instance
                ..onStart = null
                ..onUpdate = null
                ..onEnd = null
                ..onCancel = null;
            }
          })
        },
        behavior: HitTestBehavior.opaque,
        //여러페이지를 한 화면에서 처리하기 위한 PageView
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          //사용자의 스크롤을 방지하기 위해
          //physics: 어떻게 사용자의 인풋에 대해서 PageView가 응답하는지 나타냄
          physics: const NeverScrollableScrollPhysics(),
          children: [widget.mainView, widget.gallery],
        ));
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class ScrollNotifier extends ChangeNotifier {
  ScrollController _gridController = ScrollController();
  ScrollController get gridController => _gridController;
  set gridController(ScrollController value) {
    _gridController = value;
    notifyListeners();
  }

  //어떤 페이지가 PageView(여러페이지)에서 활성화 되어 있는지 처리
  //스와이프를 감지하고 애니메이션을 제공
  PageController _pageController = PageController();
  PageController get pageController => _pageController;
  set pageController(PageController value) {
    _pageController = value;
    notifyListeners();
  }

  //스크롤이 가능한 위젯을 제어하는 클래스
  //ListView, GridView, CustomScrollView와 주로 함께 사용
  //position.pixels: 축 방향의 반대 방향으로 움직일 수 있는 픽셀 수 이다.
  // position.maxScrollExtent: 픽셀의 최대값이다 (스크롤 할 수 있는 최대 픽셀).
  // position.userScrollDirection: 사용자가 변경하려고 하는 방향이다.
  ScrollController _activeScrollController = ScrollController();
  ScrollController get activeScrollController => _activeScrollController;
  set activeScrollController(ScrollController value) {
    _activeScrollController = value;
    notifyListeners();
  }

  Drag? _drag;
  Drag? get drag => _drag;
  set drag(Drag? value) {
    _drag = value;
    notifyListeners();
  }

  ScrollNotifier? _scrollNotifier;
  ScrollNotifier? get scrollNotifier => _scrollNotifier;
  set scrollNotifier(ScrollNotifier? scrollNotifier) {
    _scrollNotifier = scrollNotifier;
    notifyListeners();
  }
}

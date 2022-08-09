// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedOnTapButton extends StatefulWidget {
  final Widget child;
  final void Function() onTap;
  final Function()? onLongPress;

  const AnimatedOnTapButton(
      {Key? key, required this.onTap, required this.child, this.onLongPress})
      : super(key: key);

  @override
  _AnimatedOnTapButtonState createState() => _AnimatedOnTapButtonState();
}

class _AnimatedOnTapButtonState extends State<AnimatedOnTapButton>
    with TickerProviderStateMixin {
  //확장과 축소
  double squareScaleA = 1;
  AnimationController? _controllerA;
  Timer _timer = Timer(const Duration(milliseconds: 300), () {});

  @override
  void initState() {
    if (mounted) {
      _controllerA = AnimationController(
        vsync: this,
        //애니메이션이 얻을 수 있는 최소값, 애니메이션이 해제된 것으로 간주되는 값
        lowerBound: 0.95,
        upperBound: 1.0,
        //애니메이션의 시작값
        value: 1,
        //애니메이션이 지속되는 시간
        duration: const Duration(milliseconds: 10),
      );
      _controllerA?.addListener(() {
        setState(() {
          squareScaleA = _controllerA!.value;
        });
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _controllerA!.dispose();
      _timer.cancel();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //경계 내에서 이벤트를 수신하고 시각적으로 뒤에 있는 타겟도 이벤트를 수신
      behavior: HitTestBehavior.translucent,
      onTap: () {
        /// set vibration
        HapticFeedback.lightImpact();
        _controllerA!.reverse();
        widget.onTap();
      },
      onTapDown: (dp) {
        _controllerA!.reverse();
      },
      onTapUp: (dp) {
        try {
          if (mounted) {
            _timer = Timer(const Duration(milliseconds: 100), () {
              //스프링처럼 튀는 애니메이션
              //스프링 및 초기 속도로 애니메이션을 구동
              //속도가 양수이면 애니메이션이 완료되고 그렇지 않으면 종료
              _controllerA!.fling();
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      onTapCancel: () {
        _controllerA!.fling();
      },
      onLongPress: widget.onLongPress ?? () {},
      child: Transform.scale(
        scale: squareScaleA,
        child: widget.child,
      ),
    );
  }
}

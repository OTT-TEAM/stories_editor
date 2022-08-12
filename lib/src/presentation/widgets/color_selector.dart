import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Consumer3<ControlNotifier, TextEditingNotifier, PaintingNotifier>(
      builder:
          (context, controlProvider, editorProvider, paintingProvider, child) {
        return Container(
          height: _size.width * 0.1,
          width: _size.width,
          //컨테이너 안에 있는 child를 정렬한다.
          //null이 아닌 경우 컨테이너는 정해진 값에 따라 부모만큼 채운다.
          //그리고 child를 해당 값으로 포지셔닝
          //하위항목이 null일 경우 무시
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: [
              /// current selected color
              Container(
                height: _size.width * 0.1,
                width: _size.width * 0.1,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: controlProvider.isPainting
                        ? controlProvider.colorList![paintingProvider.lineColor]
                        : controlProvider.colorList![editorProvider.textColor],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)),
                child: ImageIcon(
                  const AssetImage('assets/icons/pickColor.png',
                      package: 'stories_editor'),
                  color: controlProvider.isPainting
                      ? (paintingProvider.lineColor == 0
                          ? Colors.black
                          : Colors.white)
                      : (editorProvider.textColor == 0
                          ? Colors.black
                          : Colors.white),
                  size: 20,
                ),
              ),

              /// color list
              Expanded(
                child: ListView.builder(
                  itemCount: controlProvider.colorList!.length,
                  //ListView외에 다른 위젯이 같은 스크린 내에 있을 시에는 shrinkWrap을 true로 하거나
                  //Flexible, Expanded, Sizedbox와 같은 크기를 제어할 수 있는 widget을 사용해서 크기를 제어
                  //shirnkwrap을 true로 하면 ListView 내에서만 스크롤이 됨
                  //Usually a ListView (as well as GridView, PageView and CustomScrollView) tries to fill all the available space given by the parent element, even when the list items would require less space.
                  //With shrinkWrap: true, you can change this behavior so that the ListView only occupies the space it needs (it will still scroll when there more items).
                  //Expanded - it is Flexible with set fit
                  // Expanded - Flexible.tight
                  // FlexFit.tight = 최대한 많은 공간을 확보하면서 부모에게 꼭 맞기를 원합니다.
                  // FlexFit.loose = 스스로 공간을 최대한 줄이면서 부모에게 느슨하게 맞추려고 합니다.
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AnimatedOnTapButton(
                      onTap: () {
                        if (controlProvider.isPainting) {
                          paintingProvider.lineColor = index;
                        } else {
                          editorProvider.textColor = index;
                        }
                      },
                      child: Container(
                        height: _size.width * 0.08,
                        width: _size.width * 0.08,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: controlProvider.colorList![index],
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:share_buy_list/view/components/loading.dart';

class OverlayLoadingMolecules extends StatelessWidget {
  const OverlayLoadingMolecules({Key? key, required this.visible})
      : super(key: key);

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible
        ? const DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Center(child: ColorLoader(radius: 15, dotRadius: 3)))
        : Container();
  }
}

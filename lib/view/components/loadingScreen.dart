import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_buy_list/view/components/loading.dart';

class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules({required this.visible});

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Center(child: ColorLoader(radius: 15.0, dotRadius: 3)))
        : Container();
  }
}

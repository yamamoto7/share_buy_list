import 'package:flutter/material.dart';

class BottomHalfModal extends StatefulWidget {
  const BottomHalfModal({Key? key, required this.child, required this.contents})
      : super(key: key);

  final Widget child;
  final Widget contents;
  @override
  _BottomHalfModalState createState() => _BottomHalfModalState();
}

class _BottomHalfModalState extends State<BottomHalfModal>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return GestureDetector(
        onTap: () {
          showModalBottomSheet<dynamic>(
              backgroundColor: Theme.of(context).backgroundColor,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Focus(
                        focusNode: focusNode,
                        child: GestureDetector(
                            onTap: focusNode.requestFocus,
                            child: Container(
                                height: 480,
                                decoration: const BoxDecoration(
                                  //モーダル自体の色
                                  // color: Colors.white,
                                  //角丸にする
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Column(children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      height: 37,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 24, bottom: 10),
                                          child: Container(
                                              width: 60,
                                              height: 3,
                                              color: const Color(0xFFCAC1C0)))),
                                  const SizedBox(height: 20),
                                  widget.contents
                                ])))));
              });
        },
        child: widget.child);
  }
}

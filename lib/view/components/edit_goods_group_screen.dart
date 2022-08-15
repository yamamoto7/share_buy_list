import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_buy_list/config/config.dart';

class EditGoodsGroupScreen extends StatefulWidget {
  const EditGoodsGroupScreen({Key? key}) : super(key: key);

  @override
  State<EditGoodsGroupScreen> createState() => _EditGoodsGroupState();
}

class _EditGoodsGroupState extends State<EditGoodsGroupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hoge'),
      ),
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Text('hoge'),
          ],
        ),
      ),
    );
  }
}

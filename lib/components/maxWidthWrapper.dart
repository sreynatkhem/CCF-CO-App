import 'package:flutter/material.dart';

import '../utils/storages/const.dart';

class MaxWidthWrapper extends StatelessWidget {
  final Widget? child;
  const MaxWidthWrapper({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      constraints: BoxConstraints(maxWidth: gMaxWidth),
      child: this.child,
    ));
  }
}

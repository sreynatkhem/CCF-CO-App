import 'package:flutter/material.dart';

class CheckResponsive extends StatelessWidget {
  const CheckResponsive(
      {Key? key, this.smallWidget, this.mediumWidget, this.largeWidget})
      : super(key: key);
  final Widget? smallWidget;
  final Widget? mediumWidget;
  final Widget? largeWidget;

  static bool smallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width <= 640;
  static bool mediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width <= 1007;
  static bool largeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width > 1007;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 640) {
          return smallWidget!;
        } else if (constraints.maxWidth <= 1007) {
          return mediumWidget!;
        } else {
          return largeWidget!;
        }
      },
    );
  }
}

import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class FirstChangePassword extends StatelessWidget {
  final controller;
  final focusNode;
  final hintText;
  final onSubmitted;

  FirstChangePassword(
      {this.controller, this.focusNode, this.hintText, this.onSubmitted});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 15),
      child: TextField(
          // enabled: false,
          autofocus: true,
          controller: controller,
          focusNode: focusNode,
          obscureText: true,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: logolightGreen),
              ),
              labelText: 'Change Password',
              hintText: hintText,
              labelStyle:
                  TextStyle(fontSize: 15, color: const Color(0xff0ABAB5)))),
    );
  }
}

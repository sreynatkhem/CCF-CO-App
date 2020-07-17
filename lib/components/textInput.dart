import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final icons;
  final controllers;
  final textInput;
  final keyboardTypes;
  final requireds;

  TextInput(
      {this.controllers,
      this.icons,
      this.textInput,
      this.keyboardTypes,
      this.requireds});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListTile(
        leading: icons,
        title: new TextField(
          style: normalTitleblack,
          keyboardType: keyboardTypes,
          controller: controllers,
          decoration: new InputDecoration(
              hintText: textInput ?? '',
              border: new UnderlineInputBorder(
                  borderSide: new BorderSide(color: requireds ?? Colors.grey)),
              hintStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSizeXs,
                  color: Colors.grey,
                  fontWeight: fontWeight500)),
        ),
      ),
    );
  }
}

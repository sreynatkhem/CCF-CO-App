import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final dynamic controller;
  Comments(this.controller);
  @override
  _CommentsState createState() => _CommentsState(controller);
}

class _CommentsState extends State<Comments> {
  final controller;
  _CommentsState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 8,
        maxLength: 150,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter your comments here ",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: logolightGreen),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: 1, color: logolightGreen),
          ),
        ),
      ),
    );
  }
}

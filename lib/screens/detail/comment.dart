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
        maxLength: 250,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter your comments here ",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.amber,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}

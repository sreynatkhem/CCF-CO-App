import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormGroupFromBuilder extends StatefulWidget {
  var controller;
  FormGroupFromBuilder({this.controller});
  @override
  _FormGroupFromBuilderState createState() =>
      _FormGroupFromBuilderState(controller: this.controller);
}

class _FormGroupFromBuilderState extends State<FormGroupFromBuilder> {
  final _formKey = GlobalKey<FormBuilderState>();
  var controller;
  _FormGroupFromBuilderState({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Container(
          child: TextField(
        autocorrect: false,
        autofocus: false,
        onChanged: null,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: logolightGreen)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: logolightGreen),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: logolightGreen),
          ),
          labelText: 'Group Name:',
        ),
      )),
    ));
  }
}

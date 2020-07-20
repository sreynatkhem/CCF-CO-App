import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class DateTimePickers extends StatelessWidget {
  var onChanged;
  var keys;

  DateTimePickers({this.onChanged, this.keys});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 17)),
          Icon(
            Icons.face,
            color: Colors.grey,
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          FormBuilder(
            key: keys,
            initialValue: {
              'date': DateTime.now(),
              'accept_terms': false,
            },
            child: Column(
              children: <Widget>[
                FormBuilderDateTimePicker(
                  attribute: "date",
                  inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd"),
                  onChanged: onChanged,
                  decoration: InputDecoration(labelText: "Appointment Time"),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

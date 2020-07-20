import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GroupFromBuilder extends StatelessWidget {
  var icons;
  var keys;
  var childs;
  GroupFromBuilder({this.icons, this.childs, this.keys});
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 17)),
          Icon(
            icons,
            color: Colors.grey,
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          FormBuilder(
              key: keys,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: true,
              child: Column(children: <Widget>[
                Container(
                  width: 320,
                  child: childs,
                ),
              ]))
        ],
      ),
    ]);
  }
}

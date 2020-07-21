import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GroupFromBuilder extends StatelessWidget {
  var icons;
  var keys;
  var childs;
  var imageIcon;

  GroupFromBuilder({this.icons, this.childs, this.keys, this.imageIcon});
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 5)),
          if (imageIcon != null) Padding(padding: EdgeInsets.only(left: 5)),
          if (imageIcon != null)
            Container(
              child: Image.network(
                imageIcon,
                width: 18,
                color: Colors.grey,
              ),
            ),
          if (imageIcon == null)
            Icon(
              icons,
              color: Colors.grey,
            ),
          Padding(padding: EdgeInsets.only(left: 5)),
          FormBuilder(
              key: keys,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              // autovalidate: true,
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

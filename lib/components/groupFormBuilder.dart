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
    return Card(
      child: (Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (imageIcon != null)
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Image.network(
                  imageIcon,
                  width: 18,
                  color: Colors.grey,
                ),
              ),
            if (imageIcon == null)
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  icons,
                  color: Colors.grey,
                ),
              ),
            FormBuilder(
                key: keys,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: childs,
                      ),
                    ])),
            Text('')
          ],
        ),
      )),
    );
  }
}

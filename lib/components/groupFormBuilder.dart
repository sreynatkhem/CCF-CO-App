import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class GroupFromBuilder extends StatelessWidget {
  dynamic? icons;
  dynamic? keys;
  dynamic? childs;
  dynamic? imageIcon;
  dynamic? colors;
  dynamic? shapes;
  dynamic? imageColor;
  dynamic? elevations;
  GroupFromBuilder(
      {this.icons,
      this.keys,
      this.childs,
      this.imageIcon,
      this.colors,
      this.shapes,
      this.imageColor,
      this.elevations});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevations,
      shape: shapes ?? null,
      child: (Container(
        color: colors ?? null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (imageIcon != null)
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Image(
                  image: imageIcon,
                  width: 18,
                  color: imageColor ?? Colors.grey,
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

import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class DropDownCustomerRegister extends StatelessWidget {
  var selectedValue;
  String texts;
  bool readOnlys;
  String title;
  bool autofocus;

  var onChanged;
  var items;
  var icons;
  var styleTexts;
  var iconsClose;
  var onPressed;

  DropDownCustomerRegister(
      {this.readOnlys,
      this.texts,
      this.selectedValue,
      this.onChanged,
      this.items,
      this.title,
      this.styleTexts,
      this.iconsClose,
      this.onPressed,
      this.autofocus,
      this.icons});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  icons,
                  color: Colors.grey,
                ),
              ),
              Container(
                child: FlatButton(
                    onPressed: () {
                      readOnlys
                          ? SelectDialog.showModal<String>(context,
                              label: texts ?? 'Search',
                              items: items,
                              onChange: onChanged,
                              autofocus: autofocus)
                          : null;
                    },
                    child: Container(
                        child: Text(
                      texts ?? title,
                      style: selectedValue != null
                          ? styleTexts
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: fontSizeXs,
                              color: Colors.grey,
                              fontWeight: fontWeight500),
                    ))),
              ),
              Container(
                child: IconButton(
                  icon: iconsClose ?? Icon(Icons.close),
                  color: Colors.grey,
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

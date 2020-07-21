import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class DropDownCustomerRegister extends StatelessWidget {
  var selectedValue;
  String texts;
  bool readOnlys;
  String title;
  var onChanged;
  var items;
  var icons;
  var styleTexts;

  DropDownCustomerRegister(
      {this.readOnlys,
      this.texts,
      this.selectedValue,
      this.onChanged,
      this.items,
      this.title,
      this.styleTexts,
      this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icons,
                color: Colors.grey,
              ),
              FlatButton(
                  onPressed: () {
                    SelectDialog.showModal<String>(context,
                        label: texts, items: items, onChange: onChanged);
                  },
                  child: Container(
                      padding: EdgeInsets.only(left: 17.5),
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
            ],
          ),
          Container(
            width: 323,
            margin: EdgeInsets.only(left: 40),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}

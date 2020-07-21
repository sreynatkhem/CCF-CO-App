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
      this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    icons,
                    color: Colors.grey,
                  ),
                  FlatButton(
                      onPressed: () {
                        readOnlys
                            ? SelectDialog.showModal<String>(context,
                                label: texts, items: items, onChange: onChanged)
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
                ],
              ),
              IconButton(
                icon: iconsClose ?? Icon(Icons.close),
                color: Colors.grey,
                onPressed: onPressed,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 5),
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

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class DropDownCustomerRegister extends StatelessWidget {
  var selectedValue;
  String texts;
  bool readOnlys;
  String title;
  bool autofocus;

  Function onInSidePress;
  var onChanged;
  var items;
  var icons;
  var styleTexts;
  var iconsClose;
  var onPressed;
  var validate;
  var validateForm;

  bool clear = true;

  DropDownCustomerRegister(
      {this.readOnlys,
      this.onInSidePress,
      this.texts,
      this.validate,
      this.selectedValue,
      this.onChanged,
      this.items,
      this.validateForm,
      this.title,
      this.styleTexts,
      this.clear,
      this.iconsClose,
      this.onPressed,
      this.autofocus,
      this.icons});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: validate,
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
                    onPressed: onInSidePress ??
                        () {
                          readOnlys
                              ? SelectDialog.showModal<String>(context,
                                  label: AppLocalizations.of(context)
                                          .translate(texts) ??
                                      'Search',
                                  items: items,
                                  onChange: onChanged,
                                  autofocus: autofocus)
                              : null;
                        },
                    child: Container(
                        // padding: EdgeInsets.all(4),
                        child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                              texts ??
                                  AppLocalizations.of(context)
                                      .translate(title) ??
                                  '',
                              style: styleTexts),
                        ),
                        Padding(padding: EdgeInsets.all(1)),
                        texts != null
                            ? Padding(padding: EdgeInsets.all(1))
                            : Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  validateForm,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10),
                                ),
                              ),
                      ],
                    ))),
              ),
              if (clear == true)
                Container(
                  child: IconButton(
                    icon: iconsClose ?? Icon(Icons.close),
                    color: Colors.grey,
                    onPressed: onPressed,
                  ),
                ),
              if (clear == false) Text('')
            ],
          ),
        ],
      ),
    );
  }
}

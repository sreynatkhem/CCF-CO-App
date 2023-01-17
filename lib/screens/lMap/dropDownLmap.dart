import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class DropDownLmapRegister extends StatelessWidget {
  var selectedValue;
  String? texts;
  bool? readOnlys = false;
  String? title;
  bool? autofocus;

  dynamic onInSidePress;
  var onChanged;
  var items;
  var icons;
  var styleTexts;
  var iconsClose;
  var onPressed;
  var validate;
  var validateForm;
  double? elevation = 0.0;

  bool? clear = true;
  dynamic isPhoneXParam;
  DropDownLmapRegister(
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
      this.icons,
      this.elevation,
      this.isPhoneXParam});
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
                width: isPhoneXParam != null
                    ? isPhoneXParam
                    : widthView(context, 0.35),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: onInSidePress ??
                        () {
                          readOnlys!
                              ? SelectDialog.showModal<String>(context,
                                  label: texts ?? 'Search',
                                  items: items,
                                  onChange: onChanged,
                                  autofocus: autofocus ?? false)
                              : null;
                        },
                    child: Container(
                        // padding: EdgeInsets.all(4),
                        child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(texts ?? title ?? '', style: styleTexts),
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

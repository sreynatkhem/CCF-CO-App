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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.only(left: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
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
              child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: Text(texts ?? title ?? '', style: styleTexts),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(1)),
                    texts != null
                        ? Padding(padding: EdgeInsets.all(1))
                        : Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              validateForm,
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ),
                  ],
                ),
              ),
              Row(
                children: [
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
              )
            ],
          ))),
    );
  }
}

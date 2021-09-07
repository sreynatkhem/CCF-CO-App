import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class WidgetCardAddRef extends StatelessWidget {
  var text;
  var onTaps;
  var image;
  var onClearImage;
  var imageText;
  var validateImage;
  var imageDocumented;

  WidgetCardAddRef(
      {this.validateImage,
      this.text,
      this.onTaps,
      this.image,
      this.imageDocumented,
      this.onClearImage,
      this.imageText});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTaps,
      child: Container(
        padding: EdgeInsets.all(isIphoneX(context) ? 30 : 20),
        alignment: Alignment.center,
        // width: 155,
        // height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: validateImage ?? Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: image != null || imageDocumented != null
            ? Stack(children: <Widget>[
                imageDocumented != null
                    ? Container(
                        height: 90, child: Image.memory(imageDocumented))
                    : Container(height: 90, child: Image.file(image)),
                Positioned(
                    // top: 0,
                    // right: 25,
                    child: GestureDetector(
                  onTap: onClearImage,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ))
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 113,
                    height: 50,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Icon(
                    Icons.add_a_photo,
                    color: logolightGreen,
                  )
                ],
              ),
      ),
    );
  }
}

import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultLogin extends StatelessWidget {
  final controllerUser;
  final onChangedUser;
  final hintTextUser;
  final onFieldSubmittedUser;

  final onFieldSubmittedPassword;
  final focusNodePassword;
  final onChangedPassword;
  final hintTextPassword;
  final controllerPassword;

  DefaultLogin({
    this.controllerUser,
    this.hintTextUser,
    this.onChangedUser,
    this.onFieldSubmittedUser,
    this.onFieldSubmittedPassword,
    this.focusNodePassword,
    this.controllerPassword,
    this.onChangedPassword,
    this.hintTextPassword,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
              autofocus: true,
              controller: controllerUser,
              maxLength: 6,
              onChanged: onChangedUser,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: onFieldSubmittedUser,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: logolightGreen),
                  ),
                  labelText: 'User ID',
                  hintText: hintTextUser,
                  labelStyle:
                      TextStyle(fontSize: 15, color: const Color(0xff0ABAB5)))),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(left: 20, right: 15),
          child: TextFormField(
              onFieldSubmitted: onFieldSubmittedPassword,
              controller: controllerPassword,
              focusNode: focusNodePassword,
              obscureText: true,
              onChanged: onChangedPassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: logolightGreen),
                  ),
                  labelText: 'Password',
                  hintText: hintTextPassword,
                  labelStyle:
                      TextStyle(fontSize: 15, color: const Color(0xff0ABAB5)))),
        ),
      ],
    );
  }
}

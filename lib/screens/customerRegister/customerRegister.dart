import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomerRegister extends StatefulWidget {
  @override
  _CustomerRegister createState() => _CustomerRegister();
}

class _CustomerRegister extends State {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'Customers Register',
      bodys: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: "Full Name",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.phone),
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: "Phone",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.work),
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: "Job",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.payment),
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: "Net income",
                ),
              ),
            ),
            Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 17)),
                  Icon(
                    Icons.face,
                    color: Colors.grey,
                  ),
                  Padding(padding: EdgeInsets.only(left: 30)),
                  FormBuilder(
                      key: _fbKey,
                      initialValue: {
                        'date': DateTime.now(),
                        'accept_terms': false,
                      },
                      autovalidate: true,
                      child: Column(children: <Widget>[
                        Container(
                          width: 280,
                          child: FormBuilderDropdown(
                            attribute: "gender",
                            decoration: InputDecoration(labelText: "Gender"),
                            // initialValue: 'Male',
                            hint: Text('Select Gender'),
                            validators: [FormBuilderValidators.required()],
                            items: ['Male', 'Female', 'Other']
                                .map((gender) => DropdownMenuItem(
                                    value: gender, child: Text("$gender")))
                                .toList(),
                          ),
                        ),
                      ]))
                ],
              ),
            ]),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 90,
                padding: EdgeInsets.only(top: 50, left: 10),
                child: new RaisedButton(
                  onPressed: () {},
                  color: logolightGreen,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

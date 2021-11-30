import 'dart:io';

import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUploadImage extends StatefulWidget {
  @override
  _ProfileUploadImageState createState() => _ProfileUploadImageState();
}

class _ProfileUploadImageState extends State<ProfileUploadImage> {
  dynamic profileImage;
  dynamic _profleImage;
  dynamic fileName3;
  String userId = '';
  String userName = '';

  // @override
  // void didChangeDependencies() {
  //   getImageDocument();
  //   uploadImageProfile();
  //   super.didChangeDependencies();
  // }

  Future uploadImageProfile() async {
    try {
      final _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profleImage = File(pickedFile.path); // Exception occurred here
        });
      } else {
        print('PickedFile: is null');
      }
      return null;
    } on PlatformException catch (e) {
      logger().e("PlatformException: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: logolightGreen,
          title: Text(
            "Profile",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                      child: Stack(
                        children: <Widget>[
                          Card(
                            elevation: 10.0,
                            shape: CircleBorder(),
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 70.0,
                                backgroundColor: logolightGreen,
                                child: CircleAvatar(
                                  // child: Align(),
                                  radius: 70.0,
                                  backgroundImage: _profleImage == null
                                      ? AssetImage('assets/images/103.png')
                                      : Image.file(
                                          _profleImage,
                                          fit: BoxFit.fill,
                                          width: 150,
                                          height: 150,
                                        ).image,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                // Icons.add_a_photo,
                                icon: new Icon(Icons.add_a_photo),
                                color: Colors.white,
                                onPressed: () {
                                  uploadImageProfile();
                                },
                              ),
                              decoration: BoxDecoration(
                                color: logoDarkBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Container(),
                Container(
                    child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 10.0,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(2)),
                            ListTile(
                              leading: Icon(
                                Icons.people,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("Hok chealy"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Padding(padding: EdgeInsets.all(2)),
                            ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("0987654"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.people_alt,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("Gender"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Padding(padding: EdgeInsets.all(2)),
                            ListTile(
                              leading: Icon(
                                Icons.account_box,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("ID Type"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.assignment_ind_outlined,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("ID Number"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.date_range,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("Date of birth"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.maps_home_work,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("Select your bank account"),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.card_travel,
                                color: logolightGreen,
                                size: 30,
                              ),
                              title: Text("Account Number"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}

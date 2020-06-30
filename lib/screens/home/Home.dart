import 'package:chokchey_finance/components/Listdrawer.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/specific_rect_clip.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  Home({
    Key key,
  }) : super(key: key);
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;
  final storage = new FlutterSecureStorage();

  String userId = '';
  String userName = '';

  final profile = const AssetImage('assets/images/profile_create.jpg');
  final profile2 = const AssetImage('assets/images/profile2.jpg');

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getStoreUser();
    super.didChangeDependencies();
  }

  getStoreUser() async {
    String user_id = await storage.read(key: 'user_id');

    String user_name = await storage.read(key: 'user_name');
    setState(() {
      userName = user_name ?? '';
      userId = user_id ?? '';
    });
  }

  onLogOut() async {
    await storage.write(key: 'valueid', value: '');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName("/login"));

    // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute<Null>(
    // builder: (BuildContext context) {
    //   return new Detail(value.loanApprovalApplicationNo);
    // },
    // fullscreenDialog: true));
  }

  _drawerList(context) {
    final String id = '0401';
    return Drawer(
      child: Container(
        color: logolightGreen,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: logolightGreen),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:
                            DecorationImage(image: profile, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Text(
                    userName ?? '',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Center(
                    child: Text(
                      " Your ID: ${userId ?? null} ",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    // CustomListTile(
                    //     Icons.view_list, 'List Loan Approve', () => {}),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    CustomListTile(Icons.lock, 'Log Out', () => {onLogOut()}),
                    Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      drawers: new Drawer(
        child: _drawerList(context),
      ),
      headerTexts: 'Loan',
      actionsNotification: <Widget>[
        // Using Stack to show Notification Badge
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.notifications,
                  size: 25,
                ),
                onPressed: () {}),
            0 != 0
                ? new Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : new Container()
          ],
        ),
      ],
      bodys: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: Menu(),
            ),
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
      bottomNavigationBars: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Category'),
              icon: Icon(Icons.apps),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Search'),
              icon: Icon(Icons.search),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
          BottomNavyBarItem(
              title: Text('Setting'),
              icon: Icon(Icons.settings),
              textAlign: TextAlign.center,
              activeColor: logolightGreen),
        ],
      ),
    );
  }
}

const String _svg_99hgzt =
    '<svg viewBox="303.0 149.0 57.0 22.0" ><path transform="translate(303.0, 149.0)" d="M 0 0 L 57 0 L 57 22 L 0 22 L 0 0 Z" fill="#0abab5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_cqepgq =
    '<svg viewBox="34.1 89.7 14.2 14.3" ><path transform="translate(24.14, 79.08)" d="M 24.00840759277344 24.70662117004395 C 23.68801307678223 25.02967643737793 23.18961715698242 25.02967643737793 22.86922264099121 24.70662117004395 L 20.84004783630371 22.66062355041504 C 19.70086669921875 23.55799293518066 18.27688407897949 24.09641456604004 16.71050453186035 24.09641456604004 C 13.00815582275391 24.09641456604004 10 21.06330871582031 10 17.34820556640625 C 10 13.6331033706665 13.00815582275391 10.60000038146973 16.69270706176758 10.60000038146973 C 20.37725639343262 10.60000038146973 23.38541412353516 13.6331033706665 23.38541412353516 17.34820556640625 C 23.38541412353516 18.92757034301758 22.8514232635498 20.36336135864258 21.96143341064453 21.51199340820313 L 23.99060821533203 23.55799293518066 C 24.31100273132324 23.86310005187988 24.31100273132324 24.38356971740723 24.00840759277344 24.70662117004395 Z M 16.71050453186035 12.26910400390625 C 13.93374443054199 12.26910400390625 11.69097518920898 14.5304708480835 11.69097518920898 17.33025741577148 C 11.69097518920898 20.13004493713379 13.93374443054199 22.39141464233398 16.71050453186035 22.39141464233398 C 19.48726844787598 22.39141464233398 21.73003768920898 20.13004493713379 21.73003768920898 17.33025741577148 C 21.73003768920898 14.5304708480835 19.4694709777832 12.26910400390625 16.71050453186035 12.26910400390625 Z" fill="#888383" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_ft13kl =
    '<svg viewBox="25.0 33.0 18.0 14.0" ><path transform="translate(22.0, 28.0)" d="M 3 15 L 21 15 L 21 13 L 3 13 L 3 15 Z M 3 19 L 21 19 L 21 17 L 3 17 L 3 19 Z M 3 11 L 21 11 L 21 9 L 10.79163360595703 9 L 3 9 L 3 11 Z M 3 5 L 3 7 L 21 7 L 21 5 L 3 5 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_7n42va =
    '<svg viewBox="335.0 36.0 16.0 19.5" ><path transform="translate(331.0, 33.5)" d="M 12 22 C 13.10000038146973 22 14 21.10000038146973 14 20 L 10 20 C 10 21.10000038146973 10.89000034332275 22 12 22 Z M 18 16 L 18 11 C 18 7.930000305175781 16.36000061035156 5.360000133514404 13.5 4.679999828338623 L 13.5 4 C 13.5 3.170000076293945 12.82999992370605 2.5 12 2.5 C 11.17000007629395 2.5 10.5 3.170000076293945 10.5 4 L 10.5 4.679999828338623 C 7.630000114440918 5.360000133514404 6 7.920000076293945 6 11 L 6 16 L 4 18 L 4 19 L 20 19 L 20 18 L 18 16 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

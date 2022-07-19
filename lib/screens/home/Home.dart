import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/components/Listdrawer.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/menuCard.dart';
import 'package:chokchey_finance/components/messageFromCEO.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/providers/notification/index.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/screens/approvalHistory/index.dart';
import 'package:chokchey_finance/screens/approvalSummary/index.dart';
import 'package:chokchey_finance/screens/callLog/index.dart';
import 'package:chokchey_finance/screens/customerRegister/customerRegister.dart';
import 'package:chokchey_finance/screens/disApprovalSummary/index.dart';
import 'package:chokchey_finance/screens/groupLoan/index.dart';
import 'package:chokchey_finance/screens/groupLoanApprove/index.dart';
import 'package:chokchey_finance/screens/historyApsara/index.dart';
import 'package:chokchey_finance/screens/loanArrear/index.dart';
import 'package:chokchey_finance/screens/notificationLoanArrear/index.dart';
import 'package:chokchey_finance/screens/profile/index.dart';
import 'package:chokchey_finance/screens/irr/index.dart';
import 'package:chokchey_finance/screens/listCustomerRegistration/index.dart';
import 'package:chokchey_finance/screens/listLoanApproval/indexs.dart';
import 'package:chokchey_finance/screens/listLoanRegistration/index.dart';
import 'package:chokchey_finance/screens/loanRegistration/loanRegistration.dart';
import 'package:chokchey_finance/screens/login/index.dart';
import 'package:chokchey_finance/screens/notification/index.dart';
import 'package:chokchey_finance/screens/policy/index.dart';
import 'package:chokchey_finance/screens/profile/index.dart';
import 'package:chokchey_finance/screens/requestSummary/index.dart';
import 'package:chokchey_finance/screens/returnSummary/index.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chokchey_finance/screens/profile/index.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController? _pageController;
  final storage = new FlutterSecureStorage();

  String userId = '';
  String userName = '';
  dynamic _profleImage;

  var profile;

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  var futureNotification;

  @override
  void didChangeDependencies() {
    getStoreUser();
    // getMessageFromCEO();
    profile = const AssetImage('assets/images/profile_create.jpg');
    super.didChangeDependencies();
  }

  var messageFromCEO;
  // var listMessageFromCEO;
  var _isLoading = false;
  var langCode;

  // Future getMessageFromCEO() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   await Provider.of<NotificationProvider>(context, listen: false)
  //       .fetchMessageFromCEO()
  //       .then((value) => {
  //             setState(() {
  //               _isLoading = false;
  //             }),
  //             langCode = AppLocalizations.of(context)!.locale.languageCode,
  //             if (langCode == 'en')
  //               {
  //                 setState(() {
  //                   listMessageFromCEO = value['en'];
  //                 }),
  //               }
  //             else
  //               {
  //                 setState(() {
  //                   listMessageFromCEO = value['kh'];
  //                 }),
  //               }
  //           })
  //       .catchError((onError) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    FirebaseMessaging.instance.getNotificationSettings();
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
    });
    getNotificationLock();
    fetchVersionApp();
    getNotificationLoanArrear();
  }

  getNotificationLoanArrear() async {
    await Provider.of<NotificationProvider>(context, listen: false)
        .pushNotificationLoanArrear()
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  String version = "";
  fetchVersionApp() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String buildNumber = packageInfo.buildNumber;
    });
  }

  var totalMessage;
  var totalUnread;
  var totalRead;
  var listMessages;
  getNotificationLock() async {
    await Provider.of<NotificationProvider>(context, listen: false)
        .getNotification(20, 1)
        .then((value) => {
              for (var item in value)
                {
                  setState(() {
                    totalMessage = item['totalMessage'];
                    totalUnread = item['totalUnread'];
                    totalRead = item['totalRead'];
                    listMessages = item['listMessages'];
                  })
                },
            })
        .catchError((onError) {});
  }

  List<Object> userRoles = [];

  getStoreUser() async {
    var langCode = AppLocalizations.of(context)!.locale.languageCode;
    String userIds = await storage.read(key: 'user_id');
    String userNames = await storage.read(key: 'user_name');
    setState(() {
      userName = userNames;
      userId = userIds;
    });
  }

  onLogOut() async {
    await storage.deleteAll();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName("/login"));
  }

  onPushNotificationLoanArrear() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PushNotificationLoanLoanArrear()),
    );
  }

  onListLoanApproval() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListLoanApprovals()),
    );
  }

  onListCustomerRegistration() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListCustomerRegistrations()),
    );
  }

  onListGroupLoan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupLoan()),
    );
  }

  onListGroupLoanApprove() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupLoanApprove()),
    );
  }

  onListLoanRegistration() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListLoanRegistrations()),
    );
  }

  onListApprovalHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovalHistory()),
    );
  }

  onListApprovalApsaraHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryApsara()),
    );
  }

  onListApprovalSummary() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApprovalSummary()),
    );
  }

  onListDisApprovalSummary() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisApprovalSummary()),
    );
  }

  onListRequestSummary() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RequestSummary()),
    );
  }

  onListReturnSummary() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReturnSummary()),
    );
  }

  profileImage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileUploadImage()),
    );
  }

  // onClickCallLog() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => CallLogScreen()),
  //   );
  // }

  // phoneCallLog() async {
  //   if (Platform.isAndroid) //Condition for platform Android
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => CallLogScreen()));
  // }

  englishLanguage() {
    Locale _temp;
    _temp = Locale('en', 'US');
    MyHomePage.setLocale(context, _temp);
  }

  khmerLanguage() {
    Locale _temp;
    _temp = Locale('km', 'KH');
    MyHomePage.setLocale(context, _temp);
  }

  _drawerList(context) {
    String versionString =
        baseURLInternal == "http://119.82.252.42:2020/api/" ? "v" : "version";
    return Drawer(
      child: Container(
        color: Colors.white,
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
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileUploadImage()),
                            );
                          },
                          child: CircleAvatar(
                            // child: profileImage!=null?profileImage:p,
                            backgroundImage:
                                AssetImage("assets/images/profile_create.jpg"),
                            backgroundColor: Colors.grey,
                          ),
                        )
                      ],
                    ),

                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   image: DecorationImage(image: profile, fit: BoxFit.fill),
                    // ),
                  )),
                  Text(
                    userName != "" ? userName : "",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Center(
                    child: Text(
                      "${AppLocalizations.of(context)!.translate('your_id')} : ${userId}",
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
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      CustomListTile(
                          Icons.notification_add,
                          "Notification Loan Arrear",
                          () => {onPushNotificationLoanArrear()},
                          null),
                      CustomListTile(
                          Icons.monetization_on,
                          AppLocalizations.of(context)!
                                  .translate('approval_list') ??
                              'Approval List',
                          () => {onListLoanApproval()},
                          null),
                      CustomListTile(
                          Icons.face,
                          AppLocalizations.of(context)!
                                  .translate('customer_list') ??
                              'Customer List',
                          () => {onListCustomerRegistration()},
                          null),
                      CustomListTile(
                          Icons.payment,
                          AppLocalizations.of(context)!
                                  .translate('loan_register_list') ??
                              'Loan Register List',
                          () => {onListLoanRegistration()},
                          null),
                      CustomListTile(
                          Icons.group_add,
                          AppLocalizations.of(context)!
                                  .translate('create_group_loan') ??
                              'Group Loan',
                          () => {onListGroupLoan()},
                          null),
                      CustomListTile(
                          Icons.group,
                          AppLocalizations.of(context)!
                                  .translate('group_loan_approve') ??
                              'Group loan approve',
                          () => {onListGroupLoanApprove()},
                          null),
                      //Call Log
                      // if (Platform.isAndroid)
                      //   CustomListTile(
                      //       Icons.phone_locked,
                      //       AppLocalizations.of(context)!
                      //               .translate('call_log') ??
                      //           "Call log",
                      //       () => {phoneCallLog()},
                      //       null),

                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('report_approval') ??
                              'Report Approval',
                          () => {onListApprovalSummary()},
                          null),
                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('report_disapproval') ??
                              'Report Disapproval',
                          () => {onListDisApprovalSummary()},
                          null),
                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('report_request') ??
                              'Report Request',
                          () => {onListRequestSummary()},
                          null),
                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('report_return') ??
                              'Report Return',
                          () => {onListReturnSummary()},
                          null),
                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('report_summary') ??
                              'Report Summary',
                          () => {onListApprovalHistory()},
                          null),
                      CustomListTile(
                          Icons.insert_chart,
                          AppLocalizations.of(context)!
                                  .translate('loan_approval_history') ??
                              "Loan Approval History",
                          () => {onListApprovalApsaraHistory()},
                          null),
                      //CallLog for Android

                      // Navigate to Profile screen, Need API First.

                      // CustomListTile(
                      //     Icons.person,
                      //     AppLocalizations.of(context)!.translate('profile') ??
                      //         "Profile",
                      //     () => {profileImage()},
                      //     null),

                      // Call Log User
                      // CustomListTile(
                      //     Icons.history,
                      //     // AppLocalizations.of(context)!.translate('profile') ??
                      //     "Call Log",
                      //     () => {onClickCallLog()},
                      //     null),
                      CustomListTile(
                        null,
                        AppLocalizations.of(context)!
                                .translate('english_language') ??
                            'English',
                        () => {englishLanguage()},
                        english,
                      ),
                      CustomListTile(
                        null,
                        'ភាសាខ្មែរ',
                        () => {khmerLanguage()},
                        khmer,
                      ),
                      CustomListTile(
                          Icons.lock,
                          AppLocalizations.of(context)!.translate('log_out') ??
                              'Log Out',
                          () => {onLogOut()},
                          null),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      ListTile(
                        title: Text("$versionString" + '$version'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final register = const AssetImage('assets/images/register.png');
  final loanRegistration =
      const AssetImage('assets/images/loanRegistration.png');
  final list = const AssetImage('assets/images/findApproval.png');
  final policy = const AssetImage('assets/images/policy.png');

  Future<bool> _onBackPressed() async {
    AwesomeDialog(
        context: context,
        // animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.INFO,
        title: AppLocalizations.of(context)!.translate('information') ??
            'Information',
        desc: AppLocalizations.of(context)!.translate('do_you_want_to_exit') ??
            'Do you want to exit?',
        btnOkOnPress: () async {
          Future.delayed(const Duration(milliseconds: 1000), () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
        },
        btnCancelText: AppLocalizations.of(context)!.translate('no') ?? "No",
        btnCancelOnPress: () {},
        btnCancelIcon: Icons.close,
        btnOkIcon: Icons.check_circle,
        btnOkColor: logolightGreen,
        btnOkText: AppLocalizations.of(context)!.translate('yes') ?? 'Yes')
      ..show();
    return false;
  }

  Future<void>? _launched;

  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  final english = const AssetImage('assets/images/english.png');
  final khmer = const AssetImage('assets/images/khmer.png');

  @override
  Widget build(BuildContext context) {
    var langCode = AppLocalizations.of(context)!.locale.languageCode;

    var test = storage.read(key: 'roles');
    test.then(
      (value) => setState(() {
        userRoles = jsonDecode(value);
        // userRoles.add('99');
        userRoles.insert(0, "99");
      }),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Header(
        drawers: new Drawer(
          child: _drawerList(context),
        ),
        headerTexts: AppLocalizations.of(context)!.translate('loans'),
        actionsNotification: <Widget>[
          IconButton(
              icon: Icon(
                Icons.help,
                size: 25,
              ),
              onPressed: () {
                // setState(() {
                //   _launched = _launchInBrowser(guildeLine);
                // });
              }),
          // Using Stack to show Notification Badge
          new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  }),
              totalUnread != 0
                  ? new Positioned(
                      right: 11,
                      top: 14,
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
                          totalUnread.toString(),
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
        bodys: _isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.expand(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.only(
                                    left: 45.0, right: 45.0, top: 20),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                children:
                                    List.generate(userRoles.length, (index) {
                                  if (userRoles[index].toString() == '100001') {
                                    return MenuCard(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApprovalLists()),
                                      ),
                                      color: logolightGreen,
                                      imageNetwork: list,
                                      text: AppLocalizations.of(context)!
                                          .translate('list_loan_approval'),
                                    );
                                  }
                                  // if (userRoles[index].toString() == '100001') {
                                  //   return Padding(
                                  //     padding: EdgeInsets.all(10),
                                  //   );
                                  // }

                                  if (userRoles[index].toString() == '100002') {
                                    if (langCode == 'en') {
                                      return MenuCard(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerRegister()),
                                        ),
                                        color: logolightGreen,
                                        imageNetwork: register,
                                        text: AppLocalizations.of(context)!
                                                .translate('customers') ??
                                            'Customer',
                                        // AppLocalizations.of(context)!.locale.languageCode == 'en'
                                        text2: AppLocalizations.of(context)!
                                                .translate('registration') ??
                                            'Registration',
                                      );
                                    } else {
                                      return MenuCard(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerRegister()),
                                        ),
                                        color: logolightGreen,
                                        imageNetwork: register,
                                        text: AppLocalizations.of(context)!
                                                .translate(
                                                    'customer_registration') ??
                                            'Customer',
                                      );
                                    }
                                  }
                                  // if (userRoles[index].toString() == '100002') {
                                  //   return Padding(
                                  //     padding: EdgeInsets.all(10),
                                  //   );
                                  // }
                                  if (userRoles[index].toString() == '100003') {
                                    return MenuCard(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoanRegister()),
                                      ),
                                      color: logolightGreen,
                                      imageNetwork: loanRegistration,
                                      text: AppLocalizations.of(context)!
                                              .translate('loan_registration') ??
                                          'Loan Registration',
                                    );
                                  }
                                  // if (userRoles[index].toString() == '100003') {
                                  //   return Padding(
                                  //     padding: EdgeInsets.all(10),
                                  //   );
                                  // }
                                  if (userRoles[index].toString() == '100004') {
                                    return Container(
                                      width: 10,
                                      height: 20,
                                      child: MenuCard(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PolicyScreen()),
                                        ),
                                        color: logolightGreen,
                                        imageNetwork: policy,
                                        text: AppLocalizations.of(context)!
                                                .translate('policy') ??
                                            'Policy',
                                      ),
                                    );
                                  }

                                  // if (userRoles[index].toString() == '100004') {
                                  //   return Padding(
                                  //     padding: EdgeInsets.all(10),
                                  //   );
                                  // }

                                  // if (userRoles[index].toString() == '100005') {
                                  //   return Text('');
                                  // }
                                  // if (userRoles[index].toString() == '100006') {
                                  //   return Text('${userRoles[index]}');
                                  // }

                                  if (userRoles[index].toString() == '99') {
                                    return Container(
                                      width: 10,
                                      height: 20,
                                      child: MenuCard(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoanArrearScreen()),
                                        ),
                                        color: logolightGreen,
                                        icons: Icon(
                                          Icons.paid,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        text: 'Loan Arrear',
                                      ),
                                    );
                                  }

                                  return Text("");
                                }) // List View
                                ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(
                          //       left: 45.0, right: 45.0, top: 0, bottom: 50),
                          //   child: MenuCard(
                          //     onTap: () => Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => CustomerRegister()),
                          //     ),
                          //     color: logolightGreen,
                          //     imageNetwork: register,
                          //     text: AppLocalizations.of(context)!
                          //             .translate('customer_registration') ??
                          //         'Customer',
                          //   ),
                          // ),
                          // listMessageFromCEO != null && listMessageFromCEO != ""
                          //     ? CardMessage(
                          //         title: AppLocalizations.of(context)!
                          //                 .translate('message_from_ceo') ??
                          //             'Message from CEO',
                          //         textMessage: listMessageFromCEO != null &&
                          //                 listMessageFromCEO != ""
                          //             ? listMessageFromCEO
                          //             : "")
                          //     : Text("")
                        ],
                      ),
                    ),
                    IRRScreen(),
                    // HistoryApsara(),
                    // Container(
                    //   color: Colors.white,
                    // ),
                  ],
                ),
              ),
        bottomNavigationBars: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController!.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text(
                    AppLocalizations.of(context)!.translate('home') ?? 'Home'),
                icon: Icon(Icons.home),
                textAlign: TextAlign.center,
                activeColor: logolightGreen),
            BottomNavyBarItem(
                title: Text(
                    AppLocalizations.of(context)!.translate('irr') ?? 'IRR'),
                icon: Icon(Icons.calculate),
                textAlign: TextAlign.center,
                activeColor: logolightGreen),
            // BottomNavyBarItem(
            //     title: Text(AppLocalizations.of(context)!.translate('search') ??
            //         'Search'),
            //     icon: Icon(Icons.search),
            //     textAlign: TextAlign.center,
            //     activeColor: logolightGreen),
            // BottomNavyBarItem(
            //     title: Text(AppLocalizations.of(context)!.translate('setting') ??
            //         'Setting'),
            //     icon: Icon(Icons.settings),
            //     textAlign: TextAlign.center,
            //     activeColor: logolightGreen),
          ],
        ),
      ),
    );
  }
}

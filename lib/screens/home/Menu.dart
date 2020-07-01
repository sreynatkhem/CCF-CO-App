import 'package:chokchey_finance/components/approved.dart';
import 'package:chokchey_finance/components/cardListApproval.dart';
import 'package:chokchey_finance/components/menuCard.dart';
import 'package:chokchey_finance/components/messageFromCEO.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
import 'package:chokchey_finance/screens/detail/index.dart';
import 'package:chokchey_finance/screens/customerRegister/customerRegister.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final paddingCard = const EdgeInsets.all(8);
  final aprroval = const AssetImage('assets/images/list_approval.png');
  final aprroved = const AssetImage('assets/images/approved.png');
  final rejected = const AssetImage('assets/images/rejected.png');
  final returns = const AssetImage('assets/images/return.png');
  final register = const AssetImage('assets/images/register.png');
  final loanRegistration =
      const AssetImage('assets/images/loanRegistration.png');
  final list = const AssetImage('assets/images/findApproval.png');

  double widths = 45.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                MenuCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApprovalLists()),
                  ),
                  color: logolightGreen,
                  imageNetwork: list,
                  text: 'List Loan Approve',
                ),
                MenuCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerRegister()),
                  ),
                  color: logolightGreen,
                  imageNetwork: register,
                  text: 'Customer',
                  text2: 'Registeration',
                ),
                MenuCard(
                  onTap: () => null,
                  color: logolightGreen,
                  imageNetwork: loanRegistration,
                  text: 'Loan Registration',
                ),
              ],
            ),
          ),
          CardMessage(
            title: 'Message from CEO',
            textMessage:
                'Our reputation for corporate integrity attracts great team members, great customers, and even greater opportunities. It is a key to our long-term success. I am continually impressed by the resourcefulness and entrepreneurial quality displayed by our people and the exceptional value they bring to the company',
          )
        ],
      ),
    );
  }
}

import 'package:chokchey_finance/components/approved.dart';
import 'package:chokchey_finance/components/menuCard.dart';
import 'package:chokchey_finance/screens/approval/approvalList.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          MenuCard(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApprovalLists()),
            ),
            color: lightGreen,
            imageNetwork: aprroval,
            text: 'Approval Lists',
          ),
          MenuCard(
            onTap: () => null,
            //  Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Approved()),
            // ),
            color: lightBlue,
            imageNetwork: aprroved,
            text: 'Approved',
          ),
          MenuCard(
            onTap: () => null,
            color: lightBlue,
            imageNetwork: rejected,
            text: 'Rejected',
          ),
          MenuCard(
            onTap: () => null,
            color: primaryBlue,
            imageNetwork: rejected,
            text: 'Rejected',
          ),
          MenuCard(
            onTap: () => null,
            color: lightPink,
            imageNetwork: aprroved,
            text: 'Approval',
          ),
          MenuCard(
            onTap: () => null,
            color: lightPurple,
            imageNetwork: aprroved,
            text: 'Approval',
          ),
        ],
      ),
    );
  }
}

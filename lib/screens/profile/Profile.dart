import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatelessWidget {
  final ImageProvider profile;
  Profile({
    Key key,
    this.profile = const AssetImage('assets/images/profile.jpg'),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(321.0, 84.0),
            child: Text(
              '1',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: 375.0,
                        height: 77.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff0abab5),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(160.0, 26.15),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(12.0, 25.77),
                        child: PageLink(
                          links: [
                            PageLinkInfo(
                              transition: LinkTransition.Fade,
                              ease: Curves.easeOut,
                              duration: 0.3,
                              pageBuilder: () => Home(),
                            ),
                          ],
                          child: Container(
                            width: 47.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff0abab5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(29.0, 32.89),
                    child:
                        // Adobe XD layer: 'ic_keyboard_arrow_l…' (shape)
                        SvgPicture.string(
                      _svg_mqhdxl,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(22.0, 96.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Login(
                    chokchey: const AssetImage('assets/images/chokchey.png'),
                  ),
                ),
              ],
              child:
                  // Adobe XD layer: 'Profile' (shape)
                  Container(
                width: 91.0,
                height: 92.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(45.5, 46.0)),
                  image: DecorationImage(
                    image: profile,
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(141.0, 108.0),
            child: Text(
              'Ramon Oem',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(141.0, 133.0),
            child: Text(
              'Your ID: 001',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 13,
                color: const Color(0xff000000),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(61.0, 220.0),
            child:
                // Adobe XD layer: 'ic_pin_drop_24px' (shape)
                SvgPicture.string(
              _svg_fcnx4r,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(113.0, 220.0),
            child: Text(
              'CCF Location',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, -47.0),
            child: PageLink(
              links: [
                PageLinkInfo(
                  transition: LinkTransition.Fade,
                  ease: Curves.easeOut,
                  duration: 0.3,
                  pageBuilder: () => Login(
                    chokchey: const AssetImage('assets/images/chokchey.png'),
                  ),
                ),
              ],
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(113.0, 306.0),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13,
                        color: const Color(0xff000000),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(59.0, 307.0),
                    child:
                        // Adobe XD layer: 'ic_input_24px' (shape)
                        SvgPicture.string(
                      _svg_9yq0s0,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_mqhdxl =
    '<svg viewBox="29.0 32.9 9.8 16.1" ><path transform="translate(21.0, 27.39)" d="M 17.83779907226563 19.73672294616699 L 11.75721549987793 13.56613159179688 L 17.83779907226563 7.395540237426758 L 15.96582794189453 5.499999046325684 L 7.999999046325684 13.56613159179688 L 15.96582794189453 21.63226318359375 L 17.83779907226563 19.73672294616699 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_fcnx4r =
    '<svg viewBox="61.0 220.0 14.0 20.0" ><path transform="translate(56.0, 218.0)" d="M 18 8 C 18 4.690000057220459 15.30999946594238 2 12 2 C 8.690000534057617 2 6 4.690000057220459 6 8 C 6 12.5 12 19 12 19 C 12 19 18 12.5 18 8 Z M 10 8 C 10 6.900000095367432 10.89999961853027 6 12 6 C 13.10000038146973 6 14 6.900000095367432 14 8 C 14 9.100000381469727 13.10999965667725 10 12 10 C 10.89999961853027 10 10 9.100000381469727 10 8 Z M 5 20 L 5 22 L 19 22 L 19 20 L 5 20 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_9yq0s0 =
    '<svg viewBox="59.0 307.0 22.0 18.0" ><path transform="translate(58.0, 303.99)" d="M 21 3.009999990463257 L 3 3.009999990463257 C 1.899999976158142 3.009999990463257 1 3.909999847412109 1 5.010000228881836 L 1 9 L 3 9 L 3 4.989999771118164 L 21 4.989999771118164 L 21 19.02000045776367 L 3 19.02000045776367 L 3 15 L 1 15 L 1 19.01000022888184 C 1 20.11000061035156 1.899999976158142 20.98999977111816 3 20.98999977111816 L 21 20.98999977111816 C 22.10000038146973 20.98999977111816 23 20.11000061035156 23 19.01000022888184 L 23 5.010000228881836 C 23 3.900000095367432 22.10000038146973 3.010000228881836 21 3.010000228881836 Z M 11 16 L 15 12 L 11 8 L 11 11 L 1 11 L 1 13 L 11 13 L 11 16 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

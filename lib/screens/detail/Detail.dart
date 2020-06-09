import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adobe_xd/specific_rect_clip.dart';

class Detail extends StatelessWidget {
  Detail({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(321.0, 105.0),
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
          Transform.translate(
            offset: Offset(226.0, 98.0),
            child: Container(
              width: 124.0,
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xff0abab5),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(43.0, 98.0),
            child: Container(
              width: 124.0,
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xffc34d7c),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(79.0, 100.0),
            child: Text(
              'Reject',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(251.0, 97.5),
            child: Text(
              'Approve',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xffffffff),
                height: 1.35,
              ),
              textAlign: TextAlign.left,
            ),
          ),
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
                offset: Offset(160.0, 25.81),
                child: Text(
                  'Detail',
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
                offset: Offset(12.0, 25.18),
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
              Transform.translate(
                offset: Offset(29.0, 32.55),
                child:
                    // Adobe XD layer: 'ic_keyboard_arrow_l…' (shape)
                    SvgPicture.string(
                  _svg_wy2231,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(24.0, 171.0),
            child: Text(
              'Loan New Approval Information',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xff313030),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(23.5, 213.0),
            child: SpecificRectClip(
              rect: Rect.fromLTWH(0, 0, 327.5, 512),
              child: UnconstrainedBox(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 328,
                  height: 620,
                  child: GridView.count(
                    primary: false,
                    padding: EdgeInsets.all(0),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 1,
                    childAspectRatio: 2.3429,
                    children: [
                      {},
                      {},
                      {},
                      {},
                    ].map((map) {
                      return Transform.translate(
                        offset: Offset(-23.5, -218.0),
                        child: Stack(
                          children: <Widget>[
                            Transform.translate(
                              offset: Offset(23.5, 275.5),
                              child: SvgPicture.string(
                                _svg_theuwc,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(24.0, 218.0),
                              child:
                                  // Adobe XD layer: '1617972-200' (shape)
                                  Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(23.0, 23.0)),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                        'assets/images/requested.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xff707070)),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(23.5, 357.5),
                              child: SvgPicture.string(
                                _svg_26s21g,
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(24.0, 300.0),
                              child:
                                  // Adobe XD layer: '1617972-200' (shape)
                                  Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(23.0, 23.0)),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                        'assets/images/approval.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xff707070)),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 218.0),
                              child: Text(
                                'Skyeang Sren',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 15,
                                  color: const Color(0xff313030),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 296.0),
                              child: Text(
                                'Skyeang Sren',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 15,
                                  color: const Color(0xff313030),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 240.0),
                              child: Text(
                                '102240 / 0120',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 11,
                                  color: const Color(0xff888383),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 318.0),
                              child: Text(
                                '102240 / 0120',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 11,
                                  color: const Color(0xff888383),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 255.0),
                              child: Text(
                                '18-05-2020',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 11,
                                  color: const Color(0xff888383),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(91.0, 333.0),
                              child: Text(
                                '18-05-2020',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 11,
                                  color: const Color(0xff888383),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(286.0, 300.0),
                              child: Text(
                                '19-05-2020',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 12,
                                  color: const Color(0xff313030),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(-6.0, 1.0),
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(304.0, 599.0),
                  child: Container(
                    width: 59.0,
                    height: 58.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(29.5, 29.0)),
                      color: const Color(0xff0abab5),
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
                Transform.translate(
                  offset: Offset(327.0, 621.0),
                  child:
                      // Adobe XD layer: 'ic_add_24px' (shape)
                      SvgPicture.string(
                    _svg_ixa5t5,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_wy2231 =
    '<svg viewBox="29.0 32.6 9.8 16.1" ><path transform="translate(21.0, 27.05)" d="M 17.83779907226563 19.73672294616699 L 11.75721549987793 13.56613159179688 L 17.83779907226563 7.395540237426758 L 15.96582794189453 5.499999046325684 L 7.999999046325684 13.56613159179688 L 15.96582794189453 21.63226318359375 L 17.83779907226563 19.73672294616699 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_theuwc =
    '<svg viewBox="23.5 275.5 327.0 1.0" ><path transform="translate(23.5, 275.5)" d="M 0 0 L 327 0" fill="none" fill-opacity="0.2" stroke="#888383" stroke-width="1" stroke-opacity="0.2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_26s21g =
    '<svg viewBox="23.5 357.5 327.0 1.0" ><path transform="translate(23.5, 357.5)" d="M 0 0 L 327 0" fill="none" fill-opacity="0.2" stroke="#888383" stroke-width="1" stroke-opacity="0.2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ixa5t5 =
    '<svg viewBox="327.0 621.0 14.0 14.0" ><path transform="translate(322.0, 616.0)" d="M 19 13 L 13 13 L 13 19 L 11 19 L 11 13 L 5 13 L 5 11 L 11 11 L 11 5 L 13 5 L 13 11 L 19 11 L 19 13 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

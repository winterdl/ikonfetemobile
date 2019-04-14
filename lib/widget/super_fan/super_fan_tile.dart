import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/team_feed/partials/feed_avatar.dart';
import 'package:ikonfete/widget/themes/theme.dart';

class SuperFanTile extends StatelessWidget {
  const SuperFanTile({
    Key key,
    @required this.feteScore,
    @required this.rank,
    this.onTap,
  }) : super(key: key);

  final int feteScore;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.8,
      onPressed: onTap,
      child: Container(
        height: sf(60),
        margin: EdgeInsets.only(bottom: sh(40)),
        // decoration: BoxDecoration(
        //   border: Border(
        //       bottom: BorderSide(
        //     color: IkColors.lighterGrey,
        //     width: 1,
        //   )),
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                //TODO refactor icon
                padding: EdgeInsets.only(bottom: sh(8)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: IkColors.lightGrey, width: sh(4)))),
                child: Text(
                  rank.toString(),
                  style: IkTheme.of(context).subhead1.copyWith(
                      color: IkColors.lightGrey,
                      fontSize: sf(19),
                      fontWeight: FontWeight.w200),
                )),
            SizedBox(width: sw(16)),
            ActivityAvatar(
              // image: AssetImage('assetName'),
              radius: sw(29),
              icon: Icons.star, image: null,
            ),
            SizedBox(width: sw(16)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text.rich(
                  TextSpan(text: '@NiceForWhat\n', children: [
                    TextSpan(
                        text: feteScore?.toString() ?? '99',
                        style: TextStyle(
                          fontSize: sf(14),
                          color: IkColors.lightGrey,
                        )),
                  ]),
                  style: IkTheme.of(context).subhead3,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

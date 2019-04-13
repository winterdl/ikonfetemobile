import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/model/user.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/team_feed/partials/feed_avatar.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/themes/theme.dart';
import 'package:timeago/timeago.dart' as ago;

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    Key key,
    this.action,
    this.actor,
    this.object,
    this.time,
  }) : super(key: key);

  final String action;
  final User actor;
  final Widget object;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            ActivityAvatar(
              icon: Icons.favorite,
              iconBorderWidth: 2,
              radius: sw(19),
              image: null,
            ),
            SizedBox(width: sw(20)),
            Container(
              child: Text.rich(
                TextSpan(
                  text: 'Landon ',
                  style: IkTheme.of(context).smallBold.copyWith(
                        color: IkColors.primary,
                      ),
                  children: [
                    TextSpan(
                      text: 'liked your post\n',
                      style: TextStyle(color: IkColors.lightGrey),
                    ),
                    TextSpan(
                      text: ago
                          .format(DateTime(2019, 4, 1), locale: 'en_short')
                          .toUpperCase(),
                      style: TextStyle(
                          color: IkColors.lightGrey, fontSize: sf(10)),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: sw(40),
              width: sw(40),
              child: SizedBox(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(sw(6))),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/onboard_background1.png'),
                ),
              ),
            )
          ]),
          SizedBox(
            height: sh(10),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: sw(60)),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: sh(10)),
        ],
      ),
    );
  }
}

class ActivityTileFollow extends StatelessWidget {
  const ActivityTileFollow({
    Key key,
    this.action,
    this.actor,
    this.object,
    this.time,
  }) : super(key: key);

  final String action;
  final User actor;
  final Widget object;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            ActivityAvatar(
              icon: Icons.check,
              iconBorderWidth: 2,
              radius: sw(19),
              iconBgColor: IkColors.success,
              image: null,
            ),
            SizedBox(width: sw(20)),
            Container(
              child: Text.rich(
                TextSpan(
                  text: 'Landon ',
                  style: IkTheme.of(context).smallBold.copyWith(
                        color: IkColors.primary,
                      ),
                  children: [
                    TextSpan(
                      text: 'Followed you\n',
                      style: TextStyle(color: IkColors.lightGrey),
                    ),
                    TextSpan(
                      text: ago
                          .format(DateTime(2019, 4, 1), locale: 'en_short')
                          .toUpperCase(),
                      style: TextStyle(
                          color: IkColors.lightGrey, fontSize: sf(10)),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: sw(80),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                color: IkColors.primary,
                minSize: sh(40),
                child: Text(
                  'View',
                  style: IkTheme.of(context).smallBold.copyWith(
                        color: IkColors.white,
                      ),
                ),
              ),
            )
          ]),
          SizedBox(
            height: sh(10),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: sw(50)),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: sh(10)),
        ],
      ),
    );
  }
}

class ActivityTileWarn extends StatelessWidget {
  const ActivityTileWarn({
    Key key,
    this.message,
    this.actor,
    this.object,
    this.time,
  }) : super(key: key);

  final String message;
  final User actor;
  final Widget object;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Icon(
                    Icons.warning,
                    color: IkColors.white,
                    size: sf(16),
                  ),
                  height: sw(38),
                  width: sw(38),
                  decoration: BoxDecoration(
                      color: IkColors.warning,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          sw(30),
                        ),
                      )),
                ),
                SizedBox(width: sw(20)),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Text(
                            'November 2 at 08:10 made an offensive comment… ',
                            style: IkTheme.of(context).smallMedium.copyWith(
                                  color: IkColors.lightGrey,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: sh(10)),
                      SizedBox(
                        width: sw(80),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          color: IkColors.lighterColdGrey,
                          minSize: sh(40),
                          child: Text(
                            'More',
                            style: IkTheme.of(context).smallBold.copyWith(
                                  color: IkColors.lightGrey,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: sw(90),
                )
              ]),
          SizedBox(height: sh(10)),
          Row(
            children: <Widget>[
              SizedBox(width: sw(50)),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: sh(10)),
        ],
      ),
    );
  }
}

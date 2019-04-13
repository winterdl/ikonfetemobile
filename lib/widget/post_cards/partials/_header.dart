import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sf(60),
      padding: EdgeInsets.all(sf(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: sw(14),
            backgroundImage:
                AssetImage('assets/images/onboard_background1.png'),
          ),
          SizedBox(width: sw(15)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Jane Foster',
                style: TextStyle(
                  fontSize: sf(12),
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text.rich(
                TextSpan(text: '10 mins ago via ', children: [
                  TextSpan(
                      text: 'Twitter',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                style: TextStyle(
                    fontSize: sf(10),
                    color: IkColors.lightGrey,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
          const Spacer(),
          CupertinoButton(
            minSize: sh(20),
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.more_vert,
              color: IkColors.lighterGrey,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

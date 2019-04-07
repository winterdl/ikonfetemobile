import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

class BuildFooter extends StatelessWidget {
  const BuildFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _BuildLikes(),
        _BuildComments(),
      ],
    );
  }
}

class _BuildComments extends StatelessWidget {
  const _BuildComments({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.comment, color: IkColors.lightGrey),
        SizedBox(width: 10.0),
        Text(
          "2",
          style: TextStyle(
            fontSize: sf(12),
            fontFamily: "SanFranciscoDisplay",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BuildLikes extends StatelessWidget {
  const _BuildLikes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CupertinoButton(
          minSize: sf(18),
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: Icon(
            Icons.favorite,
            color: primaryColor,
            size: sf(18),
          ),
        ),
        Text(
          '18K',
          style: TextStyle(
            fontSize: sf(11),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: sw(10),
        ),
        Stack(
          children: <Widget>[
            Container(
              transform: Matrix4.identity()..translate(0.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.0),
              ),
              child: CircleAvatar(
                  radius: sf(10),
                  backgroundImage:
                      AssetImage("assets/images/onboard_background1.png")),
            ),
            Container(
              transform: Matrix4.identity()..translate(14.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.0),
              ),
              child: CircleAvatar(
                  radius: sf(10),
                  backgroundImage:
                      AssetImage("assets/images/onboard_background1.png")),
            ),
            Container(
              transform: Matrix4.identity()..translate(28.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.0),
              ),
              child: CircleAvatar(
                  radius: sf(10),
                  backgroundImage:
                      AssetImage("assets/images/onboard_background1.png")),
            ),
          ],
        ),
      ],
    );
  }
}

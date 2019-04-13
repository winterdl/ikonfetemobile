import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

class ActivityAvatar extends StatelessWidget {
  const ActivityAvatar({
    Key key,
    @required this.image,
    @required this.icon,
    @required this.radius,
    this.iconBorderWidth = 3,
    this.iconBgColor = IkColors.primary,
  })  : assert(radius != null),
        super(key: key);

  final ImageProvider image;
  final IconData icon;
  final double radius;
  final Color iconBgColor;
  final double iconBorderWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundImage:
              image ?? AssetImage('assets/images/onboard_background1.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: radius + 2,
            width: radius + 2,
            decoration: BoxDecoration(
                color: IkColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: Colors.white,
                  width: iconBorderWidth,
                )),
            child: Icon(
              icon,
              size: sf((radius.toInt() / 2).round() + 2),
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

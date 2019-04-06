import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

class EventSlide extends StatelessWidget {
  const EventSlide({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: sw(16)),
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: sh(100),
                margin: EdgeInsets.symmetric(horizontal: sw(26)),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: sf(20), color: Color(0xFF3e131c))
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/onboard_background3.png',
                      )),
                  borderRadius: BorderRadius.all(Radius.circular(sw(8))),
                ),
                height: sh(180),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: sh(16)),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: sw(16)),
                        _Tags(title: 'CONCERT'),
                        SizedBox(width: sw(16)),
                        _Tags(title: 'ROCK'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sh(24)),
          Text(
            'Imagine Dragons',
            style: TextStyle(fontSize: sf(20), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sh(8)),
          Text(
            'Moscow, big sports arena | Luzhniki\nAugust 29, 19:00',
            style: TextStyle(
              height: 1.3,
              fontSize: sf(15),
              color: IkColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({
    Key key,
    @required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sw(6), vertical: sw(6)),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: sf(12),
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          borderRadius: BorderRadius.all(Radius.circular(sw(4))),
        ),
      ),
    );
  }
}

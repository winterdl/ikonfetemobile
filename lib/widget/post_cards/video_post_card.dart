import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

class VideoPostCard extends StatefulWidget {
  @override
  _VideoPostCardState createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: sh(40)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(sw(10)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 5.0,
              blurRadius: sh(20),
              offset: Offset(0.0, sh(10)),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BuildHeader(),
          _BuildVideoPLayer(),
          Container(
            padding: EdgeInsets.all(sw(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Artist Name - Song Name",
                  style: TextStyle(
                    fontSize: sf(14),
                    fontFamily: "SanFranciscoDisplay",
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '129 209 2999 views'.toUpperCase(),
                  style: TextStyle(
                    fontSize: sf(12),
                    color: IkColors.lightGrey,
                  ),
                ),
                SizedBox(
                  height: sh(40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildLikes(),
                    _buildComments(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikes() {
    return Row(
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
            color: primaryColor,
            size: sf(18),
          ),
        ),
        Text(
          '18K',
          style: TextStyle(
            fontSize: sf(11),
            fontFamily: "SanFranciscoDisplay",
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

  Widget _buildComments() {
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

class _BuildVideoPLayer extends StatelessWidget {
  const _BuildVideoPLayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(children: <Widget>[
        Container(
          width: double.infinity,
          // to be replaced with video
          child: Image.asset(
            "assets/images/onboard_background1.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Container(
            decoration:
                BoxDecoration(color: primaryColor, shape: BoxShape.circle),
            child: CupertinoButton(
              onPressed: () {},
              child: Icon(
                Icons.play_arrow,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sh(60),
      padding: EdgeInsets.symmetric(horizontal: sw(20), vertical: sh(15)),
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

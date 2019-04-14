import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/post_cards/partials/_footer.dart';
import 'package:ikonfete/widget/post_cards/partials/_header.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoPostCard extends StatefulWidget {
  //TODO make it more accessible

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
          BuildHeader(),
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
                  '129 209 2999 views',
                  style: TextStyle(
                    fontSize: sf(12),
                    color: IkColors.lightGrey,
                  ),
                ),
                SizedBox(
                  height: sh(40),
                ),
                BuildFooter(),
              ],
            ),
          ),
        ],
      ),
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

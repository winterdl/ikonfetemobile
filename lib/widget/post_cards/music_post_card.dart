import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/album_art.dart';
import 'package:ikonfete/widget/post_cards/partials/_header.dart';

class MusicPostCard extends StatefulWidget {
  @override
  _MusicPostCardState createState() => _MusicPostCardState();
}

class _MusicPostCardState extends State<MusicPostCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: sh(40)),
        ),
        Container(
          width: MediaQuery.of(context).size.width - sw(70),
          margin: EdgeInsets.only(bottom: sh(40)),
          padding: EdgeInsets.only(bottom: sh(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 5.0,
                blurRadius: sh(20),
                offset: Offset(0.0, sh(10)),
              )
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(sw(10)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BuildHeader(),
              _BuildPostText(),
              SizedBox(
                height: sh(20),
              ),
              _BuildSong(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildPostText extends StatelessWidget {
  const _BuildPostText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        "Check out this latest beast of a song from yours truely :D",
        style: TextStyle(
          fontSize: sf(15),
          color: IkColors.lightGrey,
        ),
      ),
    );
  }
}

class _BuildSong extends StatelessWidget {
  const _BuildSong({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: sw(20)),
        SizedBox(
          height: sw(64),
          child: AspectRatio(
            aspectRatio: 1,
            child: AlbumArt(),
          ),
        ),
        SizedBox(
          width: sw(18),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Let Me Live My Life',
              style: TextStyle(
                fontSize: sf(14),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Jane Foster',
              style: TextStyle(
                fontSize: sf(12),
                color: IkColors.lightGrey,
              ),
            ),
          ],
        ),
        const Spacer(),
        FractionalTranslation(
          translation: Offset(0.5, 0),
          child: CupertinoButton(
            minSize: sh(40),
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: Container(
              height: sf(40),
              width: sf(40),
              decoration:
                  BoxDecoration(color: primaryColor, shape: BoxShape.circle),
              child: Icon(
                Icons.play_arrow,
                size: sf(18),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

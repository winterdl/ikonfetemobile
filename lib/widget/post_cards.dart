import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/post_cards/partials/_footer.dart';
import 'package:ikonfete/widget/post_cards/partials/_header.dart';

class TextPostCard extends StatefulWidget {
  @override
  _TextPostCardState createState() => _TextPostCardState();
}

class _TextPostCardState extends State<TextPostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: sh(40)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 5.0,
                blurRadius: 20.0,
                offset: Offset(0.0, 10.0))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BuildHeader(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: sw(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lorem Bloody Ipsum illo inventore veritatis et quasi architecto beatae vitae dicta sunui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam',
                  style: TextStyle(
                    fontSize: sf(14),
                    color: IkColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            child: BuildFooter(),
            padding: EdgeInsets.all(sw(20)),
          ),
        ],
      ),
    );
  }
}

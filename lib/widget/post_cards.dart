import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';

class TextPostCard extends StatefulWidget {
  @override
  _TextPostCardState createState() => _TextPostCardState();
}

class _TextPostCardState extends State<TextPostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
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
          _buildHeader(),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Lorem Bloody Ipsum illo inventore veritatis et quasi architecto beatae vitae dicta sunui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF0707070),
                  ),
                ),
                SizedBox(
                  height: 40.0,
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

  Widget _buildHeader() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
      leading: CircleAvatar(
        radius: 18.0,
        backgroundImage: AssetImage('assets/images/onboard_background1.png'),
      ),
      title: Text(
        'Jane Foster',
        style: TextStyle(
          fontSize: 16.0,
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {},
      ),
      subtitle: Text(
        '10 MINS AGO'.toUpperCase(),
        style: TextStyle(
          fontSize: 13.0,
          color: Color(0xFF0707070),
        ),
      ),
      enabled: true,
    );
  }

  Widget _buildLikes() {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
            color: primaryColor,
            size: 26.0,
          ),
        ),
        Text(
          '18K',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "SanFranciscoDisplay",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10.0,
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
                  radius: 14.0,
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
                  radius: 14.0,
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
                  radius: 14.0,
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
        Icon(
          Icons.comment,
          color: Colors.black.withOpacity(0.4),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          "2",
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "SanFranciscoDisplay",
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

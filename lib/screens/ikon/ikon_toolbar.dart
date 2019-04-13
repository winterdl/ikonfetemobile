import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';

class IkonToolbar extends StatelessWidget {
  final num numFollowers;
  final double width;
  final Function streamActionHandler;
  final Function messageActionHandler;
  final Function playActionHandler;

  IkonToolbar({
    @required this.width,
    @required this.numFollowers,
    @required this.streamActionHandler,
    @required this.messageActionHandler,
    @required this.playActionHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "$numFollowers\n",
              style: TextStyle(fontSize: 20.0),
              children: [
                TextSpan(
                  text: 'Following',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white.withOpacity(0.64),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 16.0),
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: IconButton(
                  iconSize: 20.0,
                  alignment: Alignment.center,
                  icon: Icon(
                    FontAwesome5Icons.stream,
                    color: Colors.white,
                  ),
                  onPressed: streamActionHandler,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16.0),
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: IconButton(
                  iconSize: 20.0,
                  alignment: Alignment.center,
                  icon: Icon(
                    FontAwesome5Icons.comment,
                    color: Colors.white,
                  ),
                  onPressed: messageActionHandler,
                ),
              ),
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: IconButton(
                  iconSize: 20.0,
                  alignment: Alignment.center,
                  icon: Icon(
                    FontAwesome5Icons.play,
                    color: Colors.white,
                  ),
                  onPressed: playActionHandler,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
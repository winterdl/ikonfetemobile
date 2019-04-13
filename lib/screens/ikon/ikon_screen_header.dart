import 'package:flutter/material.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class IkonScreenHeader extends StatelessWidget {
  final String artistName;
  final String profilePicture;
  final int feteScore;
  final int height;

  IkonScreenHeader({
    @required this.artistName,
    @required this.profilePicture,
    @required this.feteScore,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height.toDouble(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: StringUtils.isNullOrEmpty(profilePicture)
                ? MemoryImage(kTransparentImage)
                : NetworkImage(profilePicture),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: Text(
                      artistName,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "SanFranciscoDisplay",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  _buildFeteScore(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeteScore() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(width: 25, height: 2, color: Colors.white),
        Text(feteScore.toString(),
            style: TextStyle(color: Colors.white, fontSize: 30)),
        Container(width: 25, height: 2, color: Colors.white),
      ],
    );
  }
}

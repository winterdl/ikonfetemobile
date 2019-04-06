import 'package:flutter/material.dart' show Colors, MaterialColor;
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

final primaryColor = Color(0xFFEE1C24);
final primaryActiveColor = Color(0xFFBA161C);

final primaryButtonColor = primaryColor;
final primaryButtonActiveColor = primaryActiveColor;
final textBoxColor = Color(0xFF5466AE).withOpacity(0.1);

final bodyColor = Color(0xff181D28);
final blueOverlay = Color(0xff181D28);
final facebookColor = Color(0xFF3B5998);
final twitterColor = Color(0xFF1DA1F2);
final soundCloudColor = Color(0xFFFF7700);
final spotifyColor = Color(0xFF1DB954);
final itunesColor = Color(0xFFEA4CC0);
final errorColor = Colors.red;

class IkColors {
  IkColors._();
  static const base_primary = 0xFFEE1C24;
  static const MaterialColor dark = const MaterialColor(
    0xFF444444,
    const <int, Color>{
      50: const Color(0xFFfafafa),
      100: const Color(0xFFf5f5f5),
      200: const Color(0xFFefefef),
      300: const Color(0xFFe2e2e2),
      400: const Color(0xFFbfbfbf),
      500: const Color(0xFFa0a0a0),
      600: const Color(0xFF777777),
      700: const Color(0xFF636363),
      800: const Color(0xFF444444),
      900: const Color(0xFF232323),
    },
  );

  static const MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFfafafa),
      200: const Color(0xFFf5f5f5),
      300: const Color(0xFFf0f0f0),
      400: const Color(0xFFdedede),
      500: const Color(0xFFc2c2c2),
      600: const Color(0xFF979797),
      700: const Color(0xFF818181),
      800: const Color(0xFF606060),
      900: const Color(0xFF3c3c3c),
    },
  );

  static const Color lightGrey = const Color(0xFF8d92a3);
  static const Color disabled_color = const Color(0xFFe5e5e5);
  static const Color smoke = const Color(0xFFF6F6F6);
  static const Color primary = const Color(base_primary);
  static const Color background = const Color(0xFFFBFBFB);
  static const Color background2 = const Color(0xFFF8F8F8);
  static const Color background3 = const Color(0xFFF7F7F7);
  static const Color lighterGrey = const Color(0xFFEFEFEF);
  static const Color google = const Color(0xFFD62D20);
}

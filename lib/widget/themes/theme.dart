// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the Mk app.
///
class IkTheme extends InheritedWidget {
  const IkTheme({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  TextStyle get xxsmall => _text10Style;
  TextStyle get xxsmallSemi =>
      _text10Style.copyWith(fontWeight: FontWeight.w500);
  TextStyle get xxsmallHint => xxsmall.copyWith(color: IkColors.lightGrey);
  TextStyle get xsmall => _text11Style;
  TextStyle get xsmallHint => xsmall.copyWith(color: Colors.grey);
  TextStyle get small => _text12Style;
  TextStyle get smallMedium => small.copyWith(fontWeight: FontWeight.w500);
  TextStyle get smallBold => small.copyWith(fontWeight: FontWeight.w700);
  TextStyle get smallSemi => small.copyWith(fontWeight: FontWeight.w600);
  TextStyle get smallLight => small.copyWith(fontWeight: FontWeight.w300);
  TextStyle get smallHint => small.copyWith(color: IkColors.lightGrey);
  TextStyle get smallBtn => smallMedium.copyWith(color: IkColors.primary);
  TextStyle get body1 => _text14Style;
  TextStyle get body2 => body1.copyWith(height: 1.5);
  TextStyle get body3 => _text14Style;
  TextStyle get body3Hint => body3.copyWith(color: Colors.grey);
  TextStyle get body3Light => body3.copyWith(fontWeight: FontWeight.w300);
  TextStyle get body3Semi => body3.copyWith(fontWeight: FontWeight.w600);
  TextStyle get body3Medium => _text14MediumStyle;
  TextStyle get body3MediumHint => body3Medium.copyWith(color: Colors.grey);
  TextStyle get bodyMedium => body1.copyWith(fontWeight: FontWeight.w500);
  TextStyle get bodySemi => body1.copyWith(fontWeight: FontWeight.w600);
  TextStyle get bodyBold => body1.copyWith(fontWeight: FontWeight.w700);
  TextStyle get bodyHint => body1.copyWith(color: Colors.grey);
  TextStyle get button => _text15MediumStyle;
  TextStyle get title => _header18Style;
  TextStyle get title1 => _header17Style;
  TextStyle get subhead1 => _text15MediumStyle;
  TextStyle get subhead1Semi => _text15SemiStyle;
  TextStyle get subhead1Bold => _text15BoldStyle;
  TextStyle get subhead1Light => _text15LightStyle;
  TextStyle get subhead2 => _text14Style;
  TextStyle get subhead5 => _text14Style;
  TextStyle get subhead2Semi => subhead2.copyWith(fontWeight: FontWeight.w600);
  TextStyle get subhead3 => _text16Style;
  TextStyle get subhead3Semi => subhead3.copyWith(fontWeight: FontWeight.w600);
  TextStyle get subhead3Light => subhead3.copyWith(fontWeight: FontWeight.w300);
  TextStyle get subhead3Medium =>
      subhead3.copyWith(fontWeight: FontWeight.w500);
  TextStyle get subhead4 => _text18Style;
  TextStyle get subhead4Semi => subhead4.copyWith(fontWeight: FontWeight.w600);
  TextStyle get subhead4Medium =>
      subhead4.copyWith(fontWeight: FontWeight.w500);
  TextStyle get headline => _header20Style;

  TextStyle get appBarTitle => title1.copyWith(
      fontFamily: 'SFPro',
      fontWeight: FontWeight.w300,
      color: IkColors.dark.shade900,
      letterSpacing: .35);

  TextStyle get display1 => _text20Style;
  TextStyle get display1Light => display1.copyWith(fontWeight: FontWeight.w300);
  TextStyle get display1Semi => display1.copyWith(fontWeight: FontWeight.w600);
  TextStyle get display1Medium =>
      display1.copyWith(fontWeight: FontWeight.w500);
  TextStyle get display1Bold => display1.copyWith(fontWeight: FontWeight.w700);
  TextStyle get display2 => _text24Style.copyWith(height: 1.05);
  TextStyle get display2Semi => display2
      .copyWith(fontWeight: FontWeight.w600)
      .copyWith(fontFamily: 'Roboto');
  TextStyle get display2Bold => display2.copyWith(fontWeight: FontWeight.w700);
  TextStyle get display3 => _header28Style;
  TextStyle get display4 => _text32Style;
  TextStyle get display4Medium =>
      _text32Style.copyWith(fontWeight: FontWeight.w500);
  TextStyle get display4Semi => display4.copyWith(fontWeight: FontWeight.w600);
  TextStyle get display4Light => display4.copyWith(fontWeight: FontWeight.w300);
  TextStyle get display4Italic =>
      display4.copyWith(fontStyle: FontStyle.italic);
  TextStyle get display4Bold => _header32Style;

  TextStyle get textfield => subhead3;

  TextStyle get textfieldLabel => subhead3.copyWith(
        color: IkColors.primary,
      );
  TextStyle get errorStyle => small.copyWith(color: errorColor);

  TextStyle get _header17Style =>
      mkFontMedium(17.0).copyWith(color: IkColors.dark.shade900);
  TextStyle get _header18Style => mkFontMedium(18.0);
  TextStyle get _header20Style => mkFontMedium(20.0);
  TextStyle get _header28Style => mkFontMedium(28.0);
  TextStyle get _header32Style => mkFontMedium(32.0);

  TextStyle get _text10Style => mkFontRegular(10.0);
  TextStyle get _text11Style => mkFontRegular(11.0);
  TextStyle get _text12Style => mkFontRegular(12.0);
  TextStyle get _text13Style => mkFontRegular(13.0);
  TextStyle get _text14Style => mkFontRegular(14.0).copyWith(height: 1.3);
  TextStyle get _text14MediumStyle => mkFontMedium(14.0);
  TextStyle get _text15SemiStyle => mkFontMedium(15.0);
  TextStyle get _text15BoldStyle => mkFontBold(15.0);
  TextStyle get _text15LightStyle => mkFontLight(15.0);
  TextStyle get _text15MediumStyle => mkFontRegular(16.0);
  TextStyle get _text16Style => mkFontRegular(16.0);
  TextStyle get _text18Style => mkFontRegular(18.0);
  TextStyle get _text20Style => mkFontRegular(20.0);
  // TextStyle get _text22Style => mkFontRegular(22.0);
  TextStyle get _text24Style => mkFontRegular(24.0);
  TextStyle get _text32Style => mkFontRegular(32.0);

  static IkTheme of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(IkTheme);
  }

  ThemeData themeData(ThemeData theme) {
    return ThemeData(
      // accentColor: kAccentColor,
      // primarySwatch: kPrimarySwatch,
      primaryColor: primaryColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(
        color: primaryColor,
      ),
      textTheme: theme.textTheme.copyWith(
        body1: theme.textTheme.body1.merge(
          body1,
        ),
        button: theme.textTheme.button.merge(
          button,
        ),
      ),
      canvasColor: Colors.white,
      buttonTheme: theme.buttonTheme.copyWith(
        height: sh(60),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        labelStyle: textfieldLabel,
        errorStyle: errorStyle,
        hasFloatingPlaceholder: true,
        hintStyle: body1.copyWith(color: IkColors.lightGrey),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(
            color: IkColors.lightGrey,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: IkColors.primary, width: .3),
        ),
      ),
      cursorColor: IkColors.dark.shade900,
      // fontFamily: IkStyle.base,
      hintColor: IkColors.lightGrey,
      dividerColor: kBorderSideColor,
    );
  }

  @override
  bool updateShouldNotify(IkTheme oldWidget) => false;
}

const Color kPrimaryColor = IkColors.primary;

const Color kHintColor = const Color(0xFFAAAAAA);
const Color kDividerColor = const Color(0xd8d5d5);
const Color kBorderSideColor = const Color(0x66D1D1D1);
Color kTextBaseColor = IkColors.dark.shade900;
const Color kTitleBaseColor = Colors.black;
const Color kBackgroundBaseColor = Colors.white;
const Color kAppBarBackgroundColor = Colors.white;

const double kBaseScreenHeight = 896.0;
const double kBaseScreenWidth = 414.0;

const double kButtonHeight = 48.0;
const double kButtonMinWidth = 200.0;

const BorderRadius kBorderRadius = const BorderRadius.all(Radius.circular(4.0));

class MkBorderSide extends BorderSide {
  const MkBorderSide({
    Color color,
    BorderStyle style,
    double width,
  }) : super(
          color: color ?? kBorderSideColor,
          style: style ?? BorderStyle.solid,
          width: width ?? 1.0,
        );
}

class IkStyle extends TextStyle {
  IkStyle.mkFont({
    double fontSize,
    FontWeight fontWeight,
    Color color,
  }) : super(
          inherit: false,
          color: color ?? kTextBaseColor,
          fontFamily: "SanFranciscoDisplay",
          fontSize: sf(fontSize.toInt()),
          fontWeight: fontWeight ?? IkStyle.regular,
          // wordSpacing: -2.5,
          // letterSpacing: -0.5,
          textBaseline: TextBaseline.alphabetic,
        );

  static const FontWeight light = FontWeight.w200;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

TextStyle mkFont(double fontSize, Color color) =>
    IkStyle.mkFont(fontSize: fontSize, color: color);

TextStyle mkFontColor(Color color) => IkStyle.mkFont(color: color);

TextStyle mkFontLight(double fontSize, [Color color]) => IkStyle.mkFont(
      fontSize: fontSize,
      fontWeight: IkStyle.light,
      color: color ?? kTextBaseColor,
    );
TextStyle mkFontRegular(double fontSize, [Color color]) => IkStyle.mkFont(
      fontSize: fontSize,
      fontWeight: IkStyle.regular,
      color: color ?? kTextBaseColor,
    );
TextStyle mkFontMedium(double fontSize, [Color color]) => IkStyle.mkFont(
      fontSize: fontSize,
      fontWeight: IkStyle.medium,
      color: color ?? kTextBaseColor,
    );

TextStyle mkFontBold(double fontSize, [Color color]) => IkStyle.mkFont(
      fontSize: fontSize,
      fontWeight: IkStyle.bold,
      color: color ?? kTextBaseColor,
    );

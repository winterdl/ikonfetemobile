import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}

double sf(int fontSize, {bool fontScaling = false}) => fontScaling
    ? ScreenUtil.getInstance().setSp(fontSize)
    : ScreenUtil(allowFontScaling: true).setSp(fontSize);

double sh(int height) => ScreenUtil.getInstance().setWidth(height);

double sw(int width) => ScreenUtil.getInstance().setWidth(width);
MediaQueryData get mq => ScreenUtil.mediaQueryData;

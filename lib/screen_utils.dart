import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}

void sf(int fontSize, {bool fontScaling = false}) {
  fontScaling
      ? ScreenUtil.getInstance().setSp(fontSize)
      : ScreenUtil(allowFontScaling: true).setSp(fontSize);
}

void sh(int height) {
  ScreenUtil.getInstance().setWidth(height);
}

void sw(int width) {
  ScreenUtil.getInstance().setWidth(width);
}

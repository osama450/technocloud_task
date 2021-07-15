import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

Color primaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

Color accentColor(BuildContext context) {
  return Theme.of(context).accentColor;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double setWidth(double width) {
  return ScreenUtil().setWidth(width);
}

double setHeight(double height) {
  return ScreenUtil().setHeight(height);
}

double setSp(double size) {
  return ScreenUtil().setSp(size);
}

enum ToastType { success, failed }


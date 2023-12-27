import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static appTheme() => ThemeData(
    primaryColor: AppColor.kPrimaryAppColor,
    iconTheme: new IconThemeData(color: AppColor.kPrimaryAppColor),
    scaffoldBackgroundColor: Colors.white,
    colorScheme:
    ColorScheme.fromSwatch().copyWith(secondary: AppColor.kPrimaryAppColor),

  );
}
import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static appTheme() => ThemeData(
        primaryColor: AppColor.kPrimaryAppColor,
        iconTheme: new IconThemeData(color: AppColor.kPrimaryAppColor),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.kPrimaryAppColor,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.kPrimaryAppColor,
        ),
        dialogTheme: DialogTheme(backgroundColor: Colors.white),
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicall/app/app_export.dart';


class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(color: Colors.white);
  static BoxDecoration get fillIndigo =>
      BoxDecoration(color: appTheme.indigo50);
}

class BorderRadiusStyle{
  //Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(10);
}
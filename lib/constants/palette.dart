import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor mainTheme = MaterialColor(
    0xff2B3557, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff2B3557), //10%
      100: Color(0xff2B3557), //20%
      200: Color(0xff2B3557), //30%
      300: Color(0xff2B3557), //40%
      400: Color(0xff2B3557), //50%
      500: Color(0xff2B3557), //60%
      600: Color(0xff2B3557), //70%
      700: Color(0xff2B3557), //80%
      800: Color(0xff2B3557), //90%
      900: Color(0xff2B3557), //100%
    },
  );
} // you can d

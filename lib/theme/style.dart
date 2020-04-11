import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      primaryColor: Colors.white, //Title Bar
      accentColor: Colors.white,
      hintColor: Colors.white,
      dividerColor: Colors.grey,
      buttonColor: Color(0xFFf44336),
      scaffoldBackgroundColor: Colors.white,
        canvasColor: Color(0xFFf44336),
      //buttonColor: Color(0xFFFF1919),
      fontFamily: "CustomFont",
    //Color(0xFF093255)
  );
}

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);


final kHintTextStyle = TextStyle(
  color: Colors.grey,
);

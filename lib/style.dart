import 'package:flutter/material.dart';

var theme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
      )
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1, // 그림자
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.red), // css style 태그 같은 느낌 ThemeData 위젯은 가까운 스타일을 가장먼저 적용함
), // 복잡한 위젯은 복잡한위젯Theme() 안에서 스타일 줘야함
);
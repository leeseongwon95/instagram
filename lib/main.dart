import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.blue),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.black)
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.red),
        )
      ), // css style 태그 같은 느낌 ThemeData 위젯은 가까운 스타일을 가장먼저 적용함
      home: MyApp(), // 복잡한 위젯은 복잡한위젯Theme() 안에서 스타일 줘야함
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram', style: TextStyle(color: Colors.black),),
        actions: [
          Icon(Icons.add_box_outlined)
      ],),
      body: Text(' ')
    );
  }
}

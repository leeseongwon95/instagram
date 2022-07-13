import 'package:flutter/material.dart';
import './style.dart' as style; // import 할 때 변수 중복문제 피하기

void main() {
  runApp(
    MaterialApp(
      theme: style.theme,
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
        title: Text('Instagram'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          ),
      ],),
      body: TextButton(onPressed: (){}, child: Text('btn', style: Theme.of(context).textTheme.bodyText2),),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),
      ],
      ),
    ); // Theme.of 로 원하는 ThemeData 안의 내용 쓸수있음
  }
}

import 'package:flutter/material.dart';
import 'package:instagram/notification.dart';
import 'package:instagram/pages/upload.dart';
import 'styles/style.dart' as style; // import 할 때 변수 중복문제 피하기
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'stores/store1.dart';
import 'stores/store2.dart';
import 'pages/home.dart';
import 'notification.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: style.theme,
      home: MyApp(), // 복잡한 위젯은 복잡한위젯Theme() 안에서 스타일 줘야함
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  // var userContent; // 유저가 입력한 글 저장공간

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age' : 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없음';
    print(jsonDecode(result)['age']);
  }

  addData(a) {
    setState((){
      data.add(a);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
    // http.get 함수도 오래걸리는 함수임 (전문용어로 Future)
  }

  @override
  void initState() {
    super.initState(); // MyApp 위젯이 로드될 때 실행됨.
    saveData();
    getData();
    initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'), onPressed: (){
        showNotification();
      },),
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState((){
                  userImage = File(image.path);
                });
              }


              // ignore: use_build_context_synchronously
              Navigator.push(context,
                MaterialPageRoute(builder: (c) => Upload(
                  userImage: userImage,)),
              );
              },
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          ),
        ],
      ),
      body: [Home(data: data, addData: addData,), Text('샵')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            // onTap 으로 i 가 바뀜 (네비게이션바의 숫자가)
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),
        ],
      ),
    ); // Theme.of 로 원하는 ThemeData 안의 내용 쓸수있음
  }
}
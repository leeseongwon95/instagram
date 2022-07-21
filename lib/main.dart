import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style; // import 할 때 변수 중복문제 피하기
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용함
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: style.theme,
    // initialRoute: '/',
    // routes: {
    //   '/' : (c) => Text('첫페이지'),
    //   '/detail' : (c) => Text('둘째페이지'), // 페이지 많으면 routes 사용해도됨
    // },
    home: MyApp(), // 복잡한 위젯은 복잡한위젯Theme() 안에서 스타일 줘야함
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

  // addMyData(){
  //   var myData = { // 유저의 게시물 완성
  //     'id': data.length, // 게시물의 유니크한 id
  //     'image': userImage,
  //     'likes': 5,
  //     'date': 'July 25',
  //     'content': userContent,
  //     'liked': false,
  //     'user': 'John Kim',
  //   };
  //   setState((){
  //     data.insert(0, myData); // add 는 맨뒤에 추가되기때문에 insert 쓴거임
  //   });
  // }

  // setUserContent(a){
  //   setState((){
  //     userContent = a;
  //   });
  // }

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age' : 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없음';
    print(jsonDecode(result)['age']);
    // storage.setString('name', 'john');
    // var result = storage.getString('name');
    // print(result);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    print(result2);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() { // 필요없어지면 제거하는 것도 성능상 좋음
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
        print(widget.data.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']) ,
                //유저가 선택한 이미지는 _File타입임
                GestureDetector(
                  child: Text(widget.data[i]['user']),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (c) => Profile()),
                    );
                  },
                ),
                Text('좋아요 ${widget.data[i]['likes']}'),
                Text(widget.data[i]['user']),
                Text(widget.data[i]['content']),
              ],
            );
          });
    } else {
      return Text('로딩중임');
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage,}) : super(key: key);
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( actions: [
        IconButton(onPressed: (){
          }, icon: Icon(Icons.send))
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지업로드화면'),
          TextField(onChanged: (text){
          },),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body : Text('프로필페이지'),
    );
  }
}

// FutureBuilder (
//  future: http.get(어쩌구),
//  builder: (context, snapshot) {
//    if (snapshot.hasData) {
//    return Text('post에 데이터 있으면 보여줄 위젯')
//    }
//    return Text('post에 데이터 없으면 보여줄 위젯')
//    },
//  )
// 1. future: 안에는 Future를 담은 state 이름을 적으면 됩니다.
// http.get() 이런거 직접 적어도 되긴 하지만 state에 저장했다가 쓰는게 좋을 수 있습니다.
// 2. builder: (){return 어쩌구} 안의 코드는 입력한 state 데이터가 도착할 때 실행해줍니다.
// 3. 그리고 snapshot 이라는 파라미터가 변화된 state 데이터를 의미합니다.
// 그래서 아까와 같은 상황을 좀 더 매끄럽게 해결가능한데
// 딱 한번 데이터가 도착하고
// 도착시 위젯을 보여줘야할 경우 FutureBuilder가 유용할 수 있는데
// 데이터가 추가되는 경우가 잦으면 불편해서 쓸모없습니다.


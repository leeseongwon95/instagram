import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './style.dart' as style; // import 할 때 변수 중복문제 피하기
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용함
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: style.theme,
      // initialRoute: '/',
      // routes: {
      //   '/' : (c) => Text('첫페이지'),
      //   '/detail' : (c) => Text('둘째페이지'), // 페이지 많으면 routes 사용해도됨
      // },
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
                      PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Profile(),
                          transitionsBuilder: (c, a1, a2, child) =>
                              SlideTransition(
                                  position: Tween(
                                    begin: Offset(-1.0, 0.0),
                                    end: Offset(0.0, 0.0),
                                  ).animate(a1),
                                child: child,
                              ),

                      ),
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

class Store2 extends ChangeNotifier {
  var name = 'john kim';
}


class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;
  var profileImage = [];
  
  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }
  
  addFollower(){
    if (friend == false){
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name),),
      body : Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower}명'),
          ElevatedButton(onPressed: (){
              context.read<Store1>().addFollower();
          }, child: Text('팔로우')),
          ElevatedButton(onPressed: (){
            context.read<Store1>().getData();
          }, child: Text('사진가져오기')),
        ],
      ),
    );
  }
}



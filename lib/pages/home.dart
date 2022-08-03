import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'profile.dart';

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
                    ? Image.network(widget.data[i]['image'],)
                    : Image.file(widget.data[i]['image']) ,
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

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

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
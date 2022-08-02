import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/store1.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
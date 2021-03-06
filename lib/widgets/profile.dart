import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:myapp/provider/google_auth.dart';
// import 'package:provider/provider.dart';
// import 'main_page.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 32,
          ),
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(user.photoURL!),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Hello ' + user.displayName! + ' !',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            user.email!,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/*
Separated Widget for Drawer

*/


import 'dashboard.dart';
import 'login.dart';
import 'main.dart';
import 'users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[500]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser!.email! ?? "unknown",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
                  onTap: () {
                    Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
          ListTile(
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => Users()));
            },
            leading: Icon(Icons.person),
            title: Text('Users'),
          ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  onTap: () async {
                        FirebaseAuth.instance.signOut();
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                ),
              ),
            )
        ],
      ),
    );
  }
}
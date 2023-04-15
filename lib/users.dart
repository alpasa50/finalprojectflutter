import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

import 'DrawerWidget.dart';

class UsersModel {
  final int id;
  final String name;
  final String username;
  final String email;

  const UsersModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email
  });
  

factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future<List<UsersModel>> _fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<UsersModel> users = data.map((item) => UsersModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.green[900],
      ),
      body: FutureBuilder<List<UsersModel>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                    title: Text("Id: ${user.id} \nName: ${user.name}"),
                    subtitle: Text("Username: ${user.username} \nEmail: ${user.email}"),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
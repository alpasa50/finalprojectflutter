import 'dart:convert';
import 'dart:math';

import 'users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

import 'DrawerWidget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    super.initState();
    //Call fetching data mehtod when dashboard init state
    _fetchFacts();
  }
  

  final Random _random = Random();
  // Creating an empty list with a given lenght (20)
  List<String> _factList = List.filled(20, "");

  //Future async to wait for the response
  Future<void> _fetchFacts() async {
    for (int i = 0; i < 20; i++) {
      final month = Random().nextInt(12) + 1;
      final day = Random().nextInt(31) + 1;
      final url = 'http://numbersapi.com/$month/$day/date';
      final response = await http.get(Uri.parse(url));
      setState(() {
        _factList[i] = response.body;
      });
    }
  }

  // Function to regenerate list
  Future<void> _refreshFacts() async {
    setState(() {
      _factList = List.filled(20, '');
    });
    await _fetchFacts();
  }
  
  @override
  Widget build(BuildContext context) {
    //Creating imageids random 100 * 10 because some numbers have problems an API
  final List<int> _imageIds = List.generate(20, (_) => (_random.nextInt(10) * 100) + 100);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: DrawerWidget(), // Drawer as a separate widget
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.green[900],
      ),
      body: Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Random Images List and Facts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      onPressed: () {
        _refreshFacts();
      }, child: Icon(Icons.refresh),
    ),
    Expanded(
      //Fetching data with a ListView.builder to show it when is loading
      child: ListView.builder(
        itemCount: _imageIds.length,
        itemBuilder: (BuildContext context, int index) {
          final imageUrl = 'https://picsum.photos/250?image=${_imageIds[index]}';
          final fact = _factList[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)
            ),
            child: ListTile(
              title: Text(fact),
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
              ),
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }
}


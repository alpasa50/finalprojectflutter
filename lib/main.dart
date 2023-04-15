import 'login.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  
  runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if(snapshot.hasData){
          return Dashboard();
        }else{
          return HomePage();
        }
      }),
    ),
  )
);
}

class HomePage extends StatelessWidget {
 
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder( 
        future: _initializeFirebase(),
        builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },)     
    );
  }
}

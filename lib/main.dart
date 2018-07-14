import 'package:cloudinn_hr/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
void main() => runApp(new MaterialApp(
      home: new SplashScreen(),
    ));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  void navigate(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                child: new InkWell(
                  child: new Image.asset(
                    "assets/logo.png",
                    width: 80.0,
                    height: 80.0,
                  ),
                ),
                margin: new EdgeInsets.only(top: 100.0),
              ),
              new Center(
                child: new Container(
                  child: new Text(
                    "cloudinn HR",
                    style: new TextStyle(
                      fontSize: 30.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: new EdgeInsets.only(bottom: 130.0),
                ),
              ),
              new InkWell(
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RaisedButton(
                    onPressed: navigate,
                    color: Colors.blue,
                    child: new Text(
                      "Login With Google",
                      style: new TextStyle(color: Colors.white),
                    ),
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4),()=>
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new MyApp()),
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                        child: new Container(
                          child: new Image.asset("assets/logo.png"),
                        ),
                      radius: 60.0,
                    ),
                    new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                    ),
                    new Text("cloudinnHR",
                    style: new TextStyle(color: Colors.blue,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    Text("Loading",style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                    ),
                    new Center(
                      child: Text("Now",style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
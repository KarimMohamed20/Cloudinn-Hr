import 'dart:async';
import 'package:cloudinn_hr/UserPage.dart';
import 'package:cloudinn_hr/WorkFromHomeCalendar.dart';
import 'package:cloudinn_hr/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloudinn_hr/main.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:web_socket_channel/io.dart';
class WorkFromHome extends StatefulWidget {
  @override
  _WorkFromHome createState() => new _WorkFromHome();
}
class _WorkFromHome extends State<WorkFromHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new UserPage(user.displayName, user.email, user.photoUrl)));
    print("Username: ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed Out");
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Work From Home"),
          centerTitle: true,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Container(
                child: new UserAccountsDrawerHeader(
                  accountName: new Text(
                    "cloudinnHR",
                    style: new TextStyle(color: Colors.black),
                  ),
                  accountEmail: new Text("info@cloudinn.net",
                      style: new TextStyle(color: Colors.black)),
                  currentAccountPicture: new Image.asset("assets/logo.png"),
                  decoration: new BoxDecoration(color: Colors.white),
                ),
              ),
              new ListTile(
                title: new Text("HomePage"),
                leading: new Icon(Icons.home),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new HomePage())),
              ),
              new ListTile(
                onTap: () => _signIn()
                    .then(
                      (FirebaseUser user) => print(user),
                    )
                    .catchError((e) => print(e)),
                title: new Text("Account Info"),
                leading: new Icon(Icons.account_circle),
              ),
              new Container(
                padding: const EdgeInsets.all(105.0),
              ),
              new Container(
                child: new ListTile(
                  onTap: _signOut,
                  title: new Text(
                    "SignOut!",
                    style: new TextStyle(color: Colors.white),
                  ),
                  leading: new Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                color: Colors.red,
                padding: const EdgeInsets.all(10.0),
              ),
            ],
          ),
        ),
        body: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Calendar(
                    isExpandable: true,
                    onDateSelected: (date) => Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new Calendar_Text_Confirm(
                                  pageText:
                                      "${date.year}/${date.month}/${date.day}",
                                  channel: new IOWebSocketChannel.connect(
                                      "ws://echo.websocket.org"),
                                ),
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

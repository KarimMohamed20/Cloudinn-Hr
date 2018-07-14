import 'WorkFromHome.dart';
import 'package:cloudinn_hr/UserPage.dart';
import 'package:cloudinn_hr/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
  idToken: gSA.idToken, accessToken: gSA.accessToken);
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context)=> new UserPage(user.displayName, user.email, user.photoUrl)));
    new UserPage(user.displayName, user.email, user.photoUrl);
    print("Username: ${user.displayName}");
    return user;
  }
  void _signOut(){
    googleSignIn.signOut();
    print("User Signed Out");
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new MyApp()));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(
              child: new UserAccountsDrawerHeader(accountName: new Text(
                "cloudinnHR",style: new TextStyle(color: Colors.black),
              ),
                accountEmail: new Text("info@cloudinn.net",style: new TextStyle(color: Colors.black)),
                currentAccountPicture: new Image.asset("assets/logo.png"),
                decoration: new BoxDecoration(color: Colors.white),
              ),
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
              padding: const EdgeInsets.all(135.0),
            ),
            new Container(
              child: new ListTile(onTap: _signOut,
                title: new Text("SignOut!",style: new TextStyle(color: Colors.white),),
                leading: new Icon(Icons.arrow_back,color: Colors.white,),

              ),
              color: Colors.red,
              padding: const EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Cloudinn Hr"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(160.0),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: ()=>
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context)=>new WorkFromHome()
                      ),
                  ),
                child: new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Work From Home Request",
                        style: new TextStyle(fontWeight: FontWeight.bold),
              ),
                      new Icon(Icons.navigate_next),
                    ],
                  ),
                ),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(25.0),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: ()=>
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context)=>new WorkFromHome()
                      ),
                  ),
                child: new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Vacation Request",
                        style: new TextStyle(fontWeight: FontWeight.bold),
              ),
                      new Icon(Icons.work),
                    ],
                  ),
                ),
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(25.0),
            ),
          ),
        ],
      ),
    );
  }
}
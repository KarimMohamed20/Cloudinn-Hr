import 'package:cloudinn_hr/home_page.dart';
import 'package:cloudinn_hr/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
class UserPage extends StatefulWidget {
   final String userName;
   final String userEmail;
   final String userPhoto;
  UserPage(this.userName,this.userEmail,this.userPhoto);
  @override
  UserPageState createState() {
    return new UserPageState();
  }
}

class UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new UserPage(user.displayName, user.email, user.photoUrl)));
    new UserPage(user.displayName, user.email, user.photoUrl);
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
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(
              child: new UserAccountsDrawerHeader(accountName: new Text(
                "cloudinnHR", style: new TextStyle(color: Colors.black),
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
            ),//0552331813
            new ListTile(
              onTap: () =>
                  _signIn()
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
              child: new ListTile(onTap: _signOut,
                title: new Text(
                  "SignOut!", style: new TextStyle(color: Colors.white),),
                leading: new Icon(Icons.arrow_back, color: Colors.white,),

              ),
              color: Colors.red,
              padding: const EdgeInsets.all(10.0),
            )
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text('Your Account Info'),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[

            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      "Username : " + widget.userName,
                      style: new TextStyle(color: Colors.black)
                      , textAlign: TextAlign.center,
                    ),
                    accountEmail: new Text(
                      "Email : " + widget.userEmail,
                      style: new TextStyle(
                          color: Colors.black
                      ),
                      textAlign: TextAlign.center,
                    ),
                    currentAccountPicture: new Container(
                      child: new Image.network(widget.userPhoto),
                      alignment: Alignment.center,
                    ), decoration: new BoxDecoration(

                      color: Colors.transparent
                  ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(143.0),
                  ),
                  new RaisedButton(
                    onPressed: _signOut,
                    color: Colors.red,
                    child: new Text("SignOut!"),
                    padding: const EdgeInsets.all(20.0)
                    ,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

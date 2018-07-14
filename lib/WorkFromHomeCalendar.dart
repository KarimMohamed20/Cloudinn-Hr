import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

var idProvider;
class Calendar_Text_Confirm extends StatefulWidget {
  final WebSocketChannel channel;
  final String pageText;
  Calendar_Text_Confirm({this.pageText,@required this.channel});

  @override
  Calendar_Text_ConfirmState createState() {
    return new Calendar_Text_ConfirmState();
  }
}

class Calendar_Text_ConfirmState extends State<Calendar_Text_Confirm> {
  var _text = "Confirm Your Request";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
  idToken: gSA.idToken, accessToken: gSA.accessToken);
    print("Username: ${user.displayName}");
    return user;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Work From Home Request"),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child:new Text("The Date You Selected \n"+"${widget.pageText}",
              style: new TextStyle(fontSize: 25.0),
              )
            ),
            new StreamBuilder(builder: (context,snapshot){
              return new Padding(
                  padding: const EdgeInsets.all(20.0),
                child: new Text(snapshot.hasData ? '${snapshot.data}': ''),
              );
            },stream: widget.channel.stream,),
            new Container(
              child: new RaisedButton(
                  onPressed: (){_showAlert(_text);},
                  child: new Column(
                children: <Widget>[
                  new Icon(Icons.send,color: Colors.white,),
                  new Text
                    ("Submit",
                    style: new TextStyle
                      (color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
  void _sendMyDate(){
     _signIn()
        .then((FirebaseUser user) => widget.channel.sink.add(
         "Type: Work From Home \n"
             +
             "Date: ${widget.pageText}\n"
             +
             "User Id: ${user.uid}\n"
             +
             "User Mail: ${user.email} \n"
             +
         "User Name: ${user.displayName}"
     )
     )
        .catchError((e) => print(e));
     Navigator.pop(context);

  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  
  void _showAlert(String value){
    AlertDialog dialog = new AlertDialog(
      title: new Text("Send Request",style: new TextStyle(fontWeight: FontWeight.bold),),
      content: new Text("Confirm Your Request .",style: new TextStyle(color: Colors.black),),
      actions: <Widget>[
        new RaisedButton(onPressed: () => Navigator.pop(context),
        child: new Text(
          "Cancel",
        style: new TextStyle(
          color: Colors.black
          ),
          ),color: Colors.white,
          elevation: 0.0),
        new RaisedButton(
          onPressed: _sendMyDate,
          child: new Text(
            "Confirm",
            style: new TextStyle(
              color: Colors.black
              ),
              ),color: Colors.white,
              elevation: 0.0,
              ),

      ],
    );
    showDialog(context: context, child: dialog);
  }
}

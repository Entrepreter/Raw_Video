import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raw_video/home_page.dart';
import 'package:raw_video/network/auth_helper.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : FlatButton(
                onPressed: () {
                  signIn();
                },
                child: Text("Sign in with Google"),
                textColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor)),
              ),
      ),
    );
  }

  signIn() async {
    setState(() {
      isLoading = true;
    });
    AuthHelper a = AuthHelper();
    await a.signInWithGoogle().catchError((e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }).then((value) {
      User user = auth.currentUser;

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage(user: user)));
    });
  }
}

import 'package:esign/core/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class signup_view extends StatefulWidget {
  const signup_view({super.key});

  @override
  State<signup_view> createState() => _signup_viewState();
}

class _signup_viewState extends State<signup_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset("assets/images/logo_dark_icon.jpg"),
          Container(
            height: 30,
            width: 200 ,
            child: ElevatedButton(onPressed: () {
              AuthenticationService().handleGoogleSignIn(context);
            }, child: Image.asset("assets/icon/google_icon.jpg")),
          )
        ],
      ),
    );
  }

}

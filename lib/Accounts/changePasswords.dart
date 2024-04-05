

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/Teachers/questionare.dart';
import 'package:flutter_class/welcome.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_class/widgets.dart';


class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


class changePassword extends StatelessWidget {
  late final String classID;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final context;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  bool mat = false;
  List<bool> _selectedOptions = [false, false, false]; // Modify this based on your questions
  String Title = "";
  String Description = "";
  String Date = "";
  Character character;
  String currentAccount = "users.Students";


  changePassword(this.character, this.context){
    if (character.toString() == "Character.student") {
      currentAccount = "users.Students";
    }
    else if (character.toString() == "Character.teacher") {
      print("ello");
      currentAccount = "users.Teachers";
    }
    else if (character.toString() == "Character.parent") {
      currentAccount = "users.parent";

    }
    else if (character.toString() == "Character.guest"){
      currentAccount = "users.guest";

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 16),

            Text(
              'Send a Verification Email to Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  resetPassword();
                  //CHECK FOR PASSWORDS BEING THE SAME
                  //use video
                  //https://www.youtube.com/watch?v=JkQJQt_pQho&embeds_referring_euri=https%3A%2F%2Fwww.google.com%2F&source_ve_path=MjM4NTE&feature=emb_title
                  resetPassword();
                },
                child: Text('Reset Password Via Email'),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future resetPassword() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "password email sent",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch(e){
      print(e);
      print("LAWL didn't work");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.message!,
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context).pop();
    }
  }
}


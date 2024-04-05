//Code Provided by https://www.bacancytechnology.com/blog/email-authentication-using-firebase-auth-and-flutter
// import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Teachers/teacherQuestionare.dart';
import '../main.dart';
import '../welcome.dart';


class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  get user => _auth.currentUser;
  get uid => user.uid;

  get currentUser => user;




  //creates a new user with email and password
  Future signUp({required String email, required String password}) async {
    //print(uid);
    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // var actionCodeSettings = {
      //   url: 'https://www.example.com/cart?email=user@example.com&cartId=123',
      //   iOS: {
      //     bundleId: 'com.example.ios'
      //   },
      //   android: {
      //     packageName: 'com.example.android',
      //     installApp: true,
      //     minimumVersion: '12'
      //   },
      //   handleCodeInApp: true
      // };
    //   if (user != null){
    //     print("sent");
    //     user.sendEmailVerification()
    //         .then(() {
    //         // Verification email sent.
    //     })
    //     .catch((error) {
    // // Error occurred. Inspect error.code.
    // });
    // }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }

  }

  String getUID() {
    return user.uid;
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // print(uid);
      // print(email);
      // print(password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
  FirebaseFirestore db = FirebaseFirestore.instance;



  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId, String collectionName) async {
  try {
  // Get reference to Firestore collection
  var collectionRef = FirebaseFirestore.instance.collection(collectionName);

  var doc = await collectionRef.doc(docId).get();
  return doc.exists;
  } catch (e) {
  throw e;
  }
  }

  Future Googlesignup(Character character, BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
        UserCredential result = await _auth.signInWithCredential(authCredential);
        if (character.toString() == "Character.Students") {
          bool docExists = await checkIfDocExists(result.user!.uid, "users.Students");
          if (docExists == true) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
            return null;
          }
          else {
            final Map<String, Object> newMap = {
              "Students": {
                "email": googleSignInAccount.email,
                "password": "GooogleSignIn",
                "account": AuthenticationHelper().uid,
              },
            };
            db.collection("users.Students").doc(AuthenticationHelper().uid).set(newMap);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
          }

        }
        if (character.toString() == "Character.Teachers") {

            bool docExists = await checkIfDocExists(
                result.user!.uid, "users.Teachers");
            if (docExists != true) {
              final Map<String, Object> newMap = {
                "Teachers": {
                  "name": "Jack Wagner",
                  "email": googleSignInAccount.email,
                  "password": "googlesignin",
                  "account": AuthenticationHelper().uid,
                  "image": "https://cdn.discordapp.com/attachments/1070956419949535272/1134368270301016064/istockphoto-75940775-612x612.jpg"
                },
              };

              db.collection("users.Teachers")
                  .doc(AuthenticationHelper().uid)
                  .set(
                  newMap);


              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>
                      teacherQuestion(
                          character, AuthenticationHelper().uid,
                          googleSignInAccount.email,
                          "googlesignin")));
          }
          else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
            return null;
          }
        }
        if (character.toString() == "Character.Parents") {
          bool docExists = await checkIfDocExists(
              result.user!.uid, "users.Parents");
          if (docExists != true) {
            final Map<String, Object> newMap = {
              "Parents": {
                "email": googleSignInAccount.email,
                "password": "googlesignin",
                "account": AuthenticationHelper().uid,
              },
            };
            db.collection("users.Parents").doc(AuthenticationHelper().uid).set(
                newMap);


            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>
                    MyHomePage(character, 'My Home Page')));
            db.collection("users.Parents").doc(AuthenticationHelper().uid);
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));

          return null;
        }


      // for go to the HomePage screen
    }
  }
}
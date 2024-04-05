import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/changePasswords.dart';
import 'package:flutter_class/Accounts/signup.dart';
import 'package:flutter_class/services/auth_service.dart';
import 'package:flutter_class/welcome.dart';
import 'authentication.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Login extends StatefulWidget{
  late final Character character;
  Login(this.character);

  @override
  State<Login> createState() => _LoginState(character);




}

class _LoginState extends State<Login> {
  late final Character character;
  _LoginState(this.character);
  String email = "";
  String password = "";

  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
        toolbarHeight: height/5,
        backgroundColor: Colors.blue[100],
        bottomOpacity: 0,
        elevation: 0,
        title:
        Padding(
            padding: const EdgeInsets.only(top: 0.0,),
            child: Image.asset(
              "assets/logo.PNG",
              width: width/3,
            )
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0,),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onChanged: (String newEntry) {
                  print("Username was changed to $newEntry");
                  email = newEntry;
                },
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(top: 10.0,),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onChanged: (String newEntry) {
                  print("Username was changed to $newEntry");
                  password = newEntry;
                },
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: 500,
              child: ElevatedButton(
                onPressed: (){
                  AuthenticationHelper()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                        if (result == null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyHomePage(character, 'My Home Page')));
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              result,
                              style: TextStyle(fontSize: 16),
                            ),
                          ));
                        }
                      });
                },
                child: Text("Log in",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Metropolis",
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: Colors.blue[100],
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 5,),
            // Text("-or-",
            //   style: TextStyle(
            //     fontWeight: FontWeight.w800,
            //     color: Colors.black,
            //     fontSize: 15,
            //     fontFamily: "Merriweather",
            //   ),
            // ),
            // const SizedBox(height: 5,),
            // SizedBox(
            //   height: 50,
            //   width: 500,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       AuthenticationHelper().Googlesignup(character, context);
            //     },
            //     child: Text("Log In With Google",
            //       style: TextStyle(
            //         fontWeight: FontWeight.w800,
            //         color: Colors.white,
            //         fontSize: 20,
            //         fontFamily: "Metropolis",
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       elevation: 5.0,
            //       backgroundColor: Colors.lightBlue[900],
            //       shadowColor: Colors.transparent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //         side: BorderSide(
            //           color: Colors.transparent,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 12,),
            TextButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup(character),
                      ));
                },
                child: Text(
                  "Don't have a account? Make one here",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontFamily: "Merriweather",
                    decoration: TextDecoration.underline,
                  ),
                ),
            )
          ],
        ),
        ),
      ),
    );
  }
}

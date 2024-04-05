import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/Accounts/changePasswords.dart' as ChangePasswords;
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';
import 'changePasswords.dart';

class Accountbody extends StatefulWidget {

  @override
  late final Character character;
  Accountbody(this.character);
  State<Accountbody> createState() => _AccountbodyState(this.character);
}

class _AccountbodyState extends State<Accountbody> {
  List<String> categories = ["Nonprofit Classes", "Art Class", "English Class", "Math Class", "Computer Science Class"];
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  late final Character character;
  String currentAccount = "users.Students";
  String currentData = "Students";


  _AccountbodyState(this.character){
    if (character.toString() == "Character.student") {
      currentAccount = "users.Students";
      currentData = "Students";
    }
    else if (character.toString() == "Character.teacher") {
      print("ello");
      currentAccount = "users.Teachers";
      currentData = "Teachers";
    }
    else if (character.toString() == "Character.parent") {
      currentAccount = "users.Parents";
      currentData = "Parents";


    }
    else if (character.toString() == "Character.guest"){
      currentAccount = "users.Students";
      currentData = "Students";
    }
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> fetchData() async {
    // Replace 'collectionName' with your actual collection name
    print(Auth.getUID());
    print(currentAccount);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection(currentAccount).doc(Auth.getUID()).get();
    print(snapshot.data());
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: fetchData(), // Call your fetchData function here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // Display a loading indicator while waiting for data
              } else if (snapshot.hasError) {

                return Container(

                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("upload Picture");
                        },
                        child: CircleAvatar(
                          radius: 60.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Guest",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "example@gmail.com",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),

                      SizedBox(height: 20.0),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Questionnaire'),
                                content: changePassword(this.character, context), // Display the form here
                              );
                            },
                          );

                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('Notifications'),
                        trailing: Switch(
                          value: false, // Replace with your own logic to handle settings
                          onChanged: (value) {
                            // Implement logic to update notification settings
                          },
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Language'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to language settings page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text('Security'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to security settings page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Help & Support'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to help & support page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About Us'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to about us page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log Out'),
                        onTap: () {
                          Auth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Kat(),
                              ));
                        },
                      ),
                    ],
                  ),
                ); // Display an error message if data fetching fails
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available')); // Display a message if no data is available
              } else {
                // Build your UI using the fetched data
                // You can access the data using snapshot.data
                final data = snapshot.data!.data()?[currentData]; // Extract the data from the DocumentSnapshot
                // Example: Display a text widget with a value from Firestore
                print(snapshot.data!.data()?[currentData]);
                print("hello");
                String image = "https://console.firebase.google.com/u/0/project/khoatrancodingminds/storage/khoatrancodingminds.appspot.com/files#:~:text=765%2Ddefault%2Davatar.-,png,-6.15%20KB";
                if (data?["image"] != null) {
                  image = data?["image"];
                }
                String name = currentData;
                if (data?["name"] != null) {
                  name = data["name"];
                }
                String email = "";
                if (data?["email"] != null) {
                  email = data["email"];
                }
                if (character.toString() == "Character.guest") {
                  name = "Guest";
                }
                String code = "1234";
                print(data);
                if (data["account"] != null) {
                  code = data["account"];
                }
                //code = code.substring(0, 5);
                print(code);
                print("helllo!!!");


                return Container(

                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print("upload Picture");
                        },
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                              image
                        ),
                      ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        code,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onSubmitted: (String newText) {
                          db.collection("users.Students").doc(newText).get().then((docSnapshot) {
                            if (docSnapshot.exists){
                              db.collection("users.Students").doc(newText).collection("classes").get().then((value) {
                                Map<String, dynamic> n = {"Title":"dummy"};

                                for (int i = 0; i < value.docs.length; i++){
                                  db.collection("users.Parents").doc(Auth.uid).collection("classes").doc(value.docs[i].id).set(n);

                                }



                              });
                              print("student exists");

                            }
                          });

                        },
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Questionnaire'),
                                content: changePassword(this.character, context), // Display the form here
                              );
                            },
                          );

                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('Notifications'),
                        trailing: Switch(
                          value: false, // Replace with your own logic to handle settings
                          onChanged: (value) {
                            // Implement logic to update notification settings
                          },
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.language),
                        title: Text('Language'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to language settings page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text('Security'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to security settings page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('Help & Support'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to help & support page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About Us'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement navigation to about us page
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log Out'),
                        onTap: () {
                          Auth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Kat(),
                              ));
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Account'),
                        onTap: () async {
                          await _deleteUser(context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => Kat(),
                          //     ));
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          )


        );
  }
}

Future<void> _deleteUser(BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to delete Your User from this App?'),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.delete();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text("Maybe Later"),
            )
          ],
        );
      });
}



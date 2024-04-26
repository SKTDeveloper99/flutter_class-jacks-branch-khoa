import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';

class Anounce extends StatefulWidget {
  late final Character character;
  Anounce(this.character);
  @override
  State<Anounce> createState() => AnounceState(character);

}

class AnounceState extends State<Anounce> {
  List<String> categories = ["Nonprofit Classes", "Art Class", "English Class", "Math Class", "Computer Science Class"];
  List<Widget> announce = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  late final Character character;
  String currentAccount = "users.Students";



  AnounceState(this.character){
    if (character.toString() == "Character.student") {
      currentAccount = "users.Students";
    }
    else if (character.toString() == "Character.teacher") {
      currentAccount = "users.Teachers";
    }
    else if (character.toString() == "Character.parent") {
      currentAccount = "users.parent";

    }
    else if (character.toString() == "Character.guest"){
      currentAccount = "users.guest";

    }
    refreshClasses();

  }

  void refreshClasses() {
    db.collection(currentAccount).doc(AuthenticationHelper().uid).collection("classes").get().then((querySnapshot) {
      List<Anouncement> tmpAnnouce = [];
      for (var i in querySnapshot.docs) {
        //i.id.toString() == the class id number
        db.collection("classes").doc(i.id.toString()).collection("announce").get().then((value) {
          for (var x in value.docs) {
            print(x.data());
            setState( () => tmpAnnouce.add(Anouncement(
              x.data()!["title"] ?? "Attention to Homework Fulfillment",
              x.data()!["description"] ?? "Check your homework and make sure to always read additional materials",
              x.data()!["date"] ?? "Yearly",
            )));
          }

        });
      }
      announce = tmpAnnouce;
    });

  }




  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // refreshClasses();
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height / 1.3,
              width: 300,
              child:
              announce.isEmpty ?
                   SingleChildScrollView(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Card(
                              child: Text(
                                  "Disciplines of A Teacher",
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                          ),
                          const Card(
                            child: Text(
                              "Always be a friend with students \n Always Listen to what Student says \n Always be fair to every students",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Image.network("https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2023/06/teacher-and-students.jpeg.jpg")
                        ],
                      ),
                    ),
                  ):
              ListView(
                children: announce,
              ),
            )
          ],
        ),
    );
  }
}

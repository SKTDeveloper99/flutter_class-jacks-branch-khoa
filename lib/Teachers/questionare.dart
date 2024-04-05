import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/authentication.dart';
import 'package:flutter_class/Teachers/questionare.dart';
import 'package:flutter_class/welcome.dart';
import 'package:flutter_class/widgets.dart';

class QuestionnaireForm extends StatelessWidget {
  late final String classID;
  FirebaseFirestore db = FirebaseFirestore.instance;
  AuthenticationHelper Auth = AuthenticationHelper();
  bool mat = false;
  List<bool> _selectedOptions = [false, false, false]; // Modify this based on your questions
  String Title = "";
  String Description = "";
  String Date = "";

  QuestionnaireForm(this.classID);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ToggleButtons(
                children: [
                  Text('Homework'),
                  Text('Resource'),
                  Text('Announce')
                ],
                isSelected: _selectedOptions,
                onPressed: (index) {
                    _selectedOptions[index] = !_selectedOptions[index];

                },
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLength: 18,
              onChanged: (String value) {
                Title = value;
              },

            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLength: 80,
              onChanged: (String value) {
                Description = value;
              },
            ),
            // Add more questions as needed
            SizedBox(height: 16),
            Text(
              'Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLength: 8,
              onChanged: (String value) {
                Date = value;
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final Map<String, Object> newHW = {
                    "title": Title,
                    "description": Description,
                    "date": Date,

                  };
                  final Map<String, Object> newMat = {
                    "title": Title,
                    "description": Description,
                    "file": Date,
                  };

                  final Map<String, Object> newAnnounce = {
                    "title": Title,
                    "description": Description,
                    "date": Date,
                  };
                  final Map<String, Object> newSub = {
                    "feedback": Title,
                    "uid": Description,
                    "submitted": Date,
                  };
                  if (_selectedOptions[0] == true) {
                    db.collection("classes").doc(this.classID).collection("HW").doc(Title).set(newHW);
                    db.collection("classes").doc(this.classID).collection("HW").doc(Title).collection("submissions").doc("Example").set(newSub);

                  }
                  else if (_selectedOptions[1] == true) {
                    db.collection("classes").doc(this.classID).collection("CM").doc(Title).set(newMat);
                  }
                  else if (_selectedOptions[2] == true) {
                    db.collection("classes").doc(this.classID).collection("announce").doc(Title).set(newAnnounce);
                  }



                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

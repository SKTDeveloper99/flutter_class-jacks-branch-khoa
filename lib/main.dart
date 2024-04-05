import 'package:flutter/material.dart';
import 'package:flutter_class/Accounts/account.dart';
import 'package:flutter_class/class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_class/guessClasses.dart';
import 'package:flutter_class/lectures.dart';
import 'announcements.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guessClasses.dart';
import 'guestrecruit.dart';
import 'welcome.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Kat(),
    );
  }
}

class MyHomePage extends StatefulWidget {

 // const MyHomePage({super.key, required this.title});

  final String title;
  late final Character character;
  MyHomePage(this.character, this.title);
  @override
  State<MyHomePage> createState() => _MyHomePageState(character);
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> titles = ["Class", "News", "Home", "Recruit", "Settings"];
  static List<Widget> _bodywidgetOptions = [];
  static List<BottomNavigationBarItem> NavbarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.class_),
      label: "",
      backgroundColor: Colors.blue[100],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: "",
      backgroundColor: Colors.blue[100],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "",
      backgroundColor: Colors.blue[100],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.travel_explore),
      label: "",
      backgroundColor: Colors.blue[100],
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "",
      backgroundColor: Colors.blue[100],
    ),
  ];
  late final Character character;

  _MyHomePageState(this.character){
    if (character.toString() == "Character.student") {
      titles = ["Classes", "Home", "News", "Settings"];
      _bodywidgetOptions = <Widget>[
        Classbody(character),
        Home(),
        Anounce(character),
        Accountbody(character),
      ];
      NavbarItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[0],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: titles[1],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: titles[2],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: titles[3],
          backgroundColor: Colors.blue[100],
        ),
      ];
    }
    else if (character.toString() == "Character.teacher") {
      titles = ["My Classes", "Home", "Announcements", "Settings"];
      _bodywidgetOptions = <Widget>[
        Classbody(character),
        Home(),
        Anounce(character),
        Accountbody(character),
      ];
      NavbarItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[0],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: titles[1],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: titles[2],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: titles[3],
          backgroundColor: Colors.blue[100],
        ),
      ];
    }
    else if (character.toString() == "Character.parent") {
      titles = ["Classes", "My Classes", "Home", "Announcements", "Settings"];
      _bodywidgetOptions = <Widget>[
        GuestClasses(),
        Classbody(character),
        Home(),
        Anounce(character),
        Accountbody(character),
      ];
      NavbarItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[0],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[1],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: titles[2],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: titles[3],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: titles[4],
          backgroundColor: Colors.blue[100],
        ),
      ];
    }
    else if (character.toString() == "Character.guest"){
      titles = ["Classes", "Lectures", "Home", "Recruit", "Settings"];
      _bodywidgetOptions = <Widget>[
        GuestClasses(),
        Lectures(),
        Home(),
        RecruitPage(),
        Accountbody(character),
      ];
      NavbarItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[0],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: titles[1],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: titles[2],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: titles[3],
          backgroundColor: Colors.blue[100],
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: titles[4],
          backgroundColor: Colors.blue[100],
        ),
      ];
    }
  }





  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Image.asset(
          "assets/logo.PNG",
          width: 55,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _bodywidgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.blue[100],
        items: NavbarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height - 10,
      width: width - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Our Mission",
            style: TextStyle(
              fontFamily: 'Anton',
              fontSize: 34,
            ),
          ),
          Container(
            height: 300,
            child: Scrollbar(
              child: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: Text(
                  " Our organization's goal is to share high-quality educational resources in the United States for everyone. Most of our speeches and lectures are free! Plus, we provide high quality classes at a reasonable price. Our goal is to help the children fulfill their dreams and grow their dream! We will provide high-quality information on teachers from famous schools in the United States. Parents in need can choose the courses they need for their children, including English reading, English writing, grammar, art, math, computer science, middle school and college guidance planning, counseling and other aspects of college entrance examination. Additionally, we will organize some meaningful offline activities, as well as public welfare activities for students to help each other, to jointly create an educational community environment of mutual help. Our students come from all over the world, we share educational resources and develop together!",
                  style: TextStyle(fontFamily: 'Merriweather'),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.black,
                  width: 5,
                )
            ),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Image.asset(
              'assets/globalmap.JPG',
              width: width/1.5,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_side/models/cooler.dart';
import 'package:doctor_side/models/doctor.dart';
import 'package:doctor_side/screens/appointment.dart';
import 'package:doctor_side/screens/signin.dart';
//import 'package:doctor_side/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'profile.dart';

final userRef = FirebaseFirestore.instance.collection('doctors');
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Doctor currentUser;
    getUser() async {
    final User doctor = auth.currentUser;
    final uid = doctor.uid;
    DocumentSnapshot doc = await userRef.doc(uid).get();
    return Doctor.fromDocument(doc);
  }

  void initState() {
    super.initState();
    getUser().then((val) {
      setState(() {
        currentUser = val;

      
      });
    });
  }

   FirebaseAuth _auth = FirebaseAuth.instance;
  Future signOut() async {
    try {
      return await _auth.signOut().then((value) => Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: SignIn(),
            ),
          ));
      // ignore: dead_code
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: HomePage(),
        ),
      );
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Doctor's Portal",
          style: TextStyle(
            color: greenish,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap:() {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ProfileInfo(currentUser),
                      ),
                    );
                    }, 
                   child: Container(
                        width: 150,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(
                                Icons.person,
                                color: greenish,
                                size: 50,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Profile',
                                style: TextStyle(color: greenish, fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: greenish,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.notifications,
                              color: greenish,
                              size: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Notifications',
                              style: TextStyle(color: greenish, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greenish,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap:() {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: MyAppointment(),
                      ),
                    );
                    },
                    
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.assignment,
                              color: greenish,
                              size: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Appointments',
                              style: TextStyle(color: greenish, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greenish,
                        ),
                      ),
                    ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.create,
                              color: greenish,
                              size: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Edit schedule',
                              style: TextStyle(color: greenish, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greenish,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 40),
                child: Center(
                  child: SizedBox(
                    width: 75,
                    height: 75,
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: () {
                        signOut();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            color: greenish,
                          ),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: greenish,
                                fontSize: 10.0),
                          ),
                        ],
                      ),
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(color: greenish),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

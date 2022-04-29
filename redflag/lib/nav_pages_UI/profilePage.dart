import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/registration_pages/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
  EmergencyContacts emergencyContactModel = EmergencyContacts();

  int? ecNum;

  @override
  void initState() {
    super.initState();

// to retrive the length of emergency contact based on the UID.
    FirebaseFirestore.instance
        .collection('emergencyContacts')
        .where('user', isEqualTo: user!.uid)
        .get()
        .then((value) {
      value.docs.length;
      print(value.docs.length);

      setState(() {
        ecNum = value.docs.length;
      });
    });

// to retrive the name and email of the user.
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = Users.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Stack(
            children: [
//------------------------------------ App Bar ----------------------------------------

              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 122, 122, 243),
                      Color(0xFF4E4EF7)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              ),

//------------------------------------ User info ----------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 120),
                child: Column(
                  children: [
                    //child 1 --> avatar
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    //child 2 --> for space between the avatar and user data
                    SizedBox(
                      height: 20,
                    ),
//----------------//child 3 --> user data
                    Column(
                      children: [
                        Text(
                          '${loggedInUser.getUserFirstName} ${loggedInUser.getUserLastName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          '${loggedInUser.getEmail}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

//------------------------------------Logout------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 300),
                child: TextButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: Text('Logout',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 245, 245, 245),
                      )),
                ),
              ),

//------------------------------------ Dispaly the number of Emergency Contacts for the user ----------------------------------------

              SizedBox(
                height: 50,
              ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 210,
                    ),

                    Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 22, bottom: 22),
                      // margin: EdgeInsets.only(left: 100),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // boxShadow: shadowList,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(170, 188, 188, 188)
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Text('$ecNum',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6666FF))),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text('Emergency \nContacts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),

                    SizedBox(
                      height: 40,
                    ),

//------------------------------------ Current Emergency Contacts List ----------------------------------------
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 35),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Current Emergency Contacts ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF4E4EF7),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    // View all emergency contacts in a listView
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 300.0,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('emergencyContacts')
                                  .where('user', isEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }
                                return ListView(
                                  key: Key(
                                      'currentEmergencyContactsList_profilePage'),
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;

                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 5, left: 30, right: 30),
                                      // padding: EdgeInsets.only(top: 20, bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6666FF),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    170, 201, 198, 198)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(data['eFullName'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),
                                        subtitle: Text(data['ecEmail'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),
                                        trailing: IconButton(
                                          key: Key('deleteButton'),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                          ),
                                          onPressed: () {
                                            deleteEmergencyContact(
                                                data['ecEmail']);
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//delete emergency contact
  Future<void> deleteEmergencyContact(String email) async {
    var collection = FirebaseFirestore.instance.collection('emergencyContacts');
    var snapshot = await collection
        .where('ecEmail', isEqualTo: email)
        .where('user', isEqualTo: user!.uid)
        .get();
    await snapshot.docs.first.reference.delete();
    Fluttertoast.showToast(msg: "Emergency contact deleted successfully :) ");
  }
}

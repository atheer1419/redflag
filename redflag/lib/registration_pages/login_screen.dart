import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redflag/registration_pages/registration_screen.dart';
import 'package:redflag/registration_pages/landing_screen.dart';
import '/nav_pages_UI/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  // ------------------------------ form key------------------------------
  final _formKey = GlobalKey<FormState>(); //for the validate

  //------------------------------ TextFields Controller (to get the user input)------------------------------
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //------------------------------ Firebase Auth------------------------------
  final _auth = FirebaseAuth.instance;

  //------------------------------ error messages------------------------------
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //------------------------------ email field------------------------------
    final emailField = TextFormField(
        key: Key('emailField_login'),
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        // Email Validation
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction:
            TextInputAction.next, //When press Tap will go to the next TextField
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //------------------------------ password field------------------------------
    final passwordField = TextFormField(
        key: Key('passwordField_login'),
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required to login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter a valid password (at least 6 characters)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //------------------------------ Login Button ------------------------------
    final loginButton = Material(
      key: Key('signInButton'),
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 108, 82, 255),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // This method will perform Firebase Email and Password Authintecation.
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "LOGIN",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //------------------------------ The Login page UI ------------------------------
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Color.fromARGB(255, 108, 82, 255)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LandingScreen()));
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/login_welcome.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 20),
                    Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    SizedBox(height: 35),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),

                    //------------------------------ REGISTER------------------------------
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),

                          // to know when the user clicks on it
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 108, 82, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------ Login Method ------------------------------
  // login function takes both email and password and will perform login using Firebase Auth
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      // if evreything the user enter is valid
      // ------------------------------ Login Auth ------------------------------
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  // Display the success mesg to the user

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("You've Logged in Successfully"),
                    backgroundColor: Colors.teal,
                    // Inner padding for SnackBar content.
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 30,
                    ),
                    margin: EdgeInsets.only(left: 40, right: 40),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => NavScreen())),
                  //****Note****
                  //pushReplacement() => we used it because we don’t want the user to go back to LoginScreen in any case.
                });
      }
      //------------------------------ Firebase login errors------------------------------
      on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }

        // Display the error mesg to the user
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}

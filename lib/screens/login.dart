import 'package:customer_service_app_flutter/components/rounded_button.dart';
import 'package:customer_service_app_flutter/constants.dart';
import 'package:customer_service_app_flutter/screens/employee.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Icon(
                    Icons.miscellaneous_services,
                    size: 200.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: textdecorationstyle.copyWith(
                      hintText: 'Enter your email')),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: textdecorationstyle.copyWith(
                    hintText: 'Enter your password'),
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (user != null) {
                    checkUserTypeAndNavigate(email);
                  }
                } catch (e) {
                  print('Wrong password provided for that user.');
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.id);
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkUserTypeAndNavigate(String email) async {
    final userDetailsCollection =
        FirebaseFirestore.instance.collection('userDetails');
    final employeeDetailsCollection =
        FirebaseFirestore.instance.collection('employeeDetails');

    try {
      final userDoc = await userDetailsCollection.doc(email).get();
      final employeeDoc = await employeeDetailsCollection.doc(email).get();

      if (userDoc.exists || employeeDoc.exists) {
        if (userDoc.exists) {
          Navigator.pushNamed(context, HomeScreen.id);
        } else {
          Navigator.pushNamed(context, HomeScreen.id);
        }
      } else {
        print('User not found in either collection.');
      }
    } catch (e) {
      print('Error checking user type: $e');
    }
  }
}

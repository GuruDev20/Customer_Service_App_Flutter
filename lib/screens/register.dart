import 'package:customer_service_app_flutter/components/rounded_button.dart';
import 'package:customer_service_app_flutter/constants.dart';
import 'package:customer_service_app_flutter/screens/userdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = "register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String email;
  late String password;
  late String confirmPassword;
  bool showPasswordMismatchDialog = false;
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
                  email = value;
                },
                decoration: textdecorationstyle.copyWith(hintText: 'Email'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: textdecorationstyle.copyWith(hintText: 'Password'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 350.0,
              child: TextField(
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration:
                    textdecorationstyle.copyWith(hintText: 'Confirm Password'),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Register',
              onPressed: () async {
                if (password != confirmPassword) {
                  setState(() {
                    showPasswordMismatchDialog = true;
                  });
                } else {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, UserDetails.id);
                    }
                  } catch (e) {
                    print("Error something went wrong");
                  }
                  //Navigator.pushNamed(context, HomeScreen.id);
                }
              },
            ),
            if (showPasswordMismatchDialog)
              AlertDialog(
                title: const Text("Password Mismatch"),
                content: const Text("The entered passwords do not match."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showPasswordMismatchDialog = false;
                      });
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

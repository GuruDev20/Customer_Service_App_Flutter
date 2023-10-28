import 'package:customer_service_app_flutter/components/rounded_button.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/login.dart';
import 'package:customer_service_app_flutter/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String id = "welcome_screen";

  @override
  Widget build(BuildContext context) {
    checkFirstTimeUser(context);

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
                    size: 120.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Customer Service',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              colour: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkFirstTimeUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is already logged in, navigate to HomeScreen
      Navigator.pushNamed(context, HomeScreen.id);
    } else {
      // User is not logged in, show WelcomeScreen
      await prefs.setBool('isLoggedIn', true);
    }
  }
}

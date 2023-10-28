import 'package:customer_service_app_flutter/components/rounded_button.dart';
import 'package:customer_service_app_flutter/screens/login.dart';
import 'package:customer_service_app_flutter/screens/register.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String id = "welcome_screen";
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
}

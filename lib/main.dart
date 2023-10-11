import 'package:customer_service_app_flutter/payment/cashOndelivery.dart';
import 'package:customer_service_app_flutter/payment/online.dart';
import 'package:customer_service_app_flutter/screens/edit_screen.dart';
import 'package:customer_service_app_flutter/screens/employee.dart';
import 'package:customer_service_app_flutter/screens/feedback_screen.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/location_screen.dart';
import 'package:customer_service_app_flutter/screens/login.dart';
import 'package:customer_service_app_flutter/screens/notification_screen.dart';
import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:customer_service_app_flutter/payment/payment.dart';
import 'package:customer_service_app_flutter/screens/process.dart';
import 'package:customer_service_app_flutter/screens/register.dart';
import 'package:customer_service_app_flutter/screens/service.dart';
import 'package:customer_service_app_flutter/screens/settings.dart';
import 'package:customer_service_app_flutter/screens/userdetails.dart';
import 'package:customer_service_app_flutter/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 16, 21, 49),
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 11, 28),
      ),
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id:(context)=>const WelcomeScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        RegisterScreen.id:(context) => const RegisterScreen(),
        HomeScreen.id:(context) =>const  HomeScreen(),
        SettingScreen.id:(context) => const SettingScreen(),
        EditScreen.id:(context) => const EditScreen(),
        LocationScreen.id:(context) => const LocationScreen(),
        NotificationsScreen.id:(context) =>const NotificationsScreen(),
        FeedbackScreen.id:(context) => const FeedbackScreen(),
        Orders.id:(context) =>Orders(username: '', mobileNumber: '', paymentMethod: '',),
        UserDetails.id:(context) => const UserDetails(),
        Employer.id:(context) => const Employer(),
        ServicesScreen.id:(context) => const ServicesScreen(),
        ProcessScreen.id:(context) => ProcessScreen(text: '',),
        PaymentScreen.id:(context)=> PaymentScreen(username: '', mobileNumber: '',),
        CashOnDeliveryScreen.id:(context)=> CashOnDeliveryScreen(username: '', mobileNumber:''),
        OnlinePaymentScreen.id:(context)=> OnlinePaymentScreen(username: '', mobileNumber:''),
        
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:customer_service_app_flutter/screens/process.dart';
import 'package:customer_service_app_flutter/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
enum UserType { Consumer, Employee }
class ServicesScreen extends StatefulWidget {
  static const String id = "ServicesScreen";
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String? loggedInUsername;
  UserType? userType;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(email)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          loggedInUsername = userSnapshot['Username'];
          String userTypeString = userSnapshot['Type'];
          userType = userTypeString == 'consumer'
              ? UserType.Consumer
              : UserType.Employee;
        });
      } else {
        print('User document does not exist');
      }
    } else {
      print('No user is logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 11, 28),
        leading: Icon(
          Icons.miscellaneous_services,
          size: 35.0,
          color: Colors.white,
        ),
        title: Text(
          'Customer Service',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Color.fromARGB(255, 246, 97, 147),
                height: 12.0,
                thickness: 4.0,
              ),
              Services(
                  icon: Icons.room_service_rounded,
                  text: 'Cook',
                  colour: Colors.redAccent),
              Services(
                  icon: Icons.medical_services,
                  text: 'Medial services',
                  colour: Colors.lightGreenAccent),
              Services(
                  icon: Icons.wash,
                  text: 'Washing',
                  colour: Colors.orangeAccent),
              Services(
                  icon: Icons.plumbing,
                  text: 'Plumber',
                  colour: Colors.pinkAccent),
              Services(
                  icon: Icons.water_drop,
                  text: 'Water Service',
                  colour: Colors.blue),
              Services(
                  icon: Icons.carpenter,
                  text: 'Wood Works',
                  colour: Colors.brown),
              Services(
                  icon: Icons.electrical_services,
                  text: 'Electric Works',
                  colour: Colors.grey),
              Services(
                  icon: Icons.grass, text: 'Gardening', colour: Colors.green),
              Services(
                  icon: Icons.person_add_alt_1,
                  text: 'CareTaker',
                  colour: Colors.cyanAccent),
              Services(
                  icon: Icons.drive_eta_rounded,
                  text: 'Driver',
                  colour: const Color.fromARGB(95, 214, 211, 211)),
              Services(
                  icon: Icons.bedroom_baby,
                  text: 'Babysitter',
                  colour: Colors.pink),
              Services(
                  icon: Icons.construction,
                  text: 'Construction',
                  colour: Colors.blueGrey),
              Services(
                  icon: Icons.cleaning_services_rounded,
                  text: 'Cleaning',
                  colour: Colors.lightBlueAccent),
              Services(
                  icon: Icons.pets, text: 'Animal Care', colour: Colors.amber),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 9, 11, 28),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          if (userType == UserType.Employee) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Orders(username: '', mobileNumber: '', paymentMethod: '', serviceName: '',)),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
                break;
            }
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServicesScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
                break;
            }
          }
        },
        items: userType == UserType.Employee
            ? [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: 'Settings',
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Colors.white),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: 'Settings',
                ),
              ],
        selectedItemColor: Colors.white,
      ),
    );
  }
}

class Services extends StatelessWidget {
  Services({required this.icon, required this.text, required this.colour});
  final IconData icon;
  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        height: 130.0,
        width: double.infinity,
        child: Card(
          color: Color.fromARGB(255, 15, 17, 42),
          elevation: 10.0,
          shadowColor: Color.fromARGB(255, 246, 97, 147),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(icon, size: 90, color: colour),
                    SizedBox(width: 8.0),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProcessScreen(text: text, ),
          ),
        );
      },
    );
  }
}

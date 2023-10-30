import 'package:customer_service_app_flutter/screens/edit_screen.dart';
import 'package:customer_service_app_flutter/screens/feedback_screen.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/login.dart';
import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:customer_service_app_flutter/screens/orders.dart';
import 'package:customer_service_app_flutter/screens/register.dart';
import 'package:customer_service_app_flutter/screens/service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { Consumer, Employee }

class SettingScreen extends StatefulWidget {
  static const String id = "setting_screen";
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? loggedInUsername;
  String? loggedInEmail;
  String? loggedInPhone;
  UserType? userType;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(email)
            .get();

        if (userSnapshot.exists) {
          var userDetails = userSnapshot.data() as Map<String, dynamic>;
          setState(() {
            loggedInUsername = userDetails['Username'];
            loggedInEmail = email;
            loggedInPhone = userDetails['Mobile Number'];
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
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 11, 28),
        elevation: 5.0,
        toolbarHeight: 80.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
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
                color: Colors.white,
                height: 12.0,
                thickness: 4.0,
              ),
              Card(
                elevation: 2.0,
                margin: const EdgeInsets.all(8.0),
                color: const Color.fromARGB(255, 208, 208, 208),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: const Color.fromARGB(255, 52, 53, 53),
                        child: Text(
                          loggedInUsername != null
                              ? loggedInUsername![0].toUpperCase()
                              : '',
                          style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username: $loggedInUsername',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                          Text(
                            'Email: $loggedInEmail',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                          Text(
                            'Phone: $loggedInPhone',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 20.0, left: 5.0, right: 5.0, bottom: 5.0),
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Options(
                  icon: Icons.edit,
                  text: 'Edit',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, EditScreen.id);
                  }),
              const Divider(
                height: 6.0,
                color: Colors.white,
              ),
              Options(
                  icon: Icons.notifications_active,
                  text: 'My Orders',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, MyOrders.id);
                  }),
              const Divider(
                height: 6.0,
                color: Colors.white,
              ),
              Options(
                  icon: Icons.feedback,
                  text: 'Feedback',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, FeedbackScreen.id);
                  }),
              const Divider(
                height: 6.0,
                color: Colors.white,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    top: 22.0, left: 5.0, right: 5.0, bottom: 5.0),
                child: Text(
                  'Account Options',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Options(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
              ),
              Options(
                icon: Icons.person_add_alt,
                text: 'Add Another Account',
                onTap: () {
                  Navigator.pushReplacementNamed(context, RegisterScreen.id);
                },
              ),
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
                  MaterialPageRoute(
                      builder: (context) => Orders(
                          )),
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

class Options extends StatelessWidget {
  const Options({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(12.0),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

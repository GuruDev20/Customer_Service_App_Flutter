import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_service_app_flutter/screens/home.dart';
import 'package:customer_service_app_flutter/screens/service.dart';
import 'package:customer_service_app_flutter/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum UserType { Consumer, Employee }

class Orders extends StatefulWidget {
  static const String id = "Orderscreen";
  final String username;
  final String mobileNumber;
  final String paymentMethod;
  final String serviceName;
  Orders({
    required this.username,
    required this.mobileNumber,
    required this.paymentMethod,
    required this. serviceName,
  });

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String? loggedInUsername;
  UserType? userType;
  int _currentIndex = 1; // Set the initial index to 1 for "Orders."

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
        title: Text('Order Summary'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary:'),
            Text('Username: ${widget.username}'),
            Text('Mobile Number: ${widget.mobileNumber}'),
            Text('Payment Method: ${widget.paymentMethod}'),
            // Implement the order summary and place order logic here
          ],
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

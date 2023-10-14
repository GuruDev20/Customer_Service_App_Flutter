import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:customer_service_app_flutter/screens/service.dart';
import 'package:customer_service_app_flutter/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserType { Consumer, Employee }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? loggedInUsername;
  String? loggedInEmail;
  String? loggedInMobileNumber;
  GoogleMapController? _controller;
  LatLng? userLatLng;
  UserType? userType;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUser();
    requestLocationPermission();
  }

  void showUserDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 9, 11, 28),
          content: Container(
            height: 100,
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Username: $loggedInUsername',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email: $loggedInEmail',
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Mobile Number: $loggedInMobileNumber',
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;

      // Check in employeeDetails collection
      DocumentSnapshot employeeSnapshot = await FirebaseFirestore.instance
          .collection('employeeDetails')
          .doc(email)
          .get();

      // Check in userDetails collection if not found in employeeDetails
      if (!employeeSnapshot.exists) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(email)
            .get();

        if (userSnapshot.exists) {
          var userDetails = userSnapshot.data() as Map<String, dynamic>;
          setState(() {
            loggedInUsername = userDetails['Username'];
            loggedInEmail = email;
            loggedInMobileNumber = userDetails['Mobile Number'];
            String userTypeString = userDetails['Type'];
            userType = userTypeString == 'consumer'
                ? UserType.Consumer
                : UserType.Employee;
          });
        } else {
          print('User document does not exist');
        }
      } else {
        // User is an employee
        var employeeDetails = employeeSnapshot.data() as Map<String, dynamic>;
        setState(() {
          loggedInUsername = employeeDetails['Username'];
          loggedInEmail = email;
          // You can add more employee-specific details if needed
          // loggedInMobileNumber = employeeDetails['Mobile Number'];
          userType = UserType.Employee;
        });
      }
    } else {
      print('No user is logged in.');
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    if (status == LocationPermission.denied) {
      print('Location permissions denied.');
    } else if (status == LocationPermission.deniedForever) {
      print('Location permissions permanently denied.');
    } else if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      getUserLocation();
    }
  }

  Future<void> getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLatLng = LatLng(position.latitude, position.longitude);
      });
      if (_controller != null) {
        _controller!.animateCamera(
          CameraUpdate.newLatLngZoom(userLatLng!, 15.0),
        );
      }
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                showUserDetails();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 133, 130, 130),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(
                    loggedInUsername != null && loggedInUsername!.isNotEmpty
                        ? loggedInUsername![0].toUpperCase()
                        : '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLatLng ?? LatLng(0, 0),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: userLatLng != null
            ? {
                Marker(
                  markerId: MarkerId('user_location'),
                  position: userLatLng!,
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(title: 'User Location'),
                ),
              }
            : {},
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
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Orders()),
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

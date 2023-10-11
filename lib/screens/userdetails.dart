import 'package:customer_service_app_flutter/components/rounded_button.dart';
import 'package:customer_service_app_flutter/screens/login.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);
  static const String id = "user_details";

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late String username;
  late String number;
  late String location;
  String? type;
  String? profession;
  double? latitude;
  double? longitude;

  TextEditingController usernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    numberController = TextEditingController();
    locationController = TextEditingController();
    professionController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    numberController.dispose();
    locationController.dispose();
    professionController.dispose();
    super.dispose();
  }

  Future<void> fetchLocationCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      print("Error fetching location coordinates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Icon(
                        Icons.miscellaneous_services,
                        size: 200.0,
                        color: Colors.white,
                      ),
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
                    username = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: 350.0,
                child: TextField(
                  onChanged: (value) {
                    number = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: 350.0,
                child: TextField(
                  onChanged: (value) {
                    location = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Current Location',
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: SizedBox(
                  width: 350.0,
                  child: DropdownButtonFormField<String>(
                    value: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
                        if (value == 'consumer') {
                          professionController.clear();
                          profession = null;
                        }
                      });
                    },
                    items: <String>['employee', 'consumer']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: 'Type',
                    ),
                  ),
                ),
              ),
              if (type == 'employee') ...[
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: 350.0,
                  child: TextField(
                    onChanged: (value) {
                      profession = value;
                    },
                    controller: professionController,
                    decoration: InputDecoration(
                      hintText: 'Profession',
                    ),
                  ),
                ),
              ],
              const SizedBox(
                height: 20.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Save & Continue',
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  String? userEmail = user?.email;
                  if (username.isNotEmpty &&
                      number.isNotEmpty &&
                      location.isNotEmpty &&
                      type != null) {
                    await fetchLocationCoordinates();

                    Map<String, dynamic> userData = {
                      'Username': username,
                      'Mobile Number': number,
                      'Location': location,
                      'latitude': latitude,
                      'longitude': longitude,
                      'profession': profession,
                      'Type': type,
                    };

                    String collectionName =
                        type == 'employee' ? 'employeeDetails' : 'userDetails';

                    await FirebaseFirestore.instance
                        .collection(collectionName)
                        .doc(userEmail)
                        .set(userData);
                    usernameController.clear();
                    numberController.clear();
                    locationController.clear();
                    Navigator.pushNamed(context, LoginScreen.id);
                  } else {
                    print('Please fill in all fields');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

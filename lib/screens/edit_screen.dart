import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_service_app_flutter/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const String id = "edit-screen";
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String? loggedInUsername;
  String? loggedInEmail;
  String? loggedInPhone;
  String? loggedInLocation;
  bool isEditing = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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
            loggedInLocation = userDetails['Location'];
            usernameController.text = loggedInUsername!;
            phoneController.text = loggedInPhone!;
            locationController.text = loggedInLocation!;
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

  void toggleEditingMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void saveChanges() async {
    String newUsername = usernameController.text;
    String newLocation = locationController.text;
    String newMobileNumber = phoneController.text;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        await FirebaseFirestore.instance
            .collection('userDetails')
            .doc(email)
            .update({
          'Username': newUsername,
          'Location': newLocation,
          'Mobile Number': newMobileNumber,
        });

        setState(() {
          loggedInUsername = newUsername;
          loggedInLocation = newLocation;
          loggedInPhone = newMobileNumber;
          isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Changes saved successfully')),
        );
      } else {
        print('No user is logged in.');
      }
    } catch (error) {
      print('Error saving user details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 11, 28),
        elevation: 5.0,
        toolbarHeight: 80.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context,SettingScreen.id);
          },
        ),
        title: const Text(
          'Edit User Profile',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Divider(
                color: Color.fromARGB(255, 246, 97, 147),
                height: 12.0,
                thickness: 4.0,
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: const Color.fromARGB(255, 52, 53, 53),
                  child: Text(
                    loggedInUsername != null
                        ? loggedInUsername![0].toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    TextFormField(
                      controller: locationController,
                      enabled: isEditing,
                      decoration:const InputDecoration(
                        labelText: 'Location',
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      enabled: isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: isEditing ? saveChanges : toggleEditingMode,
                      child: Text(isEditing ? 'Save' : 'Edit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

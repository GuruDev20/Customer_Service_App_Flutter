import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  static const String id = "FeedbackScreen";

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addFeedback() async {
    String serviceName = serviceNameController.text;
    String feedback = feedbackController.text;
    User? user = _auth.currentUser;
    if (user != null &&
        user.email != null &&
        serviceName.isNotEmpty &&
        feedback.isNotEmpty) {
      await _firestore.collection('feedback').add({
        'userEmail': user.email,
        'serviceName': serviceName,
        'feedback': feedback,
      });
      serviceNameController.clear();
      feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF090B1C),
        leading: Icon(
          Icons.miscellaneous_services,
          size: 35.0,
          color: Colors.white,
        ),
        title: Text(
          'Feedback',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('feedback').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            List<Widget> feedbackWidgets = [];
            final feedbackList = snapshot.data!.docs;
            for (var feedback in feedbackList) {
              Map<String, dynamic> feedbackData =
                  feedback.data() as Map<String, dynamic>;
              String serviceName = feedbackData['serviceName'];
              String feedbackText = feedbackData['feedback'];
              feedbackWidgets.add(
                Container(
                  height: 120,
                  child: Card(
                    shadowColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 10,
                    color: Color.fromARGB(255, 44, 46, 78),
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          'Service Name: $serviceName',
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Feedback: $feedbackText',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Column(children: feedbackWidgets);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 44, 46, 78),
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF090B1C),
                title: Text('Submit Feedback'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: serviceNameController,
                      decoration: InputDecoration(labelText: 'Service Name'),
                    ),
                    TextField(
                      controller: feedbackController,
                      decoration: InputDecoration(labelText: 'Feedback'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      addFeedback();
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 44, 46, 78),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

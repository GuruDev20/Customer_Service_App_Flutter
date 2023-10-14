import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders extends StatefulWidget {
  static const String id = "Orderscreen";

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          'Orders',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("Not logged in"),
            );
          } else {
            User? user = snapshot.data;
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('orders')
                  .where('email', isEqualTo: user!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<QueryDocumentSnapshot> orderDocuments =
                    snapshot.data!.docs;
                return ListView.builder(
                  itemCount: orderDocuments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> orderData =
                        orderDocuments[index].data() as Map<String, dynamic>;
                    // Display serviceName and location fields
                    return ListTile(
                      title: Text(orderData['serviceName']),
                      subtitle: Text('Location: ${orderData['userLocation']}'),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

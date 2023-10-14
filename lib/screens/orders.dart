import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrders extends StatefulWidget {
  static const String id = "myOrders";

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _currentUser = _auth.currentUser;
    });
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
          'My Orders',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                color: Color.fromARGB(255, 246, 97, 147),
                height: 12.0,
                thickness: 4.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(
                      top: 15.0, left: 10.0, right: 5.0, bottom: 5.0),
                  child: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
              _currentUser != null
                  ? _buildOrderList()
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return StreamBuilder(
      stream:
          _firestore.collection('orders').doc(_currentUser!.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No Data Available');
        }

        final orderData = snapshot.data!.data() as Map<String, dynamic>;
        if (orderData == null) {
          return Text('Order data is null');
        }

        return Container(
          height: 150,
          child: Card(
            shadowColor: Colors.pink,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            color: Color(0xFF0F112A),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: ListTile(
                title: Text(
                  orderData['serviceName'],
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username: ${orderData['username']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Mobile Number: ${orderData['mobileNumber']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Divider(
                        color: Colors.pinkAccent,
                        thickness: 1,
                        endIndent: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

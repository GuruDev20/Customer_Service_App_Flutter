import 'package:customer_service_app_flutter/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CashOnDeliveryScreen extends StatefulWidget {
  static const String id = "CashOnDeliveryScreen";
  final String username;
  final String mobileNumber;
  final String serviceName;

  CashOnDeliveryScreen({
    required this.username,
    required this.mobileNumber,
    required this.serviceName,
  });

  @override
  _CashOnDeliveryScreenState createState() => _CashOnDeliveryScreenState();
}

class _CashOnDeliveryScreenState extends State<CashOnDeliveryScreen> {
  int rating = 0;
  void updateRating(int newRating) {
    setState(() {
      rating = newRating;
    });
  }

  Future<void> submitRating(int userRating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final employeeEmail = widget.username;

      final ratingsCollection =
          FirebaseFirestore.instance.collection('ratings');
      Map<String, dynamic> ratingData = {
        'userEmail': user.email,
        'ratingValue': userRating,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await ratingsCollection.doc(employeeEmail).set(ratingData);

      Navigator.of(context).pop();
    }
  }

  void _placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ordersCollection = FirebaseFirestore.instance.collection('orders');
      final documentName = user.email;
      Map<String, dynamic> orderData = {
        'username': widget.username,
        'mobileNumber': widget.mobileNumber,
        'serviceName': widget.serviceName,
        'paymentMethod': 'Cash on Delivery',
        'timestamp': FieldValue.serverTimestamp(),
      };
      await ordersCollection.doc(documentName).set(orderData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully'),
        ),
      );

      directDelivery(context);
    }
  }

  void directDelivery(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF0F112A),
          title: Text(
            'Would you like to rate our Service?',
            style: TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showRatingDialog(context);
                    },
                    child: Text('Yes'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF1C1E42)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MyOrders.id);
                    },
                    child: Text('No'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF1C1E42)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showRatingDialog(BuildContext context) {
    int userRating = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color(0xFF0F112A),
              title: Text(
                'Rate our Service',
                style: TextStyle(fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starColor =
                          index < userRating ? Colors.yellow : Colors.grey;
                      return IconButton(
                        icon: Icon(Icons.star, color: starColor),
                        onPressed: () {
                          setState(() {
                            userRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitRating(userRating);
                    },
                    child: Text('Submit'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF1C1E42)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          'Payment',
          style: TextStyle(fontSize: 25.0),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shadowColor: Colors.pink,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xFF0F112A),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Username: ${widget.username}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Mobile Number: ${widget.mobileNumber}',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Service Name: ${widget.serviceName}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _placeOrder(context);
                            },
                            child: Text('Place Order'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF1C1E42)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Icon(
              Icons.miscellaneous_services,
              size: 160,
            ),
          )
        ],
      ),
    );
  }
}

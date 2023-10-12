import 'package:customer_service_app_flutter/screens/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CashOnDeliveryScreen extends StatelessWidget {
  static const String id = "CashOnDeliveryScreen";
  final String username;
  final String mobileNumber;
  final String serviceName;

  CashOnDeliveryScreen({
    required this.username,
    required this.mobileNumber,
    required this.serviceName,
  });

  void _placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ordersCollection = FirebaseFirestore.instance.collection('orders');
      final documentName = user.email;
      Map<String, dynamic> orderData = {
        'username': username,
        'mobileNumber': mobileNumber,
        'serviceName': serviceName,
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
          title: Text('Would you like to Call our service agent?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  callMobileNumber(context);
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, MyOrders.id);
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      },
    );
  }

  void callMobileNumber(BuildContext context) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: mobileNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('no url available');
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
                          'Username: $username',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Mobile Number: $mobileNumber',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Service Name: $serviceName',
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

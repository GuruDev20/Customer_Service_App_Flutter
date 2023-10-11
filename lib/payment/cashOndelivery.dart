import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:flutter/material.dart';

class CashOnDeliveryScreen extends StatelessWidget {
  static const String id = "CashOnDeliveryScreen";
  final String username;
  final String mobileNumber;
  final String serviceName;
  CashOnDeliveryScreen({required this.username, required this.mobileNumber,required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash on Delivery'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm Order Details:'),
            Text('Username: $username'),
            Text('Mobile Number: $mobileNumber'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Orders(
                      username: username,
                      mobileNumber: mobileNumber,
                      paymentMethod: 'Cash on Delivery',
                    ),
                  ),
                );
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

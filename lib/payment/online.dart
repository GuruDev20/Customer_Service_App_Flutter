import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:flutter/material.dart';

class OnlinePaymentScreen extends StatelessWidget {
  static const String id = "online_payment";
  final String username;
  final String mobileNumber;

  OnlinePaymentScreen({required this.username, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Make Online Payment:'),
            Text('Username: $username'),
            Text('Mobile Number: $mobileNumber'),
            // Implement the online payment logic here
            ElevatedButton(
              onPressed: () {
                // Implement online payment logic here
                // After successful payment, navigate to the OrderScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Orders(
                      username: username,
                      mobileNumber: mobileNumber,
                      paymentMethod: 'Online Payment',
                    ),
                  ),
                );
              },
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

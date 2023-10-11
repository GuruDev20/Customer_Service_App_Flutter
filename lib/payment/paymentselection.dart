import 'package:customer_service_app_flutter/payment/cashOndelivery.dart';
import 'package:customer_service_app_flutter/payment/online.dart';
import 'package:flutter/material.dart';

class PaymentSelectionScreen extends StatelessWidget {
  static const String id = "paymentSelectionScreen";
  final String username;
  final String mobileNumber;

  PaymentSelectionScreen({required this.username, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Selection'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a Payment Method:'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CashOnDeliveryScreen(
                      username: username,
                      mobileNumber: mobileNumber,
                    ),
                  ),
                );
              },
              child: Text('Cash on Delivery'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnlinePaymentScreen(
                      username: username,
                      mobileNumber: mobileNumber,
                    ),
                  ),
                );
              },
              child: Text('Online Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

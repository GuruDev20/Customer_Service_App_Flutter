import 'package:customer_service_app_flutter/payment/paymentselection.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = "PaymentScreen";
  final String username;
  final String mobileNumber;

  PaymentScreen({Key? key, required this.username, required this.mobileNumber})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 9, 11, 28),
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color.fromARGB(255, 15, 17, 42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: Colors.pink,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Username: ${widget.username}'),
                  ),
                  ListTile(
                    title: Text('Mobile Number: ${widget.mobileNumber}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentSelectionScreen(
                            username: widget.username,
                            mobileNumber: widget.mobileNumber,
                          ),
                        ),
                      );
                    },
                    child: Text('Continue'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

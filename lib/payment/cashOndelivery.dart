import 'package:customer_service_app_flutter/screens/order_screen.dart';
import 'package:flutter/material.dart';

class CashOnDeliveryScreen extends StatelessWidget {
  static const String id = "CashOnDeliveryScreen";
  final String username;
  final String mobileNumber;
  final String serviceName;
  CashOnDeliveryScreen(
      {required this.username,
      required this.mobileNumber,
      required this.serviceName});

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
      body: Container(
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Orders(
                              username: username,
                              mobileNumber: mobileNumber,
                              serviceName: serviceName,
                              paymentMethod: 'Cash on Delivery',
                            ),
                          ),
                        );
                      },
                      child: Text('Place Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1C1E42),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

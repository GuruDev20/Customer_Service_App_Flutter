import 'package:customer_service_app_flutter/payment/cashOndelivery.dart';
import 'package:customer_service_app_flutter/payment/online.dart';
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
  bool showPaymentSelection = false;

  void togglePaymentSelection() {
    setState(() {
      showPaymentSelection = !showPaymentSelection;
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
              color: Color(0xFF0F112A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Username: ${widget.username}'),
                    ),
                    ListTile(
                      title: Text('Mobile Number: ${widget.mobileNumber}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: 115,
                        child: ElevatedButton(
                          onPressed: () {
                            togglePaymentSelection();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1C1E42),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Continue'),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (showPaymentSelection)
              Card(
                color: Color(0xFF0F112A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Icon(
                          Icons.miscellaneous_services_outlined,
                          size: 120,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Select a Payment Method'),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CashOnDeliveryScreen(
                                      username: widget.username,
                                      mobileNumber: widget.mobileNumber,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Cash on Delivery'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1C1E42),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnlinePaymentScreen(
                                      username: widget.username,
                                      mobileNumber: widget.mobileNumber,
                                    ),
                                  ),
                                );
                              },
                              child: Text('Online Payment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1C1E42),
                              ),
                            ),
                          ],
                        ),
                      ),
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

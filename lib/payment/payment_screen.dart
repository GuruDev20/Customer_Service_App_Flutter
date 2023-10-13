import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_service_app_flutter/screens/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentOnlineScreen extends StatefulWidget {
  static const String id = "payment_online";
  PaymentOnlineScreen({required this.username});
  final String username;

  @override
  State<PaymentOnlineScreen> createState() => _PaymentOnlineScreenState();
}

class _PaymentOnlineScreenState extends State<PaymentOnlineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _amountController;
  late TextEditingController _mobileNumberController;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Successful. Payment ID: ${response.paymentId}');
    directDelivery(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyOrders()));
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    print(
        'Payment Failed. Code: ${response.code}, Message: ${response.message}');
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    print('Using External Wallet: ${response.walletName}');
  }

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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyOrders()));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 380,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Make a Payment",
                          style: TextStyle(fontSize: 21),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _amountController,
                            decoration:
                                InputDecoration(hintText: 'Enter amount'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the amount";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _mobileNumberController,
                            decoration: InputDecoration(
                                hintText: 'Employee Mobile Number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the employee's mobile number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var options = {
                                "key": "rzp_test_Wvq0QRJ790pi7K",
                                "amount":
                                    (num.parse(_amountController.text) * 100)
                                        .toInt(),
                                "name": "Projects",
                                "description": "Payment for the project",
                                "prefill": {
                                  "contact": _mobileNumberController.text,
                                  "email": "guru01803@gmail.com",
                                },
                                "external": {
                                  "wallets": ["paytm"]
                                },
                              };
                              try {
                                _razorpay.open(options);
                              } catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                          child: Text('Pay Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

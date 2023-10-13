import 'package:customer_service_app_flutter/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentOnlineScreen extends StatefulWidget {
  const PaymentOnlineScreen({Key? key}) : super(key: key);

  @override
  State<PaymentOnlineScreen> createState() => _PaymentOnlineScreenState();
}

class _PaymentOnlineScreenState extends State<PaymentOnlineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TextEditingController _amountController;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
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
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Make a Payment",
                          style: TextStyle(fontSize: 21),
                        ),
                        const SizedBox(
                          height: 40,
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
                                  "contact": "7904093855",
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

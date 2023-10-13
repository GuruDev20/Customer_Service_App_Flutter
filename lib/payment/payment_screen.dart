import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class PaymentOnlineScreen extends StatefulWidget {
  const PaymentOnlineScreen({super.key});

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
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFaiure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void handlerPaymentSuccess() {
    print('payment successful');
  }

  void handlerErrorFaiure() {
    print('payment failed');
  }

  void handlerExternalWallet() {
    print('external wallet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
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
                          "Do Payment",
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
                              if (value != null && value.isEmpty) {
                                return "Please enter amount";
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
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              var options = {
                                "key": "rzp_test_Wvq0QRJ790pi7K",
                                "amount":
                                    num.parse(_amountController.text) * 100,
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
                            },
                            child: Text('Pay Now'))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
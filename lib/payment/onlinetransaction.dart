import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionScreen extends StatefulWidget {
  static const String id = "transaction";

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10.0,
            shadowColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Color(0xFF0F112A),
            child: Column(
              children: [
                PaymentOption(
                  icon: FontAwesomeIcons.google,
                  text: 'Google Pay',
                  onPressed: () {},
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                PaymentOption(
                  icon: FontAwesomeIcons.paypal,
                  text: 'Paytm',
                  onPressed: () {},
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                PaymentOption(
                  icon: FontAwesomeIcons.creditCard,
                  text: 'Credit/Debit card',
                  onPressed: () {},
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  PaymentOption({required this.icon, required this.text, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 25.0, bottom: 8.0),
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }
}

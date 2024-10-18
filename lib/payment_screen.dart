// payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Make sure to import the Stripe package
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatelessWidget {
  final double downpayment;

  const PaymentScreen({Key? key, required this.downpayment}) : super(key: key);

  Future<void> _processPayment(BuildContext context) async {
    try {
      final paymentIntentData = await _createPaymentIntent((downpayment * 100).toInt().toString(), 'php');

      if (paymentIntentData != null) {
        // Step 2: Initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['clientSecret'],
            merchantDisplayName: 'Your Merchant Name',
          ),
        );

        // Step 3: Display the payment sheet
        await Stripe.instance.presentPaymentSheet();

        // If payment is successful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.47/database/create-payment-intent.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent. Status code: ${response.statusCode}');
      }
    } catch (err) {
      print('Error creating payment intent: $err');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _processPayment(context),
          child: const Text('Pay Downpayment'),
        ),
      ),
    );
  }
}

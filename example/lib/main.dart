import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:platform_buttons_stripe/src/enums.dart';
import 'package:platform_buttons_stripe/src/platform_buttons_stripe.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Payment Integration Example')),
        body: PlatformButtonsStripe(
          paymentItems: const [
            PaymentItem(
              label: 'Test Item',
              amount: '10.00',
              status: PaymentItemStatus.final_price,
            ),
          ],
          amountInCents: '1000',
          // Amount in cents
          onComplete: () {
            log('Payment Complete');
          },
          onError: (error) {
            log('Payment Error: $error');
          },
          stripePublishableKey: 'your-publishable-key',
          stripeSecretKey: 'your-secret-key',
          environment: AppEnvironment.test,
          merchantId: 'your-merchant-id',
          merchantName: 'your-merchant-name',
        ),
      ),
    );
  }
}

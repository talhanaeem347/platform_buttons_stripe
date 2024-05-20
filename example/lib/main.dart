import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:platform_buttons_stripe/platform_buttons_stripe.dart';

void main() {
  PlatformButtonsStripe.init(
      stripePublishableKey:
          'pk_test_51PCLOlHyq5Ko4yU39KOsjiy04gLCU3JpyireVyFL48mw2SPNGuUNFLI6vV5AadD77ubhd7MCjJCjfr0qfx06FLtE003S5zZm4w',
      stripeSecretKey:
          'sk_test_51PCLOlHyq5Ko4yU3pb4ZaSMl3a0W0c9TSalcEIXrD6wrdOLNsKHRef871ztus0lQGfKqjCgliCyTpPffwpkjS08g00Vvcej6OU',
      merchantId: '01234567890123456789',
      merchantName: 'merchantName');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String amountInCents = '5000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amount in cents: $amountInCents'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  amountInCents = (int.parse(amountInCents) + 1000).toString();
                });
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: PlatformButtonsStripe(
          onError: (error) {
            log(error.toString());
          },
          onComplete: () {
            log('Payment completed');
          },
          amountInCents: amountInCents,
          paymentItems: const [
            PaymentItem(
              label: 'T-shirt',
              amount: '10.00',
              status: PaymentItemStatus.final_price,
              type: PaymentItemType.item,
            ),
          ],
          environment: AppEnvironment.test,
        ),
      ),
    );
  }
}

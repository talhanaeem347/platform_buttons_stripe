# platform buttons Stripe

A Flutter package for integrating Google Pay and Apple Pay with Stripe. This package provides customizable widgets to easily add payment buttons to your Flutter applications.

## Features

- Supports both Google Pay and Apple Pay.
- Handles payment processing with Stripe.
- Easily configurable for different environments (test and production).

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  platform_buttons_stripe:
    git:
      url: https://github.com/talhanaeem347/platform_buttons_stripe.git
      ref: main
```
- Run `flutter pub get` to install the package.


## Usage

```dart
import 'package:platform_buttons_stripe/platform_buttons_stripe.dart';
```

## Example

```dart
import 'dart:developer';
import 'package:flutter/material.dart';
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
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

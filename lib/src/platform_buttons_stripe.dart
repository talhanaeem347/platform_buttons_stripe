import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:platform_buttons_stripe/platform_buttons_stripe.dart';

class PlatformButtonsStripe extends StatelessWidget {
  final List<PaymentItem> paymentItems;
  final void Function() onComplete;
  final String amountInCents;
  final void Function(Object?) onError;
  final String stripePublishableKey;
  final String stripeSecretKey;
  final AppEnvironment environment;
  final String merchantId;
  final String merchantName;

  const PlatformButtonsStripe({
    super.key,
    required this.paymentItems,
    required this.onComplete,
    required this.amountInCents,
    required this.onError,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    this.environment = AppEnvironment.production,
    required this.merchantId,
    required this.merchantName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? GooglePayButtonStripe(
        merchantName: merchantName,
        merchantId: merchantId,
        stripeSecretKey: stripeSecretKey,
        amount: amountInCents,
        environment:
        environment == AppEnvironment.test ? 'TEST' : 'PRODUCTION',
        onComplete: onComplete,
        paymentItems: paymentItems,
        onError: onError,
        stripePublishableKey: stripePublishableKey,
      )
          : ApplePayButtonStripe(
        merchantName: merchantName,
        merchantId: merchantId,
        stripeSecretKey: stripeSecretKey,
        amount: amountInCents,
        onComplete: onComplete,
        paymentItems: paymentItems,
        onError: onError,
        stripePublishableKey: stripePublishableKey,
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:platform_buttons_stripe/platform_buttons_stripe.dart'; // Assuming this is a custom package or local implementation

class PlatformButtonsStripe extends StatelessWidget {
  final List<PaymentItem> paymentItems;
  final void Function() onComplete;
  final void Function()? onProcessing;
  final String amountInCents;
  final void Function(Object?) onError;
  final AppEnvironment environment;

  const PlatformButtonsStripe({
    super.key,
    required this.paymentItems,
    required this.onComplete,
    this.onProcessing,
    required this.amountInCents,
    required this.onError,
    this.environment = AppEnvironment.production,
  });

  static late final String _stripePublishableKey;
  static late final String _stripeSecretKey;
  static late final String _merchantId;
  static late final String _merchantName;

  static void init({
    required String stripePublishableKey,
    required String stripeSecretKey,
    required String merchantId,
    required String merchantName,
  }) {
    _stripePublishableKey = stripePublishableKey;
    _stripeSecretKey = stripeSecretKey;
    _merchantId = merchantId;
    _merchantName = merchantName;

    Stripe.publishableKey = _stripePublishableKey;
    Stripe.merchantIdentifier = _merchantId;
  }

  @override
  Widget build(BuildContext context) {
    log('amount in cents package: $amountInCents');
    return Platform.isAndroid
        ? GooglePayButtonStripe(
      merchantName: _merchantName,
      merchantId: _merchantId,
      stripeSecretKey: _stripeSecretKey,
      amount: amountInCents,
      environment: environment == AppEnvironment.test ? 'TEST' : 'PRODUCTION',
      onComplete: onComplete,
      paymentItems: paymentItems,
      onProcessing: onProcessing,
      onError: onError,
      stripePublishableKey: _stripePublishableKey,
    )
        : ApplePayButtonStripe(
      merchantName: _merchantName,
      merchantId: _merchantId,
      stripeSecretKey: _stripeSecretKey,
      amount: amountInCents,
      onComplete: onComplete,
      onProcessing: onProcessing,
      paymentItems: paymentItems,
      onError: onError,
      stripePublishableKey: _stripePublishableKey,
    );
  }
}

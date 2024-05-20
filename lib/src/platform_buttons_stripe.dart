import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:platform_buttons_stripe/platform_buttons_stripe.dart';

class PlatformButtonsStripe extends StatefulWidget {
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
  State<PlatformButtonsStripe> createState() => _PlatformButtonsStripeState();
}

class _PlatformButtonsStripeState extends State<PlatformButtonsStripe> {
  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = widget.stripePublishableKey;
    Stripe.merchantIdentifier = widget.merchantId;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? GooglePayButtonStripe(
            merchantName: widget.merchantName,
            merchantId: widget.merchantId,
            stripeSecretKey: widget.stripeSecretKey,
            amount: widget.amountInCents,
            environment: widget.environment == AppEnvironment.test
                ? 'TEST'
                : 'PRODUCTION',
            onComplete: widget.onComplete,
            paymentItems: widget.paymentItems,
            onError: widget.onError,
            stripePublishableKey: widget.stripePublishableKey,
          )
        : ApplePayButtonStripe(
            merchantName: widget.merchantName,
            merchantId: widget.merchantId,
            stripeSecretKey: widget.stripeSecretKey,
            amount: widget.amountInCents,
            onComplete: widget.onComplete,
            paymentItems: widget.paymentItems,
            onError: widget.onError,
            stripePublishableKey: widget.stripePublishableKey,
          );
  }
}

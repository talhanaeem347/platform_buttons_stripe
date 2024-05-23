import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';

class ApplePayButtonStripe extends StatefulWidget {
  final List<PaymentItem> paymentItems;
  final void Function() onComplete;
  final void Function()? onProcessing;
  final String amount;
  final void Function(Object?) onError;
  final String stripePublishableKey;
  final String stripeSecretKey;
  final String merchantId;
  final String merchantName;

  const ApplePayButtonStripe({
    super.key,
    required this.paymentItems,
    required this.onComplete,
    this.onProcessing,
    required this.amount,
    required this.onError,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    required this.merchantId,
    required this.merchantName,
  });

  @override
  State<ApplePayButtonStripe> createState() => _ApplePayButtonStripeState();
}

class _ApplePayButtonStripeState extends State<ApplePayButtonStripe> {
  @override
  Widget build(BuildContext context) {
    return ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        _paymentProfile(),
      ),
      paymentItems: widget.paymentItems,
      margin: const EdgeInsets.only(top: 15),
      onPaymentResult: onApplePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      childOnError: const Text('Apple Pay is not available in this device'),
      onError: (e) {},
    );
  }

  Future<void> onApplePayResult(paymentResult) async {
    try {
      final token = await Stripe.instance.createApplePayToken(paymentResult);
      widget.onProcessing?.call();

      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['client_secret'];

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: token.id,
        ),
      );

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );
      widget.onComplete();
    } catch (e) {
      widget.onError(e);
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final Map<String, dynamic> requestData = {
      'amount': widget.amount,
      'currency': 'usd',
    };
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.stripeSecretKey}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: requestData,
    );
    return json.decode(response.body);
  }

  String _paymentProfile() {
    return """{
      "provider": "apple_pay",
      "data": {
        "merchantIdentifier": "${widget.merchantId}",
        "displayName": "${widget.merchantName}",
        "merchantCapabilities": ["3DS"],
        "allowedPaymentMethods": [
          {
            "type": "CARD",
            "tokenizationSpecification": {
              "type": "PAYMENT_GATEWAY",
              "parameters": {
                "gateway": "stripe",
                "stripe:version": "2020-08-27",
                "stripe:publishableKey": "${widget.stripePublishableKey}"
              }
            },
            "parameters": {
              "allowedCardNetworks": ["VISA", "MASTERCARD"],
              "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
              "billingAddressRequired": false,
              "billingAddressParameters": {
                "format": "FULL",
                "phoneNumberRequired": false
              }
            }
          }
        ],
        "supportedNetworks": [
          "amex",
          "visa",
          "discover",
          "masterCard"
        ],
        "countryCode": "US",
        "currencyCode": "USD",      
      }
    }""";
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';

class GooglePayButtonStripe extends StatefulWidget {
  final List<PaymentItem> paymentItems;
  final void Function() onComplete;
  final void Function()? onProcessing;
  final String amount;
  final void Function(Object?) onError;
  final String stripePublishableKey;
  final String stripeSecretKey;
  final String environment;
  final String merchantId;
  final String merchantName;
  final String customerId;

  const GooglePayButtonStripe({
    super.key,
    required this.paymentItems,
    required this.onComplete,
    this.onProcessing,
    required this.amount,
    required this.onError,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    required this.environment,
    required this.merchantId,
    required this.merchantName,
    required this.customerId,
  });

  @override
  State<GooglePayButtonStripe> createState() => _GooglePayButtonStripeState();
}

class _GooglePayButtonStripeState extends State<GooglePayButtonStripe> {
  @override
  Widget build(BuildContext context) {
    return GooglePayButton(
        paymentConfiguration:
            PaymentConfiguration.fromJsonString(_googlePayStripeConfig()),
        onPaymentResult: onGooglePayResult,
        paymentItems: widget.paymentItems,
        onPressed: () {},
        loadingIndicator: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        childOnError: const Text('Google pay is not available on this device'),
        onError: widget.onError);
  }

  Future<void> onGooglePayResult(Map<String, dynamic> paymentResult) async {
    try {
      widget.onProcessing?.call();
      Map<String, dynamic> response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['client_secret'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: tokenJson['id'],
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
    http.Response? response;
    try {
      Map<String, dynamic> body = {
        'currency': 'USD',
        'amount': widget.amount,
        'payment_method_types[]': 'card',
        'customer': widget.customerId,
      };

      response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${widget.stripeSecretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
    } catch (e) {
      widget.onError(e);
    }
    return jsonDecode(response!.body.toString());
  }

  String _googlePayStripeConfig() {
    return """{
    "provider": "google_pay",
    "data": {
      "environment": "${widget.environment}",
      "apiVersion": 2,
      "apiVersionMinor": 0,
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
      "merchantInfo": {
        "merchantId": "${widget.merchantId}",
        "merchantName": "${widget.merchantName}"
      },
      "transactionInfo": {
        "countryCode": "US",
        "currencyCode": "USD"
      }
    }
  }""";
  }
}

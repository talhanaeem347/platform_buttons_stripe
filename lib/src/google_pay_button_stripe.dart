import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';

class GooglePayButtonStripe extends StatelessWidget {
  final List<PaymentItem> paymentItems;
  final void Function() onComplete;
  final String amount;
  final void Function(Object?) onError;
  final String stripePublishableKey;
  final String stripeSecretKey;
  final String environment;
  final String merchantId;
  final String merchantName;

  const GooglePayButtonStripe({
    super.key,
    required this.paymentItems,
    required this.onComplete,
    required this.amount,
    required this.onError,
    required this.stripePublishableKey,
    required this.stripeSecretKey,
    required this.environment,
    required this.merchantId,
    required this.merchantName,
  });

  @override
  Widget build(BuildContext context) {
    return GooglePayButton(
        paymentConfiguration:
        PaymentConfiguration.fromJsonString(_googlePayStripeConfig()),
        onPaymentResult: onGooglePayResult,
        paymentItems: paymentItems,
        onPressed: () {},
        loadingIndicator: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        childOnError: const Text('Google pay is not available on this device'),
        onError: onError);
  }

  Future<void> onGooglePayResult(Map<String, dynamic> paymentResult) async {
    try {
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
     onComplete();
    } catch (e) {
      onError(e);
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    http.Response? response;
    try {
      Map<String, dynamic> body = {
        'currency': 'USD',
        'amount': amount,
        'payment_method_types[]': 'card'
      };

      response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
    } catch (e) {
      onError(e);
    }
    return jsonDecode(response!.body.toString());
  }

  String _googlePayStripeConfig() {
    return """{
    "provider": "google_pay",
    "data": {
      "environment": "$environment",
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
              "stripe:publishableKey": "$stripePublishableKey"
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
        "merchantId": "$merchantId",
        "merchantName": "$merchantName"
      },
      "transactionInfo": {
        "countryCode": "US",
        "currencyCode": "USD"
      }
    }
  }""";
  }
}

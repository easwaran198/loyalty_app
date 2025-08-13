import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/customer_container.dart';
import 'package:loyalty_app/data/api_service.dart';
import 'package:loyalty_app/splash/custom_text.dart';

class ScannedDetailsScreen extends StatefulWidget {
  const ScannedDetailsScreen({super.key});

  @override
  State<ScannedDetailsScreen> createState() => _ScannedDetailsScreenState();
}

class _ScannedDetailsScreenState extends State<ScannedDetailsScreen> {
  Map<String, dynamic>? details;
  bool isLoading = true;
  late String scannedData;
  bool _isInitialized = false; // to ensure it runs only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      scannedData = ModalRoute.of(context)?.settings.arguments as String;
      _fetchDetails();
      _isInitialized = true;
    }
  }

  Future<void> _fetchDetails() async {
    final api = ApiService();
    final data = await api.scanDetails(scannedData);
    setState(() {
      details = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (details == null || details!["success"] != "true") {
      return Scaffold(
        body: Center(
          child: CustomButton(
            text: details?["message"] ?? "Something went wrong",
            horizontalvalue: 50,
            fontSize: 18,
            backgroundColor: redcolor,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            prefixIcon: Icons.arrow_back_ios,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: const Color(0xffFF0000),
              height: 100,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  HeadingText(
                    text: "Coupon details",
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffFFCD2A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Column(
                children: [
                  HeadingText(
                    text: "Coupon no : $scannedData",
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  Image.asset("assets/images/qr_image.png"),
                ],
              ),
            ),
            KeyValueContainer(
              label: "Invoice Number",
              value: details!["invoice_no"] ?? "",
              backgroundColor: Colors.white,
              textColor1: Colors.black,
              textColor2: Colors.orange,
              borderRadius: 30,
            ),
            KeyValueContainer(
              label: "Serial Number",
              value: details!["serial_no"] ?? "",
              backgroundColor: Colors.white,
              textColor1: Colors.black,
              textColor2: Colors.blue,
              borderRadius: 30,
            ),
            KeyValueContainer(
              label: "Offer amount",
              value: "${details!["offer_amount"]} ₹",
              backgroundColor: Colors.white,
              textColor1: Colors.black,
              textColor2: Colors.green,
              borderRadius: 30,
            ),
            KeyValueContainer(
              label: "Unique id",
              value: details!["unique_id"] ?? "",
              backgroundColor: Colors.white,
              textColor1: Colors.black,
              textColor2: Colors.red,
              borderRadius: 30,
            ),
            const SizedBox(height: 10),
            Image.asset("assets/images/seperator_image.png"),
            const SizedBox(height: 10),
            CustomButton(
              text: "Redeem Later",
              horizontalvalue: 80,
              backgroundColor: lightRed,
              textColor: Colors.black,
              fontSize: 16,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Redeem",
              horizontalvalue: 90,
              prefixImage: "assets/images/non_open_gift.png",
              backgroundColor: redcolor,
              textColor: Colors.white,
              fontSize: 16,
              onPressed: () async {
                final api = ApiService();
                final couponId = details!["coupon_id"] ?? "2";
                final result = await api.redeemCoupon(couponId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result["message"] ??
                        (result["success"] == "true"
                            ? "Redeemed successfully"
                            : "Redeem failed")),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}


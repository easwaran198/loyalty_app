import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_container_without_background.dart';
import 'package:loyalty_app/constants/custom_date_header.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import 'package:loyalty_app/data/api_service.dart';

class RedeemedListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RedeemedListState();
}

class _RedeemedListState extends State<RedeemedListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _redeemedListFuture;

  @override
  void initState() {
    super.initState();
    _redeemedListFuture = _apiService.getRedeemedList();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<dynamic>>(
          future: _redeemedListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    text: "${snapshot.error}\n-click here and go back",
                    prefixIcon: Icons.arrow_circle_left,
                    horizontalvalue: 50,
                    fontSize: 16,
                    backgroundColor: redcolor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No redeemed coupons found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            final redeemedList = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: const Color(0xffFF0000),
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        HeadingText(
                          text: "Redeemed List",
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ],
                    ),
                  ),
                  // Build each item separately to avoid nesting issues
                  for (var item in redeemedList)
                    _buildRedeemedItem(context, item, screenWidth),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRedeemedItem(BuildContext context, dynamic item, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDateHeader(text: item["scan_date"] ?? "Unknown Date"),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.35,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/qr_image.png",
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      HeadingText(
                        color: Colors.black,
                        text: item["coupon_code"] ?? "",
                        fontSize: 17,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.54,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildKeyValuePair(
                        "Product name",
                        item["product_name"] ?? "",
                        Colors.black,
                        Colors.grey,
                      ),
                      _buildKeyValuePair(
                        "Coupon id",
                        item["coupon_id"] ?? "",
                        Colors.black,
                        Colors.grey,
                      ),
                      _buildKeyValuePair(
                        "Offer amount",
                        "${item["incentive_amount"] ?? 0} ₹",
                        Colors.black,
                        Colors.green,
                      ),
                      _buildKeyValuePair(
                        "Pack size",
                        item["pack_size"] ?? "",
                        Colors.black,
                        Colors.red,
                      ),
                      _buildKeyValuePair(
                        "UPI Id",
                        item["sender_upi_id"] ?? "",
                        Colors.black,
                        Colors.blue,
                      ),
                      _buildKeyValuePair(
                        "Transaction id",
                        item["transaction_id"] ?? "",
                        Colors.black,
                        Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                        text: item["payment_status"] ?? "Unknown",
                        fontSize: 16,
                        horizontalvalue: 50,
                        backgroundColor: _getStatusColor(item["status"]),
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyValuePair(String label, String value, Color labelColor, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingText(
            color: labelColor,
            text: label,
            fontSize: 14,
          ),
          const SizedBox(height: 2),
          HeadingText(
            color: valueColor,
            text: value,
            fontSize: 13,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "completed":
        return Colors.orange;
      case "pending":
        return Colors.grey;
      case "cancelled":
        return redcolor;
      default:
        return Colors.blueGrey;
    }
  }
}
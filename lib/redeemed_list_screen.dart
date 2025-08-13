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
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
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
                          text: "Redeemed List",
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ],
                    ),
                  ),
                  ...redeemedList.map((item) {
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
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth * 0.35,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/qr_image.png"),
                                    HeadingText(
                                      color: Colors.black,
                                      text: item["coupon_code"] ?? "",
                                      fontSize: 17,
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.54,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "Product name",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.grey,
                                          text: item["product_name"] ?? "",
                                          fontSize: 13),
                                    ),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "Coupon id",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.grey,
                                          text: item["coupon_id"] ?? "",
                                          fontSize: 13),
                                    ),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "Offer amount",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.green,
                                          text: "${item["incentive_amount"] ?? 0} ₹",
                                          fontSize: 13),
                                    ),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "Pack size",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.red,
                                          text: item["pack_size"] ?? "",
                                          fontSize: 13),
                                    ),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "UPI Id",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.blue,
                                          text: item["sender_upi_id"] ?? "",
                                          fontSize: 13),
                                    ),
                                    CustomKeyValueContainerWithoutBg(
                                      label: HeadingText(
                                          color: Colors.black,
                                          text: "Transaction id",
                                          fontSize: 14),
                                      value: HeadingText(
                                          color: Colors.grey,
                                          text: item["transaction_id"] ?? "",
                                          fontSize: 13),
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
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
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

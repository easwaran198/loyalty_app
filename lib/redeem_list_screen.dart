import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_container_without_background.dart';
import 'package:loyalty_app/constants/custom_date_header.dart';
import 'package:loyalty_app/data/api_service.dart';
import 'package:loyalty_app/splash/custom_text.dart';

class RedeemListScreen extends StatefulWidget {
  @override
  State<RedeemListScreen> createState() => _RedeemListScreenState();
}

class _RedeemListScreenState extends State<RedeemListScreen> {
  bool isLoading = true;
  List<dynamic> redeemableList = [];

  @override
  void initState() {
    super.initState();
    _fetchRedeemableList();
  }

  Future<void> _fetchRedeemableList() async {
    try {
      final api = ApiService();
      final list = await api.getRedeemableList();
      setState(() {
        redeemableList = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: redeemableList.length,
                itemBuilder: (context, index) {
                  final item = redeemableList[index];
                  return _buildRedeemCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xffFF0000),
      height: 100,
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 20),
          HeadingText(
            text: "Redeem list",
            color: Colors.white,
            fontSize: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemCard(Map<String, dynamic> item) {
    final redeemed = item["redeem_status"] == "1";
    return Column(
      children: [
        CustomDateHeader(text: item["scan_date"]),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Image.asset("assets/images/qr_image.png"),
                    HeadingText(
                      color: Colors.black,
                      text: "CPN-${item["coupon_id"]}",
                      fontSize: 17,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Column(
                children: [
                  CustomKeyValueContainerWithoutBg(
                    label: HeadingText(color: Colors.black, text: "Product", fontSize: 15),
                    value: HeadingText(color: Colors.orange, text: item["product_name"], fontSize: 14),
                  ),
                  CustomKeyValueContainerWithoutBg(
                    label: HeadingText(color: Colors.black, text: "Pack Size", fontSize: 15),
                    value: HeadingText(color: Colors.blue, text: item["pack_size"], fontSize: 14),
                  ),
                  CustomKeyValueContainerWithoutBg(
                    label: HeadingText(color: Colors.black, text: "Amount", fontSize: 15),
                    value: HeadingText(color: Colors.green, text: "${item["incentive_amount"]} ₹", fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  redeemed
                      ? CustomButton(
                    text: "Amount credited in ${item["days"] ?? '-'} days",
                    fontSize: 12,
                    horizontalvalue: 13,
                    backgroundColor: yellowColor,
                    textColor: Colors.black,
                    onPressed: () {},
                  )
                      : CustomButton(
                    text: "Redeem",
                    fontSize: 16,
                    horizontalvalue: 50,
                    backgroundColor: redcolor,
                    textColor: Colors.white,
                    onPressed: () {
                      // Call redeem API here
                    },
                    prefixImage: "assets/images/non_open_gift.png",
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

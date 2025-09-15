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

  // Date and filter variables
  DateTime? _startDate;
  DateTime? _endDate;
  String _currentFilter = "today";

  @override
  void initState() {
    super.initState();
    _initializeDefaultDates();
    _fetchRedeemableList();
  }

  void _initializeDefaultDates() {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _fetchRedeemableList() async {
    try {
      setState(() => isLoading = true);
      redeemableList = [];

      final api = ApiService();
      String startDateStr = _formatDate(_startDate!);
      String endDateStr = _formatDate(_endDate!);

      final list = await api.getRedeemableList(startDateStr, endDateStr, _currentFilter);

      setState(() {
        redeemableList = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate == null || picked.isAfter(_endDate!)) {
          _endDate = DateTime.now();
        }
        _currentFilter = "custom";
      });
      _fetchRedeemableList();
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _currentFilter = "custom";
      });
      _fetchRedeemableList();
    }
  }

  void _setTodayFilter() {
    DateTime now = DateTime.now();
    setState(() {
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day);
      _currentFilter = "today";
    });
    _fetchRedeemableList();
  }

  void _setMonthFilter() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      _startDate = firstDayOfMonth;
      _endDate = lastDayOfMonth;
      _currentFilter = "month";
    });
    _fetchRedeemableList();
  }

  void _setYearFilter() {
    DateTime now = DateTime.now();
    DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    DateTime lastDayOfYear = DateTime(now.year, 12, 31);

    setState(() {
      _startDate = firstDayOfYear;
      _endDate = lastDayOfYear;
      _currentFilter = "year";
    });
    _fetchRedeemableList();
  }

  Color _getButtonColor(String filterType) {
    return _currentFilter == filterType ? redcolor : Colors.white;
  }

  Color _getButtonTextColor(String filterType) {
    return _currentFilter == filterType ? Colors.white : Colors.black;
  }

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Date Range"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text("Start Date"),
                subtitle: Text(_formatDate(_startDate!)),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectStartDate();
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text("End Date"),
                subtitle: Text(_formatDate(_endDate!)),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectEndDate();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchRedeemableList();
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;



    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          color: Colors.white,
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterButtons(),
              _buildDateRangeDisplay(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchRedeemableList,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                           SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: redeemableList.length,
                            itemBuilder: (context, index) {
                              final item = redeemableList[index];
                              return _buildRedeemCard(item);
                            },
                          ),
                        if (isLoading && redeemableList.isEmpty)
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildFilterButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            CustomButton(
              text: "Select Date",
              horizontalvalue: 20,
              fontSize: 14,
              backgroundColor: _getButtonColor("custom"),
              textColor: _getButtonTextColor("custom"),
              onPressed: _showDateRangeDialog,
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Today",
              horizontalvalue: 30,
              fontSize: 14,
              backgroundColor: _getButtonColor("today"),
              textColor: _getButtonTextColor("today"),
              onPressed: _setTodayFilter,
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Month wise",
              horizontalvalue: 20,
              fontSize: 14,
              backgroundColor: _getButtonColor("month"),
              textColor: _getButtonTextColor("month"),
              onPressed: _setMonthFilter,
            ),
            const SizedBox(width: 10),
            CustomButton(
              text: "Year wise",
              horizontalvalue: 20,
              fontSize: 14,
              backgroundColor: _getButtonColor("year"),
              textColor: _getButtonTextColor("year"),
              onPressed: _setYearFilter,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeDisplay() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "From: ${_formatDate(_startDate!)} To: ${_formatDate(_endDate!)}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemCard(Map<String, dynamic> item) {

    final redeemed = item["redeem_status"] == "1";

    return Container(
      child: Column(
        children: [
          CustomDateHeader(text: item["scan_date"]),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            padding: EdgeInsets.all(15.0),
            margin: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomKeyValueContainerWithoutBg(
                  label: HeadingText(color: Colors.black, text: "Product", fontSize: 15),
                  value: HeadingText(color: Colors.orange, text: item["product_name"], fontSize: 14),
                ),
                CustomKeyValueContainerWithoutBg(
                  label: HeadingText(color: Colors.black, text: "Amount", fontSize: 15),
                  value: HeadingText(color: Colors.green, text: "${item["incentive_amount"]} ₹", fontSize: 14),
                ),
                const SizedBox(height: 15),
                Center(
                  child: redeemed
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
                    prefixImage: "assets/images/non_open_gift.png",
                    onPressed: () async {
                      final api = ApiService();
                      final couponId = item["coupon_id"] ?? "0";
                      final result = await api.redeemCoupon(couponId);

                      if (result["success"] == "true") {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result["message"] ?? "Redeemed successfully")),
                          );
                          _fetchRedeemableList();
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result["message"] ?? "Redeem failed")),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
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

  DateTime? _startDate;
  DateTime? _endDate;
  String _currentFilter = "today";

  @override
  void initState() {
    super.initState();
    _initializeDefaultDates();
    _loadRedeemedList();
  }

  void _initializeDefaultDates() {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
  }

  void _loadRedeemedList() {
    String startDateStr = _formatDate(_startDate!);
    String endDateStr = _formatDate(_endDate!);

    setState(() {
      _redeemedListFuture = _apiService.getRedeemedList(
        startDateStr,
        endDateStr,
        _currentFilter,
      );
    });
  }

  Future<void> _refreshRedeemedList() async {
    _loadRedeemedList();
    await _redeemedListFuture;
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
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
      _loadRedeemedList();
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
      _loadRedeemedList();
    }
  }

  void _setTodayFilter() {
    DateTime now = DateTime.now();
    setState(() {
      _startDate = DateTime(now.year, now.month, now.day);
      _endDate = DateTime(now.year, now.month, now.day);
      _currentFilter = "today";
    });
    _loadRedeemedList();
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
    _loadRedeemedList();
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
    _loadRedeemedList();
  }

  Color _getButtonColor(String filterType) {
    return _currentFilter == filterType ? redcolor : Colors.white;
  }

  Color _getButtonTextColor(String filterType) {
    return _currentFilter == filterType ? Colors.white : Colors.black;
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
              Container(
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
                        onPressed: () {
                          _showDateRangeDialog();
                        },
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
              ),
              Container(
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
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshRedeemedList,
                  child: FutureBuilder<List<dynamic>>(
                    future: _redeemedListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Center(
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
                            ),
                          ],
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "No redeemed coupons found.",
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final redeemedList = snapshot.data!;

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: redeemedList.length,
                        itemBuilder: (context, index) {
                          return _buildRedeemedItem(context, redeemedList[index], screenWidth);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadRedeemedList();
              },
              child: const Text("Apply"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRedeemedItem(BuildContext context, dynamic item, double screenWidth) {
    return Container(
      color: Colors.white,
      child: Column(
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
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    _buildKeyValuePair(
                      "Product name",
                      item["product_name"] ?? "",
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
                    Center(
                      child: CustomButton(
                        text: item["payment_status"] ?? "Unknown",
                        fontSize: 16,
                        horizontalvalue: 50,
                        backgroundColor: _getStatusColor(item["status"]),
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyValuePair(String label, String value, Color labelColor, Color valueColor) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidth * 0.25,
            child: HeadingText(
              color: labelColor,
              text: label,
              fontSize: 14,
            ),
          ),
          Container(
            width: screenWidth * 0.01,
            child: HeadingText(
              color: labelColor,
              text: ":",
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: screenWidth * 0.5,
            child: HeadingText(
              color: valueColor,
              text: value,
              fontSize: 13,
            ),
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

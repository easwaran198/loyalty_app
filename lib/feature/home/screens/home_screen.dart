import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_text_lora.dart';
import 'package:loyalty_app/data/api_service.dart';
import 'package:loyalty_app/data/models/MyprofileRes.dart';
import 'package:loyalty_app/profile_screen.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  List<String> sliderItems = [
    "assets/images/non_open_gift.png",
    "assets/images/opened_gift.png",
    "assets/images/profile_img.jpg",
  ];
  var myprofileRes = MyprofileRes();
  final ApiService _apiService = ApiService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    loadProfile();
  }

  void loadProfile() async {
    myprofileRes = await _apiService.getMyProfile();
    setState(() {});
  }

  Future<void> _refreshProfile() async {
    await _apiService.getMyProfile().then((profile) {
      myprofileRes = profile;
    });
    setState(() {});
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && myprofileRes.sliderImages != null && myprofileRes.sliderImages!.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= myprofileRes.sliderImages!.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.red),
                child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text('Product Catalog'),
                onTap: () {
                  //Navigator.pop(context);
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Completed Sites'),
                onTap: () {
                  //Navigator.pop(context);
                 // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.login_outlined),
                title: Text('Logout'),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshProfile,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header Section
                  Container(
                    color: Color(0xffFF0000),
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Icon(Icons.menu, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadingTextLora(text: "Welcome to ", color: Colors.white, fontSize: 28),
                              HeadingText(text: "K-Delite Portal", color: Colors.white, fontSize: 20),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // Greeting
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: HeadingText(color: Colors.black, text: "Dear ${myprofileRes.name ?? ''}", fontSize: 20),
                  ),

                  // Earnings Today & Yesterday
                  Container(
                    width: screenWidth,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingText(color: Colors.red, text: "K-Delite For the Day", fontSize: 20),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.39,
                              margin: EdgeInsets.only(left: 20),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff05C6E4),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  HeadingText(color: Colors.black, text: "Today Earnings", fontSize: 14),
                                  Image.asset("assets/images/money_bag.png"),
                                  HeadingText(
                                    color: Colors.white,
                                    text: "${myprofileRes.todayEarnings != null && myprofileRes.todayEarnings != '' ? myprofileRes.todayEarnings : 0}",
                                    fontSize: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.39,
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xffFF5F2A),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  HeadingText(color: Colors.black, text: "Yesterday Earnings", fontSize: 13),
                                  Image.asset("assets/images/money_bag.png"),
                                  HeadingText(
                                      color: Colors.white,
                                      text: "${myprofileRes.yesterdayEarnings != null && myprofileRes.yesterdayEarnings != '' ? myprofileRes.yesterdayEarnings : 0}",
                                      fontSize: 20),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Earnings This Month & Previous Month
                  Container(
                    width: screenWidth,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingText(color: Colors.red, text: "K-Delite For Month", fontSize: 20),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              margin: EdgeInsets.only(left: 20),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff3FD40E),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  HeadingText(color: Colors.black, text: "This month", fontSize: 14),
                                  Image.asset("assets/images/money_bag.png"),
                                  HeadingText(
                                      color: Colors.white,
                                      text: "${myprofileRes.thisMonthEarnings != null && myprofileRes.thisMonthEarnings != '' ? myprofileRes.thisMonthEarnings : 0}",
                                      fontSize: 20),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.39,
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xffF42AFF),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  HeadingText(color: Colors.black, text: "Previous Month", fontSize: 14),
                                  Image.asset("assets/images/money_bag.png"),
                                  HeadingText(
                                      color: Colors.white,
                                      text: "${myprofileRes.preMonthEarnings != null && myprofileRes.preMonthEarnings != '' ? myprofileRes.preMonthEarnings : 0}",
                                      fontSize: 20),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // Scan Code Button
                  CustomButton(
                    text: "Scan code",
                    fontSize: 16,
                    textColor: Colors.white,
                    horizontalvalue: 100,
                    onPressed: () {
                      Navigator.pushNamed(context, '/scanner');
                    },
                    prefixIcon: Icons.document_scanner_outlined,
                    backgroundColor: redcolor,
                  ),

                  SizedBox(height: 20),

                  // ✅ Auto Slider Section
                  if (myprofileRes.sliderImages != null && myprofileRes.sliderImages!.isNotEmpty)
                    Container(
                      width: screenWidth,
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: myprofileRes.sliderImages!.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      myprofileRes.sliderImages![index].image.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(myprofileRes.sliderImages!.length, (index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == index ? 12 : 8,
                                height: _currentPage == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index ? Colors.red : Colors.grey,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 10),

                  // Redeem List and Redeem Completed Cards
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        margin: EdgeInsets.only(bottom: 10, top: 10, right: 20, left: 25),
                        decoration: BoxDecoration(
                          color: Color(0xffFFCD2A),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(height: 100, child: Image.asset("assets/images/non_open_gift.png")),
                            SizedBox(height: 10),
                            HeadingText(color: Colors.black, text: "Redeem List", fontSize: 16),
                            SizedBox(height: 20),
                            CustomButton(
                              text: "View",
                              fontSize: 16,
                              textColor: Colors.blue,
                              horizontalvalue: 30,
                              onPressed: () {
                                Navigator.pushNamed(context, '/redeemlist');
                              },
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.4,
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffFFCD2A),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(height: 100, child: Image.asset("assets/images/opened_gift.png")),
                            SizedBox(height: 10),
                            HeadingText(color: Colors.black, text: "Redeem Completed", fontSize: 16),
                            SizedBox(height: 20),
                            CustomButton(
                              text: "View",
                              fontSize: 16,
                              textColor: Colors.blue,
                              horizontalvalue: 30,
                              onPressed: () {
                                Navigator.pushNamed(context, '/redeemedlist');
                              },
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Clear stored data
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("userid");
              await prefs.remove("token");

              Navigator.of(context).pop(); // Close dialog

              // You can emit a new state or navigate
              // For example, navigate to login screen:
              Navigator.of(context).pushReplacementNamed('/login');

              // OR emit state if using Bloc
              // context.read<SplashBloc>().add(SplashLogoutEvent());
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

}

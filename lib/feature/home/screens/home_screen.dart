import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/splash/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Color(0xffFF0000),
              height: 100,
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(Icons.menu_open_sharp,color: Color(0xffFFFFFF),),
                    SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingText(text: "Welcome to ",color: Colors.white,fontSize: 28),
                        HeadingText(text: "Paint Redeem Portal",color: Colors.white,fontSize: 20),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset("assets/images/qr_icon.png"),
                  SizedBox(width: 10,),
                  HeadingText(color: Colors.black, text: "Scan QR code", fontSize: 20)
                ],
              ),
            ),
            Container(
              width: screenWidth,
              margin: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
              decoration: BoxDecoration(
                color: Color(0xffFFCD2A),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black,width: 1.5),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  HeadingText(color: Colors.black, text: "Mr.Shankar paint shop", fontSize: 20),
                  Image.asset("assets/images/qr_image.png")
                ],
              ),
            ),
            SizedBox(height: 10,),
            CustomButton(text: "Scan code", fontSize: 16,textColor: Colors.white, horizontalvalue: 100,onPressed: (){
              //Navigator.pushNamed(context, "/scanner");
              Navigator.pushNamed(
                context,
                '/scanner'
              );
            }, prefixIcon: Icons.document_scanner_outlined,backgroundColor: redcolor,),
            SizedBox(height: 10,),
            Row(
              children: [
                Container(
                  width: screenWidth*0.4,
                  margin: EdgeInsets.only(bottom: 10,top: 10,right: 20,left: 25),
                  decoration: BoxDecoration(
                    color: Color(0xffFFCD2A),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black,width: 1.5),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                          height: 100,
                          child: Image.asset("assets/images/non_open_gift.png")),
                      SizedBox(height: 10,),
                      HeadingText(color: Colors.black, text: "Redeem List", fontSize: 16),
                      SizedBox(height: 20,),
                      CustomButton(text: "View",fontSize: 16, textColor: Colors.blue,horizontalvalue: 30, onPressed: (){
                          Navigator.pushNamed(context, '/redeemlist');

                      },backgroundColor: Colors.white,),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth*0.4,
                  margin: EdgeInsets.only(bottom: 10,top: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffFFCD2A),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black,width: 1.5),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                          height: 100,
                          child: Image.asset("assets/images/opened_gift.png")),
                      SizedBox(height: 10,),
                      HeadingText(color: Colors.black, text: "Redeem Completed", fontSize: 16),
                      SizedBox(height: 20,),
                      CustomButton(text: "View", fontSize: 16,textColor: Colors.blue,horizontalvalue: 30, onPressed: (){
                        Navigator.pushNamed(context, '/redeemedlist');
                      },backgroundColor: Colors.white,),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}

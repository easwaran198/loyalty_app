import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_app/splash/custom_text.dart';

class CustomDateHeader extends StatelessWidget{
  final String text;
  const CustomDateHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset("assets/images/bullet_img.png"),
          SizedBox(width: 10,),
          HeadingText(color: Colors.black, text: text, fontSize: 20)
        ],
      ),
    );
  }
}
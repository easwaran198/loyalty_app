import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_field.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyOtpScreen extends StatefulWidget{
  final String otp;
  final String mobileno;

  VerifyOtpScreen({super.key,required this.otp,required this.mobileno});

  @override
  State<VerifyOtpScreen> createState()=> VerifyOtpScreenState();

}

class VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();


  @override
  void initState() {
    super.initState();
    print("datayyy"+widget.otp);
    otpController.text  = widget.otp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_img.jpg"),
              fit: BoxFit.cover, // Makes the image cover the whole background
            ),
          ),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/loyalty_logo.png"),
                    SizedBox(height: 20),
                    HeadingText(text: "Verify Your OTP",color: Colors.black,fontSize: 24),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: CustomTextField(
                        controller: otpController,
                        label: "Enter Otp here",
                        icon: Icons.verified_outlined,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                        textColor: Colors.black, // Text color
                        backgroundColor: Color(
                          0xffFFDEDE,
                        ), // Background color
                      ),
                    ),

                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return
                          CustomButton(
                            text: "Submit",
                            horizontalvalue: 50,
                            backgroundColor: redcolor,
                            fontSize: 16,
                            textColor: Colors.white,
                            borderRadius: 30,
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                VerifyOtpRequested(otpController.text,widget.mobileno),
                              );
                            },
                          );
                      },
                    ),
                    SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_field.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final mobilenoController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_img.jpg"),
                fit: BoxFit.cover, // Makes the image cover the whole background
              ),
            ),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  print("print(state.otp)"+state.otp);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  Navigator.pushNamed(context, "/verify-otp", arguments: {
                    "otp": state.otp,
                    "mobileno" : mobilenoController.text.toString()
                  });
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 300,
                        width: 400,
                        child: Image.asset("assets/images/loyalty_logo.png")),
                    HeadingText(text: "Login here",color: Colors.black,fontSize: 24,),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: mobilenoController,
                            label: "Enter your mobile number",
                            icon: Icons.mobile_screen_share_sharp,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
          
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return CustomButton(
                          textColor: Colors.white,
                          horizontalvalue: 50,
                          fontSize: 16,
                          backgroundColor: redcolor,
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              LoginRequested(mobilenoController.text),
                            );
                          },
                          text: 'Login',
                        );
                      },
                    ),
                    SizedBox(height: 15,),
                    /*InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),))*/
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

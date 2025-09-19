import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:loyalty_app/constants/custom_date_picker.dart';
import 'package:loyalty_app/constants/custom_field.dart';
import 'package:loyalty_app/constants/custom_radio_group.dart';
import 'package:loyalty_app/constants/image_upload_field.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final adhaarNoController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressController = TextEditingController();
  final panNOController = TextEditingController();
  final pincodeController = TextEditingController();
  final accountNoController = TextEditingController();
  final bankNameController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final branchNameController = TextEditingController();
  final upiIdController = TextEditingController();
  var profileImage_str = "";
  var adhaarno_image_str = "";
  var pan_no_image_str = "";
  var pass_book_image_str = "";
  TextEditingController dobController = TextEditingController();
  TextEditingController marriageAnniversaryDateController =
      TextEditingController();
  String? selectedGenderValue;
  List<String> dynamicOptions = ["Male", "Female", "Others"];
  String? selectedMaritalStatus;
  List<String> maritalStatusOptions = ["Single", "Married"];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
                    "mobileno" : mobileNoController.text.toString()
                  });
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                        height:  180,
                        child: Image.asset("assets/images/loyalty_logo.png")),
                    HeadingText(text: "Create an Account",color: Colors.black,fontSize: 24,),
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
                            controller: nameController,
                            label: "Full Name",
                            icon: Icons.person,
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
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: emailController,
                            label: "Email id",
                            icon: Icons.mail,
                            keyboardType: TextInputType.emailAddress,
                            textColor: Colors.black, // Text color
                            backgroundColor: lightRed, // Background color
                          ),
                          SizedBox(height: 10),
                          ImageUploadField(
                            labelText:
                                "Upload your profile picture", // Your custom label here
                            onImageSelected: (base64) {
                              setState(() {
                                profileImage_str = base64;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: adhaarNoController,
                            label: "Adhaar number",
                            icon: Icons.approval_outlined,
                            keyboardType: TextInputType.phone,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),

                          SizedBox(height: 10),
                          CustomTextField(
                            controller: mobileNoController,
                            label: "Mobile number",
                            icon: Icons.approval_outlined,
                            keyboardType: TextInputType.phone,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          ImageUploadField(
                            labelText:
                                "Upload your adhaar image", // Your custom label here
                            onImageSelected: (base64) {
                              setState(() {
                                adhaarno_image_str = base64;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: panNOController,
                            label: "PAN number",
                            icon: Icons.credit_card,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          ImageUploadField(
                            labelText:
                                "Upload your PAN image", // Your custom label here
                            onImageSelected: (base64) {
                              setState(() {
                                pan_no_image_str = base64;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          ImageUploadField(
                            labelText:
                                "Upload your Bank passbook image", // Your custom label here
                            onImageSelected: (base64) {
                              setState(() {
                                pass_book_image_str = base64;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: accountNoController,
                            label: "Bank name",
                            icon: Icons.account_balance,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: bankNameController,
                            label: "Bank account number",
                            icon: Icons.account_balance,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: ifscCodeController,
                            label: "IFSC code",
                            icon: Icons.account_balance,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: adhaarNoController,
                            label: "Branch name",
                            icon: Icons.account_balance,
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
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: upiIdController,
                            label: "UPI id/UPI mobile number",
                            icon: Icons.account_balance,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          CustomDatePickerField(
                            controller: dobController,
                            hint: "Date of birth",
                          ),
                          SizedBox(height: 10),
                          CustomRadioGroup(
                            hint: 'Gender',
                            options: dynamicOptions,
                            selectedValue: selectedGenderValue,
                            onChanged: (value) {
                              setState(() {
                                selectedGenderValue = value;
                              });
                              print("Selected: $value");
                            },
                          ),
                          SizedBox(height: 10),
                          CustomRadioGroup(
                            hint: 'Marital status',
                            options: maritalStatusOptions,
                            selectedValue: selectedMaritalStatus,
                            onChanged: (value) {
                              setState(() {
                                selectedMaritalStatus = value;
                              });
                              print("Selected: $value");
                            },
                          ),
                          SizedBox(height: 10),
                          CustomDatePickerField(
                            controller: marriageAnniversaryDateController,
                            hint: "Marriage anniversary date",
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: addressController,
                            label: "Residential address",
                            icon: Icons.home,
                            keyboardType: TextInputType.name,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            controller: pincodeController,
                            label: "Pincode",
                            icon: Icons.location_city,
                            keyboardType: TextInputType.number,
                            textColor: Colors.black, // Text color
                            backgroundColor: Color(
                              0xffFFDEDE,
                            ), // Background color
                          ),
                        ],
                      ),
                    ),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              RegisterRequested(
                                nameController.text,
                                emailController.text,
                                mobileNoController.text,
                                profileImage_str,
                                adhaarNoController.text.toString(),
                                adhaarno_image_str,
                                panNOController.text.toString(),
                                pan_no_image_str,
                                pass_book_image_str,
                                bankNameController.text.toString(),
                                accountNoController.text.toString(),
                                ifscCodeController.text.toString(),
                                branchNameController.text.toString(),
                                upiIdController.text.toString(),
                                dobController.text.toString(),
                                selectedGenderValue!,
                                marriageAnniversaryDateController.text
                                    .toString(),
                                addressController.text.toString(),
                                pincodeController.text.toString(), selectedMaritalStatus!
                              ),
                            );
                          },
                          child: const Text("Register"),
                        );
                      },
                    ),
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

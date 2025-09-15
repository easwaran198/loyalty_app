import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/custom_button.dart';
import 'package:loyalty_app/constants/custom_field.dart';
import 'package:loyalty_app/constants/custom_radio_group.dart';
import 'package:loyalty_app/data/api_service.dart';
import 'package:loyalty_app/data/models/MyprofileRes.dart';
import 'package:loyalty_app/splash/custom_text.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  var myprofileRes = MyprofileRes();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    myprofileRes = await _apiService.getMyProfile();
    setState(() {});
  }

  void showEditProfileDialog() {
    final nameController = TextEditingController(text: myprofileRes.name ?? "");
    final adhaarNoController = TextEditingController(text: myprofileRes.aadharNo ?? "");
    final mobileNoController = TextEditingController(text: myprofileRes.mobileno ?? "");
    final panNOController = TextEditingController(text: myprofileRes.panNo ?? "");
    final accountNoController = TextEditingController(text: myprofileRes.accNo ?? "");
    final bankNameController = TextEditingController(text: myprofileRes.bankName ?? "");
    final ifscCodeController = TextEditingController(text: myprofileRes.ifscCode ?? "");
    final branchNameController = TextEditingController(text: myprofileRes.branchName ?? "");
    final upiIdController = TextEditingController(text: myprofileRes.upiId ?? "");
    final upiMobileController = TextEditingController(text: myprofileRes.upiMobileNo ?? "");
    final dobController = TextEditingController(text: myprofileRes.dob ?? "");
    final marriageAnniversaryDateController = TextEditingController(text: myprofileRes.anniversaryDate ?? "");
    final addressController = TextEditingController(text: myprofileRes.address ?? "");
    final pincodeController = TextEditingController(text: myprofileRes.pincode ?? "");

    String? selectedGender = myprofileRes.gender ?? "Male";
    String? selectedMaritalStatus = myprofileRes.maritalStatus ?? "single";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(controller: nameController, label: "Full Name", icon: Icons.person, keyboardType: TextInputType.name),
                  SizedBox(height: 10),
                  CustomTextField(controller: mobileNoController, label: "Mobile Number", icon: Icons.phone, keyboardType: TextInputType.phone),
                  SizedBox(height: 10),
                  CustomTextField(controller: adhaarNoController, label: "Adhaar Number", icon: Icons.approval_outlined, keyboardType: TextInputType.phone),
                  SizedBox(height: 10),
                  CustomTextField(controller: panNOController, label: "PAN Number", icon: Icons.credit_card, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: accountNoController, label: "Account Number", icon: Icons.account_balance, keyboardType: TextInputType.number),
                  SizedBox(height: 10),
                  CustomTextField(controller: bankNameController, label: "Bank Name", icon: Icons.account_balance, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: ifscCodeController, label: "IFSC Code", icon: Icons.code, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: branchNameController, label: "Branch Name", icon: Icons.location_city, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: upiIdController, label: "UPI ID", icon: Icons.payment, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: upiMobileController, label: "UPI Mobile No", icon: Icons.phone_android, keyboardType: TextInputType.phone),
                  SizedBox(height: 10),
                  CustomTextField(controller: dobController, label: "Date of Birth", icon: Icons.calendar_today, keyboardType: TextInputType.datetime),
                  SizedBox(height: 10),
                  CustomRadioGroup(
                    hint: 'Gender',
                    options: ['Male', 'Female', 'Other'],
                    selectedValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  CustomRadioGroup(
                    hint: 'Marital Status',
                    options: ['single', 'married', 'divorced'],
                    selectedValue: selectedMaritalStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedMaritalStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(controller: marriageAnniversaryDateController, label: "Marriage Anniversary Date", icon: Icons.calendar_today, keyboardType: TextInputType.datetime),
                  SizedBox(height: 10),
                  CustomTextField(controller: addressController, label: "Address", icon: Icons.home, keyboardType: TextInputType.text),
                  SizedBox(height: 10),
                  CustomTextField(controller: pincodeController, label: "Pincode", icon: Icons.location_pin, keyboardType: TextInputType.number),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text("Save"),
                onPressed: () async {
                  Map<String, dynamic> request = {
                    "name": nameController.text,
                    "gender": selectedGender,
                    "mobileno": mobileNoController.text,
                    "profile_img": "https://profile.png",
                    "aadhar_img": "https://aadhar.png",
                    "aadhar_no": adhaarNoController.text,
                    "pan_img": "https://pan.png",
                    "pan_no": panNOController.text,
                    "bank_pass_img": "https://bank_passbook.png",
                    "acc_no": accountNoController.text,
                    "bank_name": bankNameController.text,
                    "ifsc_code": ifscCodeController.text,
                    "branch_name": branchNameController.text,
                    "upi_id": upiIdController.text,
                    "upi_mobile_no": upiMobileController.text,
                    "dob": dobController.text,
                    "marital_status": selectedMaritalStatus,
                    "anniversary_date": marriageAnniversaryDateController.text,
                    "address": addressController.text,
                    "pincode": pincodeController.text
                  };

                  print(json.encode(request));
                  bool success = await _apiService.updateProfile(request);

                  if (success) {
                    Navigator.pop(context);
                    loadProfile();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile")));
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile_img.jpg"),
                ),
                SizedBox(height: 20),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Name", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.name ?? "", fontSize: 19),
                ),
               /* CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Email id", fontSize: 17),
                  value: HeadingText(color:                          Colors.green, text: myprofileRes.emailid ?? "", fontSize: 19),
                ),*/
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Aadha  r number", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.aadharNo ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Mobile number", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.mobileno ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "PAN number", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.panNo ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Account number", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.accNo ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "IFSC code", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.ifscCode ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Branch name", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.branchName ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "UPI number / UPI mobile number", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.upiMobileNo ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Date of birth", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.dob ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Gender", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.gender ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Marital Status", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.maritalStatus ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Marriage anniversary date", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.anniversaryDate ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Residental address", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.address ?? "", fontSize: 19),
                ),
                CustomProfileContainer(
                  label: HeadingText(color: Colors.black, text: "Pincode", fontSize: 17),
                  value: HeadingText(color: Colors.green, text: myprofileRes.pincode ?? "", fontSize: 19),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: "Edit Profile",
                  horizontalvalue: 50,
                  fontSize: 20,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  onPressed: showEditProfileDialog,
                ),
                SizedBox(height: 10),
                CustomButton(
                  text: "Back",
                  horizontalvalue: 50,
                  fontSize: 20,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProfileContainer extends StatelessWidget {
  final Widget label;
  final Widget value;
  final double colonSpacing;

  const CustomProfileContainer({
    super.key,
    required this.label,
    required this.value,
    this.colonSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Align(alignment: Alignment.centerLeft, child: label)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: colonSpacing / 2),
            child: const Text(":", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(flex: 6, child: Align(alignment: Alignment.centerLeft, child: value)),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const baseUrl = "https://ttbilling.in/loyaltyapp/api";


  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String mobileno,
      String profileimg,
      String adhaarno,
      String adharimg,
      String panno,
      String panimg,
      String passbookimg,
      String bankname,
      String accno,
      String ifsccode,
      String upiid,
      String branchname,
      String dob,
      String gender,
      String anniversarydate,
      String address,
      String pincode,
      String maritalStatus
      ) async {
    var request = {
      "name": name,
      "email": email,
      "mobileno": mobileno,
      "profile_img": profileimg,
      "aadhar_img": adharimg,
      "aadhar_no": adhaarno,
      "pan_img": panimg,
      "pan_no": panno,
      "bank_pass_img": passbookimg,
      "bank_name": bankname,
      "acc_no": accno,
      "ifsc_code": ifsccode,
      "branch_name": branchname,
      "upi_id": upiid,
      "dob": dob,
      "gender": gender,
      "marital_status": maritalStatus,
      "anniversary_date": anniversarydate,
      "address": address,
      "pincode": pincode
    };

    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(request),
    );

    print("$baseUrl/register");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> login(String mobileno) async {
    var request = {
      "mobileno": mobileno,
    };
    final response = await http.post(
      Uri.parse("$baseUrl/sendotp"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(request),
    );
    print("object-$baseUrl/sendotp");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> verifyOtp(String otp, String mobileno) async {
    var request = {
      "mobileno": mobileno,
      "otp": otp,
    };


    final response = await http.post(
      Uri.parse("$baseUrl/verifyotp"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(request),
    );

    print("object-$baseUrl/verifyotp");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }
  Future<Map<String, dynamic>> scanDetails(String coupon) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    var request = {
      "coupon_id": coupon, // Static for now
      "userid": userid,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/scandetails"),
      headers: {
        "Content-Type": "application/json",
        "token": "$token",
      },
      body: json.encode(request),
    );

    print("$baseUrl/scandetails");
    print(json.encode(request));
    print(response.body);
    print(token);

    return json.decode(response.body);
  }
  Future<Map<String, dynamic>> redeemCoupon(String couponId) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    var request = {
      "coupon_id": couponId,
      "userid": userid,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/redeem"),
      headers: {
        "Content-Type": "application/json",
        "token": "$token",
      },
      body: json.encode(request),
    );

    print("$baseUrl/redeem");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }
  Future<List<dynamic>> fetchRedeemableList() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";

    final response = await http.post(
      Uri.parse("$baseUrl/redeemable_list"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"userid": userid}),
    );

    final data = json.decode(response.body);
    if (data["success"] == "true") {
      return data["redeemable_list"] ?? [];
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getRedeemableList() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    final response = await http.post(
      Uri.parse("$baseUrl/redeemable_list"),
      headers: {
        "Content-Type": "application/json",
        "token": "$token",
      },
      body: json.encode({"userid": userid}),
    );

    final data = json.decode(response.body);
    if (data["success"] == "true") {
      return data["redeemable_list"] ?? [];
    } else {
      throw Exception(data["message"] ?? "Failed to load redeemable list");
    }
  }
  Future<List<dynamic>> getRedeemedList() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    final response = await http.post(
      Uri.parse("$baseUrl/redeemable_list"),
      headers: {
        "Content-Type": "application/json",
        "token": "$token",
      },
      body: json.encode({"userid": userid}),
    );

    final data = json.decode(response.body);
    if (data["success"] == "true") {
      return data["redeemable_list"] ?? [];
    } else {
      throw Exception(data["message"] ?? "Failed to load redeemable list");
    }
  }


}

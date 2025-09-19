import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loyalty_app/data/models/MyprofileRes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  //static const baseUrl = "https://ttbilling.in/loyaltyapp/api";
  static const baseUrl = "https://thanvitechnologies.in/loyaltyapp/api";

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
    String maritalStatus,
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
      "pincode": pincode,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(request),
    );

    print("$baseUrl/register");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }

  Future<String> getDeviceKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceKey = prefs.getString('devicekey');

    if (deviceKey == null) {
      deviceKey = Uuid().v4(); // Generate a new UUID
      await prefs.setString('devicekey', deviceKey); // Save it
    }

    return deviceKey;
  }

  Future<Map<String, dynamic>> login(String mobileno) async {
    String deviceKey = await getDeviceKey();

    var request = {
      "mobileno": mobileno,
      "device_key": deviceKey,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/sendotp"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(request),
    );

    print("Request Body: ${json.encode(request)}");
    print("Response Body: ${response.body}");

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> verifyOtp(String otp, String mobileno) async {
    var request = {"mobileno": mobileno, "otp": otp};

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
      headers: {"Content-Type": "application/json", "token": "$token"},
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

    var request = {"coupon_id": couponId, "userid": userid};

    final response = await http.post(
      Uri.parse("$baseUrl/redeem"),
      headers: {"Content-Type": "application/json", "token": "$token"},
      body: json.encode(request),
    );

    print("$baseUrl/redeem");
    print(json.encode(request));
    print(response.body);

    return json.decode(response.body);
  }

  Future<List<dynamic>> getRedeemableList(String fromdate,String todate, String filter) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    print(token);
    final response = await http.post(
      Uri.parse("$baseUrl/redeemable_list"),
      headers: {"Content-Type": "application/json", "token": "$token"},
      body: json.encode({
        "userid": userid,
        "fromdate": fromdate,
        "todate": todate,
        "filter": filter,
      }),
    );

    print("res"+response.body);
    print( json.encode({
      "userid": userid,
      "fromdate": fromdate,
      "todate": todate,
      "filter": filter,
    }));
    print("$baseUrl/redeemable_list");
    final data = json.decode(response.body);
    if (data["success"] == "true") {
      return data["redeemable_list"] ?? [];
    } else {
      throw Exception(data["message"] ?? "Failed to load redeemable list");
    }
  }

  Future<List<dynamic>> getRedeemedList(String fromdate,String todate, String filter) async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    final response = await http.post(
      Uri.parse("$baseUrl/redeemed_list"),
      headers: {"Content-Type": "application/json", "token": "$token"},
      body: json.encode({
        "userid": userid,
        "fromdate": fromdate,
        "todate": todate,
        "filter": filter,
      }),
    );

    print("$baseUrl/redeemed_list");
    print(json.encode({
      "userid": userid,
      "fromdate": fromdate,
      "todate": todate,
      "filter": filter,
    }));
    print(response.body);
    print(token);
    final data = json.decode(response.body);
    if (data["success"] == "true") {
      return data["redeemed_list"] ?? [];
    } else {
      throw Exception(data["message"] ?? "Failed to load redeemable list");
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token") ?? "";

    print("token-$token");
    print("$baseUrl/updateprofile");

    final url = Uri.parse("$baseUrl/updateprofile");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "token": token},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == "true") {
          return true;
        } else {
          print("API Error: ${jsonData['message']}");
          return false;
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

  Future<MyprofileRes> getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid") ?? "";
    final token = prefs.getString("token") ?? "";

    final response = await http.post(
      Uri.parse("$baseUrl/getprofile"),
      headers: {"Content-Type": "application/json", "token": token},
      //body: json.encode({"userid": userid}), // enable if API expects body
    );

    print("$baseUrl/getprofile");
    print(response.body);

    final data = json.decode(response.body);

    final getprofile = MyprofileRes.fromJson(data);

    if (getprofile.success == "true") {
      return getprofile;
    } else {
      throw Exception("Failed to load getprofile");
    }
  }
}

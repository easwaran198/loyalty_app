class MyprofileRes {
  String? success;
  String? error;
  String? message;
  dynamic? todayEarnings;
  dynamic? yesterdayEarnings;
  dynamic? thisMonthEarnings;
  dynamic? preMonthEarnings;
  List<SliderImages>? sliderImages;
  String? id;
  String? name;
  String? mobileno;
  String? gender;
  String? aadharNo;
  String? panNo;
  String? accNo;
  String? bankName;
  String? ifscCode;
  String? branchName;
  String? upiId;
  String? dob;
  String? maritalStatus;
  String? anniversaryDate;
  String? pincode;
  String? emailid;
  String? address;
  String? upiMobileNo;
  List<Proof>? proof;

  MyprofileRes(
      {this.success,
        this.error,
        this.message,
        this.todayEarnings,
        this.yesterdayEarnings,
        this.thisMonthEarnings,
        this.preMonthEarnings,
        this.sliderImages,
        this.id,
        this.name,
        this.mobileno,
        this.gender,
        this.aadharNo,
        this.panNo,
        this.accNo,
        this.bankName,
        this.ifscCode,
        this.branchName,
        this.upiId,
        this.dob,
        this.maritalStatus,
        this.anniversaryDate,
        this.pincode,
        this.emailid,
        this.address,
        this.upiMobileNo,
        this.proof});

  MyprofileRes.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    todayEarnings = json['today_earnings'];
    yesterdayEarnings = json['yesterday_earnings'];
    thisMonthEarnings = json['this_month_earnings'];
    preMonthEarnings = json['pre_month_earnings'];
    if (json['slider_images'] != null) {
      sliderImages = <SliderImages>[];
      json['slider_images'].forEach((v) {
        sliderImages!.add(new SliderImages.fromJson(v));
      });
    }
    id = json['id'];
    name = json['name'];
    mobileno = json['mobileno'];
    gender = json['gender'];
    aadharNo = json['aadhar_no'];
    panNo = json['pan_no'];
    accNo = json['acc_no'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    branchName = json['branch_name'];
    upiId = json['upi_id'];
    dob = json['dob'];
    maritalStatus = json['marital_status'];
    anniversaryDate = json['anniversary_date'];
    pincode = json['pincode'];
    emailid = json['emailid'];
    address = json['address'];
    upiMobileNo = json['upi_mobile_no'];
    if (json['proof'] != null) {
      proof = <Proof>[];
      json['proof'].forEach((v) {
        proof!.add(new Proof.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['message'] = this.message;
    data['today_earnings'] = this.todayEarnings;
    data['yesterday_earnings'] = this.yesterdayEarnings;
    data['this_month_earnings'] = this.thisMonthEarnings;
    data['pre_month_earnings'] = this.preMonthEarnings;
    if (this.sliderImages != null) {
      data['slider_images'] =
          this.sliderImages!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobileno'] = this.mobileno;
    data['gender'] = this.gender;
    data['aadhar_no'] = this.aadharNo;
    data['pan_no'] = this.panNo;
    data['acc_no'] = this.accNo;
    data['bank_name'] = this.bankName;
    data['ifsc_code'] = this.ifscCode;
    data['branch_name'] = this.branchName;
    data['upi_id'] = this.upiId;
    data['dob'] = this.dob;
    data['marital_status'] = this.maritalStatus;
    data['anniversary_date'] = this.anniversaryDate;
    data['pincode'] = this.pincode;
    data['emailid'] = this.emailid;
    data['address'] = this.address;
    data['upi_mobile_no'] = this.upiMobileNo;
    if (this.proof != null) {
      data['proof'] = this.proof!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SliderImages {
  String? image;

  SliderImages({this.image});

  SliderImages.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class Proof {
  String? profileImg;
  String? aadharImg;
  String? panImg;
  String? bankPassImg;

  Proof({this.profileImg, this.aadharImg, this.panImg, this.bankPassImg});

  Proof.fromJson(Map<String, dynamic> json) {
    profileImg = json['profile_img'];
    aadharImg = json['aadhar_img'];
    panImg = json['pan_img'];
    bankPassImg = json['bank_pass_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_img'] = this.profileImg;
    data['aadhar_img'] = this.aadharImg;
    data['pan_img'] = this.panImg;
    data['bank_pass_img'] = this.bankPassImg;
    return data;
  }
}

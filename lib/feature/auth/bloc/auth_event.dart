import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String mobileno;
  final String profileimg;
  final String adhaarno;
  final String adharimg;
  final String panno;
  final String panimg;
  final String passbookimg;
  final String bankname;
  final String accno;
  final String ifsccode;
  final String branchname;
  final String upiid;
  final String dob;
  final String gender;
  final String anniversarydate;
  final String address;
  final String pincode;
  final String maritalstatus;
  RegisterRequested(this.name, this.email,this.mobileno, this.profileimg,this.adhaarno,this.adharimg,this.panno,this.panimg,this.passbookimg,
      this.bankname,this.accno,this.ifsccode,this.branchname,this.upiid,this.dob,this.gender,this.anniversarydate,this.address,this.pincode,this.maritalstatus);
}

class LoginRequested extends AuthEvent {
  final String mobileno;
  LoginRequested(this.mobileno);
}

class VerifyOtpRequested extends AuthEvent {
  final String otp;
  final String mobileno;
  VerifyOtpRequested(this.otp,this.mobileno);
}

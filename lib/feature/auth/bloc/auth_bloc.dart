import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await apiService.register(event.name, event.email, event.mobileno,event.profileimg,event.adhaarno,event.adharimg,event.panno,event.panimg,event.passbookimg,event.bankname,event.accno,event.ifsccode,event.upiid,event.branchname,event.dob,event.gender,event.anniversarydate,event.address,event.pincode,event.maritalstatus);
      if (response["success"] == "true") {
        //print(response["otp"]);
        emit(AuthSuccess("Registration Successful",response["otp"]));
      } else {
        emit(AuthFailure(response["message"] ?? "Registration Failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    String deviceKey = "";

    try {

      final response = await apiService.login(event.mobileno);
      if (response["success"] == "true") {
        emit(AuthSuccess("Login Successful",response["otp"]));
      } else {
        emit(AuthFailure(response["message"] ?? "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }


  Future<void> _onVerifyOtpRequested(
      VerifyOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await apiService.verifyOtp(event.otp, event.mobileno);

      // Important: API returns strings, so check accordingly
      if (response["success"] == "true") {
        // Save userid & token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userid", response["userid"].toString());
        await prefs.setString("token", response["token"].toString());

        checkPrefs();
        emit(AuthSuccess("OTP Verified", ""));
      } else {
        emit(AuthFailure(response["message"] ?? "OTP Verification Failed"));
      }
    } catch (e) {
      print(e.toString());
      emit(AuthFailure(e.toString()));
    }
  }

  void checkPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userid"));
  }

}

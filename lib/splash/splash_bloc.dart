import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    // Simulate splash delay (optional)
    await Future.delayed(const Duration(seconds: 2));

    // Read from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userid = prefs.getString("userid");
    final token = prefs.getString("token");

    bool isLoggedIn = userid != null && userid.isNotEmpty && token != null && token.isNotEmpty;

    emit(SplashLoaded(isLoggedIn: isLoggedIn));
  }
}

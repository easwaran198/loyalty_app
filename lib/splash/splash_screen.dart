import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(AppStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            if (state.isLoggedIn) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Image.asset("assets/images/loyalty_logo.png"),
                   // SizedBox(height: 30),
                   // CircularProgressIndicator(),
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

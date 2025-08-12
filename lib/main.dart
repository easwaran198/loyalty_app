import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loyalty_app/feature/auth/screens/login_screen.dart';
import 'package:loyalty_app/feature/auth/screens/register_screen.dart';
import 'package:loyalty_app/feature/auth/screens/verify_otp_screen.dart';
import 'package:loyalty_app/feature/home/screens/home_screen.dart';
import 'package:loyalty_app/qr_scan_screen.dart';
import 'package:loyalty_app/redeem_list_screen.dart';
import 'package:loyalty_app/redeemed_list_screen.dart';
import 'package:loyalty_app/scanned_details_screen.dart';
import 'package:loyalty_app/splash/splash_screen.dart';

import 'data/api_service.dart';
import 'feature/auth/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(ApiService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == "/verify-otp") {
          if(settings.arguments != null){
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => VerifyOtpScreen(otp: args["otp"] ?? "",mobileno: args["mobileno"]??"",),
            );
          }
        }
        return null;
      },
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/scanner': (_) => const QRScannerScreen(),
        '/scanneddetails': (_) => const ScannedDetailsScreen(),
        '/redeemlist': (_) => RedeemListScreen(),
        '/redeemedlist': (_) => RedeemedListScreen(),
      },
    );
    ;
  }
}



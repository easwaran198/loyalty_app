import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final bool isLoggedIn;
  SplashLoaded({required this.isLoggedIn});

  @override
  List<Object?> get props => [isLoggedIn];
}

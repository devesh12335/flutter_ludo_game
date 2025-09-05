import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


import 'bloc.dart';

enum SplashStatus { initial, loading, loaded, error }

class SplashState extends Equatable {
  SplashStatus? status;
  String? error;
 

  SplashState({
    this.status,
    this.error,
   
  });

  static SplashState initial() {
    return SplashState(
        status: SplashStatus.initial,);
       
  }

  SplashState clone({
    SplashStatus? status,
    String? error,
   
  }) {
    return SplashState(
      status: status ?? this.status,
      error: error ?? this.error,
    
    );
  }

  @override
  List<Object?> get props =>
      [status, error, ];
}

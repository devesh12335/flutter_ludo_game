import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


import 'bloc.dart';

enum LoginStatus { initial, loading, loaded, error }

class LoginState extends Equatable {
  LoginStatus? status;
  String? error;
 

  LoginState({
    this.status,
    this.error,
   
  });

  static LoginState initial() {
    return LoginState(
        status: LoginStatus.initial,);
       
  }

  LoginState clone({
    LoginStatus? status,
    String? error,
   
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
    
    );
  }

  @override
  List<Object?> get props =>
      [status, error, ];
}

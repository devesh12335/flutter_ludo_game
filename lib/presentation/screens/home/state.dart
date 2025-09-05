import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


import 'bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  HomeStatus? status;
  String? error;
 

  HomeState({
    this.status,
    this.error,
   
  });

  static HomeState initial() {
    return HomeState(
        status: HomeStatus.initial,);
       
  }

  HomeState clone({
    HomeStatus? status,
    String? error,
   
  }) {
    return HomeState(
      status: status ?? this.status,
      error: error ?? this.error,
    
    );
  }

  @override
  List<Object?> get props =>
      [status, error, ];
}

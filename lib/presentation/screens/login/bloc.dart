import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<InitEvent>(_init);
    on<ViewNewsEvent>(_viewNews);
  }

  Future<void> _init(InitEvent event, Emitter<LoginState> emit) async {
    try {
      emit(state.clone(
        status: LoginStatus.loading,
      ));
    
      emit(state.clone(status: LoginStatus.loaded));
    } catch (e) {
      emit(state.clone(status: LoginStatus.error, error: e.toString()));
      throw e;
    }
  }

  Future<void> _fetchPage(int pageKey, String searchQuery) async {
    try{

       }catch(e){
 
      throw Exception('Failed to load news ${e}');  
        }
   
     
    
  }

  Future<void> _viewNews(ViewNewsEvent event, Emitter<LoginState> emit) async {
   
  }
}

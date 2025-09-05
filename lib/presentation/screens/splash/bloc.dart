import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initial()) {
    on<InitEvent>(_init);
    on<ViewNewsEvent>(_viewNews);
  }

  Future<void> _init(InitEvent event, Emitter<SplashState> emit) async {
    try {
      emit(state.clone(
        status: SplashStatus.loading,
      ));
    
      emit(state.clone(status: SplashStatus.loaded));
    } catch (e) {
      emit(state.clone(status: SplashStatus.error, error: e.toString()));
      throw e;
    }
  }

  Future<void> _fetchPage(int pageKey, String searchQuery) async {
    try{

       }catch(e){
 
      throw Exception('Failed to load news ${e}');  
        }
   
     
    
  }

  Future<void> _viewNews(ViewNewsEvent event, Emitter<SplashState> emit) async {
   
  }
}

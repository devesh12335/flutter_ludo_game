import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<InitEvent>(_init);
    on<ViewNewsEvent>(_viewNews);
  }

  Future<void> _init(InitEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.clone(
        status: HomeStatus.loading,
      ));
    
      emit(state.clone(status: HomeStatus.loaded));
    } catch (e) {
      emit(state.clone(status: HomeStatus.error, error: e.toString()));
      throw e;
    }
  }

  Future<void> _fetchPage(int pageKey, String searchQuery) async {
    try{

       }catch(e){
 
      throw Exception('Failed to load news ${e}');  
        }
   
     
    
  }

  Future<void> _viewNews(ViewNewsEvent event, Emitter<HomeState> emit) async {
   
  }
}

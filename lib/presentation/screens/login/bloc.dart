import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ludo_game/global_state/app_global.dart';
import 'package:ludo_game/global_state/globalState.dart';
import 'package:ludo_game/presentation/components/toast.dart';
import 'package:ludo_game/presentation/resources/router/route_manager.dart';
import 'package:ludo_game/services/firebase_auth_service.dart';

import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<InitEvent>(_init);
    on<GoogleSignInEvent>(_googleSignIn);
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

  Future<void> _googleSignIn(GoogleSignInEvent event, Emitter<LoginState> emit) async {
   final result =  await FirebaseAuthService.instance.signInWithGoogle();
   print("${FirebaseAuthService.instance.currentUser?.email}");
   if(result.error !=null){
    

    ToastHelper.showToast(result.error.toString(),type: ToastType.error);
   }else{
   
    Navigator.pushNamedAndRemoveUntil(GlobalState.instance.navigatorKey.currentContext!, Routes.ludoPage, (_)=>false);
   }
  }
}

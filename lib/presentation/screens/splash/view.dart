import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_game/global_state/globalState.dart';
import 'package:ludo_game/presentation/resources/router/route_manager.dart';
import 'package:ludo_game/services/firebase_auth_service.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class SplashPage extends StatelessWidget {
 
  SplashPage({super.key, });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(InitEvent()),
      child: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          switch (state.status) {
            case SplashStatus.initial:
            case SplashStatus.loading:
            case SplashStatus.loaded:
            if(FirebaseAuthService.instance.currentUser != null){
              Navigator.pushNamedAndRemoveUntil(context, Routes.ludoPage, (_)=>false);
            }else{
               Navigator.pushNamedAndRemoveUntil(context, Routes.loginPage, (_)=>false);
            }
            case SplashStatus.error:
            case null:
          }
        },
        builder: (context, state) {
          return _buildPage(context, state,);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, SplashState state, ) {
    //print("${state.status}");
    switch (state.status) {
      case SplashStatus.initial:
        return const Scaffold(
          body: Center(child: Text("Initial__")),
        );
      case SplashStatus.loading:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case SplashStatus.loaded:
        //print(":call loaded");
        return Page(
          state: state,
         
        );

      case SplashStatus.error:
        //print(":call loaded");
        return Scaffold(
          body: Center(
            child: Text("${state.error}"),
          ),
        );

      default:
        return const Scaffold(
          body: Center(child: Text("Splash default")),
        );
    }
  }
}

class Page extends StatelessWidget {
  SplashState state;

  Page({required this.state});

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
     double scHeight = MediaQuery.of(context).size.height;
    return Scaffold();
  }

 
}

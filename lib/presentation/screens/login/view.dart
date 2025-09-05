import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class LoginPage extends StatelessWidget {
 
  LoginPage({super.key, });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc()..add(InitEvent()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state.status) {
            case LoginStatus.initial:
            case LoginStatus.loading:
            case LoginStatus.loaded:
            case LoginStatus.error:
            case null:
          }
        },
        builder: (context, state) {
          return _buildPage(context, state,);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, LoginState state, ) {
    //print("${state.status}");
    switch (state.status) {
      case LoginStatus.initial:
        return const Scaffold(
          body: Center(child: Text("Initial__")),
        );
      case LoginStatus.loading:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case LoginStatus.loaded:
        //print(":call loaded");
        return Page(
          state: state,
         
        );

      case LoginStatus.error:
        //print(":call loaded");
        return Scaffold(
          body: Center(
            child: Text("${state.error}"),
          ),
        );

      default:
        return const Scaffold(
          body: Center(child: Text("Login default")),
        );
    }
  }
}

class Page extends StatelessWidget {
  LoginState state;

  Page({required this.state});

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
     double scHeight = MediaQuery.of(context).size.height;
    return Scaffold();
  }

 
}

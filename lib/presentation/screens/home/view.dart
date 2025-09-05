import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class HomePage extends StatelessWidget {
 
  HomePage({super.key, });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(InitEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
            case HomeStatus.loading:
            case HomeStatus.loaded:
            case HomeStatus.error:
            case null:
          }
        },
        builder: (context, state) {
          return _buildPage(context, state,);
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, HomeState state, ) {
    //print("${state.status}");
    switch (state.status) {
      case HomeStatus.initial:
        return const Scaffold(
          body: Center(child: Text("Initial__")),
        );
      case HomeStatus.loading:
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case HomeStatus.loaded:
        //print(":call loaded");
        return Page(
          state: state,
         
        );

      case HomeStatus.error:
        //print(":call loaded");
        return Scaffold(
          body: Center(
            child: Text("${state.error}"),
          ),
        );

      default:
        return const Scaffold(
          body: Center(child: Text("Home default")),
        );
    }
  }
}

class Page extends StatelessWidget {
  HomeState state;

  Page({required this.state});

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
     double scHeight = MediaQuery.of(context).size.height;
    return Scaffold();
  }

 
}

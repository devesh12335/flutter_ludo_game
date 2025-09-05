import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



abstract class SplashEvent {}

class InitEvent extends SplashEvent {}

class ViewNewsEvent extends SplashEvent {
  BuildContext context;
  String newsUrl;
  ViewNewsEvent({required this.context,required this.newsUrl});
}

class SearchNewsEvent extends SplashEvent {
  BuildContext context;
  String searchQuery;
  SearchNewsEvent({required this.context,required this.searchQuery});
}

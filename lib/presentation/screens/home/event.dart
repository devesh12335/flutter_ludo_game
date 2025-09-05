import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



abstract class HomeEvent {}

class InitEvent extends HomeEvent {}

class ViewNewsEvent extends HomeEvent {
  BuildContext context;
  String newsUrl;
  ViewNewsEvent({required this.context,required this.newsUrl});
}

class SearchNewsEvent extends HomeEvent {
  BuildContext context;
  String searchQuery;
  SearchNewsEvent({required this.context,required this.searchQuery});
}

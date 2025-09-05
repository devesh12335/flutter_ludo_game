import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



abstract class LoginEvent {}

class InitEvent extends LoginEvent {}

class ViewNewsEvent extends LoginEvent {
  BuildContext context;
  String newsUrl;
  ViewNewsEvent({required this.context,required this.newsUrl});
}

class SearchNewsEvent extends LoginEvent {
  BuildContext context;
  String searchQuery;
  SearchNewsEvent({required this.context,required this.searchQuery});
}

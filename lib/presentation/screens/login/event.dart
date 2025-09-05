import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



abstract class LoginEvent {}

class InitEvent extends LoginEvent {}

class GoogleSignInEvent extends LoginEvent {
  BuildContext context;
  
  GoogleSignInEvent({required this.context});
}

class SearchNewsEvent extends LoginEvent {
  BuildContext context;
  String searchQuery;
  SearchNewsEvent({required this.context,required this.searchQuery});
}

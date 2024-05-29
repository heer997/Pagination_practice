import 'package:pagination_practice/Models/newsmodel.dart';

abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  NewsModel newsModel;

  NewsLoadedState({required this.newsModel});
}

class NewsErrorState extends NewsState {
  String errormsg;

  NewsErrorState({required this.errormsg});
}

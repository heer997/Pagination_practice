import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:pagination_practice/Cubits/newsstate.dart";
import "package:http/http.dart" as http;
import "package:pagination_practice/Models/newsmodel.dart";
import "package:pagination_practice/Utils/urls.dart";

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitialState());

  getnews() async {
    emit(NewsLoadingState());
    final response = await http.get(Uri.parse(BaseUrls.newsurl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responsedata = jsonDecode(response.body);
      NewsModel newsModel = NewsModel.fromJson(responsedata);
      emit(NewsLoadedState(newsModel: newsModel));
    } else {
      emit(NewsErrorState(errormsg: response.statusCode.toString()));
    }
  }
}

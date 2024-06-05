import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_practice/Pagination_with_Bloc/Bloc/event.dart';
import 'package:pagination_practice/Pagination_with_Bloc/Bloc/state.dart';
import 'package:pagination_practice/Pagination_with_Bloc/post_repo.dart';

class PostBloc extends Bloc<PostEvent, PostsBlocState> {
  int page = 1;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  PostRepo repo;

  PostBloc(this.repo) : super(InitBlocState(null)) {
    scrollController.addListener(
      () {
        add(LoadMoreEvent());
      },
    );

    on<FetchPostsEvent>(
      (event, emit) async {
        emit(PostBlocLoadingState(null));
        var posts = await repo.fetchPosts(page);
        emit(PostBlocSuccessState(posts: posts));
      },
    );

    on<LoadMoreEvent>(
      (event, emit) async {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          isLoadingMore = true;
          page++;
          var posts = await repo.fetchPosts(page);
          emit(PostBlocSuccessState(posts: [...state.posts, ...posts]));
        }
      },
    );
  }
}

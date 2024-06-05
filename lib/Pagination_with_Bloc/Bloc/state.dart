abstract class PostsBlocState {
  final posts;

  PostsBlocState(this.posts);
}

class InitBlocState extends PostsBlocState {
  InitBlocState(super.posts);
}

class PostBlocLoadingState extends PostsBlocState {
  PostBlocLoadingState(super.posts);
}

class PostBlocSuccessState extends PostsBlocState {
  PostBlocSuccessState({required posts}) : super(posts);
}

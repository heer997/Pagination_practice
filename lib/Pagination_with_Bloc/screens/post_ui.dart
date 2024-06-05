import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:pagination_practice/Pagination_with_Bloc/Bloc/bloc.dart";
import "package:pagination_practice/Pagination_with_Bloc/Bloc/event.dart";
import "package:pagination_practice/Pagination_with_Bloc/Bloc/state.dart";
import "package:pagination_practice/Pagination_with_Bloc/post_repo.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PostRepo>(
      create: (context) => PostRepo(),
      child: BlocProvider<PostBloc>(
        create: (context) =>
            PostBloc(context.read<PostRepo>())..add(FetchPostsEvent()),
        child: MaterialApp(
          title: "Pagination",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.grey,
              centerTitle: true,
            ),
          ),
          home: const PostUi(),
        ),
      ),
    );
  }
}

class PostUi extends StatelessWidget {
  const PostUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostBloc, PostsBlocState>(
        builder: (context, state) {
          if (state is PostBlocLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostBlocSuccessState) {
            var posts = state.posts;
            return ListView.builder(
              controller: context.read<PostBloc>().scrollController,
              itemCount: context.read<PostBloc>().isLoadingMore
                  ? posts.length + 1
                  : posts.length,
              itemBuilder: (context, index) {
                if (index >= posts.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var post = posts[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("$index"),
                      ),
                      title: Text(
                        post["id"].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(post["title"]["rendered"].toString()),
                    ),
                  );
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:pagination_practice/Pagination_with_Cubit/cubit/posts_cubit.dart";
import "package:pagination_practice/Pagination_with_Cubit/data/repositories/posts_repository.dart";
import "package:pagination_practice/Pagination_with_Cubit/data/services/posts_service.dart";
import "package:pagination_practice/Pagination_with_Cubit/presentation/posts_screen.dart";

void main() {
  runApp(
    MyApp(
      repository: PostsRepository(PostsService()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final PostsRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(repository),
      child: MaterialApp(
        title: "Pagination",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.grey,
            centerTitle: true,
          ),
        ),
        home: PostView(),
      ),
    );
  }
}

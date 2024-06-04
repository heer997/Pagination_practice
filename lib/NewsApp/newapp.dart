import "dart:developer";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:pagination_practice/NewsApp/Cubits/newscubit.dart";
import "package:pagination_practice/NewsApp/Cubits/newsstate.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NewsCubit()..getnews();
      },
      child: MaterialApp(
        title: "NewsApp",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.grey,
            centerTitle: true,
          ),
        ),
        home: const NewsApp(),
      ),
    );
  }
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() {
    return NewsAppState();
  }
}

class NewsAppState extends State<NewsApp> {
  ScrollController? scrollController;
  int pagenumber = 0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(
        () {
          if (scrollController!.position.pixels ==
              scrollController!.position.maxScrollExtent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(pagenumber.toString()),
                duration: const Duration(seconds: 2),
              ),
            );
            pagenumber++;
            log(pagenumber.toString());
            context.read<NewsCubit>().getnews();
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NewsApp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsLoadedState) {
            return ListView.builder(
              controller: scrollController,
              itemCount: state.newsModel.articles!.length,
              itemBuilder: (context, index) {
                var data = state.newsModel.articles![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data.urlToImage.toString()),
                    ),
                    title: Text(data.title.toString()),
                    subtitle: Text(data.description.toString()),
                  ),
                );
              },
            );
          } else if (state is NewsErrorState) {
            return Center(
              child: Text(
                state.errormsg,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            );
          } else {
            return Container();
          }
        },
      ),

      // body: BlocConsumer<NewsCubit, NewsState>(
      //   listener: (context, state) {
      //     if (state is NewsLoadedState) {
      //       ListView.builder(
      //         itemBuilder: (context, index) {
      //           var data = state.newsModel.articles![index];
      //           return ListTile(
      //             leading: CircleAvatar(
      //               backgroundImage: NetworkImage(data.urlToImage.toString()),
      //             ),
      //             title: Text(data.title.toString()),
      //             subtitle: Text(data.description.toString()),
      //           );
      //         },
      //       );
      //     } else if (state is NewsErrorState) {
      //       Center(
      //         child: Text(state.errormsg),
      //       );
      //     }
      //   },
      //   builder: (context, state) {
      //     if (state is NewsLoadingState) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return const Center(
      //       child: Text("No data found!!"),
      //     );
      //   },
      // ),
    );
  }
}

/// For sending data, listener is used in BlocConsumer
/// For get data, builder is used in BlocBuilder

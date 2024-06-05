import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pagination using HTTP API",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          centerTitle: true,
        ),
      ),
      home: const HomeScreenUsingHttpApi(),
    );
  }
}

class HomeScreenUsingHttpApi extends StatefulWidget {
  const HomeScreenUsingHttpApi({super.key});

  @override
  State<HomeScreenUsingHttpApi> createState() {
    return HomeScreenUsingHttpApiState();
  }
}

class HomeScreenUsingHttpApiState extends State<HomeScreenUsingHttpApi> {
  List itemList = [];

  int page = 1;

  bool hasMoreData = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          ++page;
          fetchData();
        }
      },
    );
    fetchData();
  }

  void fetchData() async {
    int limit = 25;
    final url = Uri.parse(
        "https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page");
    final result = await http.get(url);

    if (result.statusCode == 200) {
      final List data = jsonDecode(result.body);
      if (data.length < limit) {
        hasMoreData = false;
      }
      setState(
        () {
          itemList.addAll(
            data.map(
              (e) {
                return "items ${e["id"]}";
              },
            ),
          );
        },
      );
    } else {
      print("Error ${result.statusCode}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: itemList.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              itemCount: itemList.length + 1,
              itemBuilder: (context, index) {
                if (index < itemList.length) {
                  return Card(
                    child: ListTile(
                      leading: const FlutterLogo(),
                      title: Text(itemList[index].toString()),
                    ),
                  );
                } else {
                  return hasMoreData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Center(
                          child: SizedBox(
                            height: 30.0,
                            child: Text(
                              "No More Data",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

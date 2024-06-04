import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:pagination_practice/Pagination/Model/productModel.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HomePage",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  List<Products> products = [];
  int totalProducts = 1000;

  bool isLoading = false;

  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    getProducts();
    scrollController.addListener(loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          controller: scrollController,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Text(
                      product.id.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    title: Text(
                      product.title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("\$${product.price.toString()}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          width: 150.0,
                          fit: BoxFit.cover,
                          image: NetworkImage(product.thumbnail.toString()),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index == products.length - 1 && isLoading)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    // child: SpinKitThreeBounce(
                    //   color: Colors.purple,
                    //   size: 40.0,
                    // ),
                    child: SpinKitFadingCircle(
                      itemBuilder: (context, index) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void loadMoreData() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        products.length < totalProducts) {
      getProducts();
    }
  }

  Future<void> getProducts() async {
    try {
      setState(
        () {
          isLoading = true;
        },
      );
      final response = await dio.get(
          "https://dummyjson.com/products?limit=15&skip=${products.length}&select=title,price,thumbnail");
      final List data = response.data["products"];
      final List<Products> newProducts = data.map(
        (p) {
          return Products.fromJson(p);
        },
      ).toList();
      setState(
        () {
          isLoading = false;
          totalProducts = response.data["total"];
          products.addAll(newProducts);
        },
      );
      print(newProducts);
      print(data);
    } catch (e) {
      print(e);
    }
  }
}

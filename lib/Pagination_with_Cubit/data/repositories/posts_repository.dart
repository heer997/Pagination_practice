import 'package:pagination_practice/Pagination_with_Cubit/data/models/post.dart';
import 'package:pagination_practice/Pagination_with_Cubit/data/services/posts_service.dart';

class PostsRepository {
  final PostsService service;

  PostsRepository(this.service);

  Future<List<Post>> fetchPosts(int page) async {
    final posts = await service.fetchPosts(page);
    return posts.map(
      (e) {
        return Post.fromJson(e);
      },
    ).toList();
  }
}

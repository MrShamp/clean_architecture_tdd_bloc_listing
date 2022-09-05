import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  // Calls the https://picsum.photos/v2/list?page=1&limit=10 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PostModel>> getPosts(PaginatedParams params);
}

class PostsRemoteDataSourceImplementation implements PostsRemoteDataSource {
  final baseURL = "https://picsum.photos/v2/list";
  final http.Client client;

  PostsRemoteDataSourceImplementation({required this.client});

  @override
  Future<List<PostModel>> getPosts(PaginatedParams params) {
    final fullURL =
        Uri.parse(baseURL).replace(queryParameters: params.toJson()).toString();

    return _getPostsFromUrl(Uri.parse(fullURL));
  }

  Future<List<PostModel>> _getPostsFromUrl(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<PostModel> posts = List<PostModel>.from(
          json.decode(response.body).map((x) => PostModel.fromJson(x)));
      return posts;
    } else {
      throw ServerException();
    }
  }
}

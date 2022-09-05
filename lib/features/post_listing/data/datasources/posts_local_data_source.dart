import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class PostsLocalDataSource {
  /// Gets the cached [PostModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  ///

  Future<List<PostModel>> getLastSavedPosts();
  Future<void> cachePosts(List<PostModel> postsToCache);
}

class PostsLocalDataSourceImplementation implements PostsLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImplementation({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getLastSavedPosts() {
    final jsonString = sharedPreferences.getString(CACHED_POSTS);
    if (jsonString != null) {
      return Future.value(List<PostModel>.from(
          json.decode(jsonString).map((x) => PostModel.fromJson(x))));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    final tempJsonList = postsToCache.map((e) => json.encode(e.toJson())).toList();
    return sharedPreferences.setStringList(
      CACHED_POSTS,
      tempJsonList,
    );
  }
}

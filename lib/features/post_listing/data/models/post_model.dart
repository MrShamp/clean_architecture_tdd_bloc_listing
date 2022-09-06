import 'dart:convert';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  final int width;
  final int height;

  const PostModel({
    required this.width,
    required this.height,
    required id,
    required author,
    required url,
    required downloadUrl,
  }) : super(id: id, author: author, url: url, downloadUrl: downloadUrl);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      author: json['author'],
      url: json['url'],
      downloadUrl: json['download_url'],
      width: json['width'],
      height: json['height'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'url': url,
      'download_url': downloadUrl,
      'width': width,
      'height': height,
    };
  }

  static String encode(List<PostModel> posts) => json.encode(
        posts.map<Map<String, dynamic>>((post) => post.toJson()).toList(),
      );

  static List<PostModel> decode(String posts) => (json.decode(posts) as List)
      .map<PostModel>((item) => PostModel.fromJson(item))
      .toList();
}

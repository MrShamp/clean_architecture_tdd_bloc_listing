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
      downloadUrl: json['downloadUrl'],
      width: json['width'],
      height: json['height'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "author": author,
      "url": url,
      "download_url": downloadUrl,
      "width": width,
      "height": height,
    };
  }
}

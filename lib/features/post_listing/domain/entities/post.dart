import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.author,
    required this.url,
    required this.downloadUrl,
  });

  final String id;
  final String author;
  final String url;
  final String downloadUrl;

  @override
  List<Object?> get props => [id, author];
}

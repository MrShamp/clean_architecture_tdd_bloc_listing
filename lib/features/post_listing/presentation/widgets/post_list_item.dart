import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.id}', style: textTheme.caption),
        title: Text(post.id),
        isThreeLine: true,
        subtitle: Text(post.author),
        dense: true,
      ),
    );
  }
}

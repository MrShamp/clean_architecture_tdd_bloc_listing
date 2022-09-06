import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/post_listing_bloc.dart';
import 'post_list.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts Image Listing')),
      body: BlocProvider(
        create: (_) => sl<PostListingBloc>()..add(const GetPostsListing()),
        child: const PostList(),
      ),
    );
  }
}

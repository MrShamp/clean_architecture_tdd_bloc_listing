part of 'post_listing_bloc.dart';

enum PostListingStatus {initial,loading, success, failure}

// abstract class PostListingState extends Equatable {
//   const PostListingState();
// }

class PostListingState extends Equatable {
  const PostListingState({
    this.status = PostListingStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  final PostListingStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final String errorMessage;

  PostListingState copyWith({
    PostListingStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PostListingState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage : errorMessage ?? this.errorMessage,
    );
  }
  @override
  List<Object> get props => [status, posts, hasReachedMax,errorMessage];
}

// class PostLoadFailure extends PostListingState {
//   final String errorMessage;

//   const PostLoadFailure(this.errorMessage);

//   @override
//   List<Object> get props => [errorMessage];
// }

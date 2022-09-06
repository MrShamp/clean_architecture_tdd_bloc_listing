part of 'post_listing_bloc.dart';

abstract class PostListingEvent extends Equatable {
  const PostListingEvent();

}
class GetPostsListing extends PostListingEvent {
  final String page;

  const GetPostsListing(this.page);
  
  @override
  List<Object?> get props => [page];
  
}

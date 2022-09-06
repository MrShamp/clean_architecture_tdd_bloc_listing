part of 'post_listing_bloc.dart';

abstract class PostListingEvent extends Equatable {
  const PostListingEvent();

}
class GetPostsListing extends PostListingEvent {
  const GetPostsListing();
  
  @override
  List<Object?> get props => [];
  
}

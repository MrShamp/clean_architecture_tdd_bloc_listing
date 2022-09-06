import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/errors/failure.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/usecases/usecase.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/usecases/get_post.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/entities/post.dart';

part 'post_listing_event.dart';
part 'post_listing_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostListingBloc extends Bloc<PostListingEvent, PostListingState> {
  final GetPosts getPosts;

  PostListingBloc({required this.getPosts}) : super(const PostListingState()) {
    on<GetPostsListing>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onPostFetched(
    GetPostsListing event,
    Emitter<PostListingState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostListingStatus.initial) {
        emit(
          state.copyWith(
            status: PostListingStatus.loading,
            posts: [],
            hasReachedMax: false,
          ),
        );
        final failureOrPosts = await getPosts(
          PaginatedParams(page: event.page, limit: PAGE_LIMIT),
        );
        return failureOrPosts.fold(
          (failure) {
            return emit(state.copyWith(
              status: PostListingStatus.failure,
              errorMessage: _mapFailureToMessage(failure),
            ));
          },
          (posts) {
            return emit(
              state.copyWith(
                status: PostListingStatus.success,
                posts: posts,
                hasReachedMax: false,
              ),
            );
          },
        );
      }
      final failureOrPosts = await getPosts(
        PaginatedParams(page: event.page, limit: PAGE_LIMIT),
      );
      failureOrPosts.fold(
        (failure) {
          return emit(state.copyWith(
            status: PostListingStatus.failure,
            errorMessage: _mapFailureToMessage(failure),
          ));
        },
        (posts) {
          posts.isEmpty
              ? emit(state.copyWith(hasReachedMax: true))
              : emit(state.copyWith(
                  status: PostListingStatus.success,
                  posts: List.of(state.posts)..addAll(posts),
                  hasReachedMax: false,
                ));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: PostListingStatus.failure));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}

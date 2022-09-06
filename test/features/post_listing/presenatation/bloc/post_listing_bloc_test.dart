import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/constants/constants.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/errors/failure.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/usecases/usecase.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/entities/post.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/usecases/get_post.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/presentation/bloc/post_listing_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockGetPosts extends Mock implements GetPosts {}

void main() {
  PostListingBloc? bloc;
  MockGetPosts? mockGetPosts;

  setUp(() {
    EquatableConfig.stringify = true;
    mockGetPosts = MockGetPosts();
    bloc = PostListingBloc(getPosts: mockGetPosts!);
  });

  group('GetPosts', () {
    const tPageNumber = '1';
    const tParams = PaginatedParams(page: tPageNumber, limit: PAGE_LIMIT);
    const tPosts = [
      Post(
        id: '0',
        author: 'Alejandro Escamilla',
        url: 'https://unsplash.com/photos/yC-Yzbqy7PY',
        downloadUrl: 'https://picsum.photos/id/0/5616/3744',
      ),
      Post(
        id: '1',
        author: 'Alejandro Escamilla',
        url: 'https://unsplash.com/photos/LNRyGwIJr5c',
        downloadUrl: 'https://picsum.photos/id/1/5616/3744',
      ),
    ];

    test(
      'should get data from the getPosts use case',
      () async {
        // arrange
        when(mockGetPosts!(tParams))
            .thenAnswer((_) async => const Right(tPosts));

        // act
        bloc?.add(const GetPostsListing());

        await untilCalled(mockGetPosts!(tParams));

        // assert
        verify(mockGetPosts!(tParams));
      },
    );

    blocTest<PostListingBloc, PostListingState>(
      'emit [loading loaded] when data is gotten successfully',
      build: () {
        when(mockGetPosts!(tParams)).thenAnswer((_) async => const Right(tPosts));
        return bloc!;
      },
      act: (bloc) => bloc.add(const GetPostsListing()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const PostListingState(status: PostListingStatus.loading, posts: [], hasReachedMax: false),
        const PostListingState(status: PostListingStatus.success, posts: tPosts, hasReachedMax: false),
      ],
    );

    blocTest<PostListingBloc, PostListingState>(
      'emit [loading error] with proper message when data getting from remote is failed',
      build: () {
        when(mockGetPosts!(tParams)).thenAnswer((_) async => Left(ServerFailure()));
        return bloc!;
      },
      act: (bloc) => bloc.add(const GetPostsListing()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const PostListingState(status: PostListingStatus.loading, posts: [], hasReachedMax: false),
        const PostListingState(status: PostListingStatus.failure, posts: [], hasReachedMax: false, errorMessage: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<PostListingBloc, PostListingState>(
      'emit [loading error] with proper message when data getting from local is failed',
      build: () {
        when(mockGetPosts!(tParams)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc!;
      },
      act: (bloc) => bloc.add(const GetPostsListing()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const PostListingState(status: PostListingStatus.loading, posts: [], hasReachedMax: false),
        const PostListingState(status: PostListingStatus.failure, posts: [], hasReachedMax: false, errorMessage: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}

import 'package:clean_architecture_bloc_tdd_listing/core/errors/exceptions.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/errors/failure.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/network/network_info.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/usecases/usecase.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/datasources/posts_local_data_source.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/datasources/posts_remote_data_source.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/models/post_model.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/repositories/posts_repository_impl.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/entities/post.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements PostsRemoteDataSource {}

class MockLocalDataSource extends Mock implements PostsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  PostRepositoryImplementation? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = PostRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getPosts', () {
    const tPostParmas = PaginatedParams(page: 10, limit: 100);
    const tPostModels = [
      PostModel(
        id: '0',
        author: 'Alejandro Escamilla',
        url: 'https://unsplash.com/photos/yC-Yzbqy7PY',
        downloadUrl: 'https://picsum.photos/id/0/5616/3744',
        width: 5616,
        height: 3741,
      ),
      PostModel(
        id: '1',
        author: 'Alejandro Escamilla',
        url: 'https://unsplash.com/photos/LNRyGwIJr5c',
        downloadUrl: 'https://picsum.photos/id/1/5616/3744',
        width: 5616,
        height: 3741,
      ),
    ];
    const List<Post> tPosts = tPostModels;

    test('should check if the device is Online', () async {
      // arrange
      when(mockNetworkInfo?.isConnected).thenAnswer((_) async => true);
      // act
      repository?.getPosts(tPostParmas);
      // assert
      verify(mockNetworkInfo!.isConnected);
    });

    runTestsOnline( () {
      test(
          'should return remote data when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource?.getPosts(tPostParmas))
            .thenAnswer((_) async => tPostModels);
        // act
        final result = await repository!.getPosts(tPostParmas);
        // assert
        verify(mockRemoteDataSource?.getPosts(tPostParmas));
        expect(result, equals(const Right(tPosts)));
      });

      test(
          'should cache the data when call to remote data source is successfull',
          () async {
        // arrange
        when(mockRemoteDataSource?.getPosts(tPostParmas))
            .thenAnswer((_) async => tPostModels);
        // act
        await repository!.getPosts(tPostParmas);
        // assert
        verify(mockRemoteDataSource?.getPosts(tPostParmas));
        verify(mockLocalDataSource?.cachePosts(tPostModels));
      });

      test(
          'should return server failuer when call to remote data source is unsuccessfull',
          () async {
        // arrange
        when(mockRemoteDataSource?.getPosts(tPostParmas))
            .thenThrow(ServerException());
        // act
        final result = await repository!.getPosts(tPostParmas);
        // assert
        verify(mockRemoteDataSource?.getPosts(tPostParmas));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline( () {

      test('should return local cached when cached data is present', () async {
        // arrange
        when(mockLocalDataSource?.getLastSavedPosts())
            .thenAnswer((_) async => tPostModels);
        // act
        final result  = await repository!.getPosts(tPostParmas);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource?.getLastSavedPosts());
        expect(result, equals(const Right(tPosts)));
      });

      test('should return cache failure cached when no cached data is present', () async {
        // arrange
        when(mockLocalDataSource?.getLastSavedPosts()).thenThrow(CacheException());
        // act
        final result  = await repository!.getPosts(tPostParmas);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource?.getLastSavedPosts());
        expect(result, equals(Left(CacheFailure())));
      });

    });
  });
}

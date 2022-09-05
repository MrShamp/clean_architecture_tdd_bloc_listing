import 'package:clean_architecture_bloc_tdd_listing/core/constants/constants.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/errors/exceptions.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/datasources/posts_local_data_source.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  PostsLocalDataSourceImplementation? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PostsLocalDataSourceImplementation(
      sharedPreferences: mockSharedPreferences!,
    );
  });

  group('getLastSavedPosts', () {
    final tPostModels = json.decode(fixture('posts_cached.json')).map((x) => PostModel.fromJson(x));


    test(
      'should return Posts from SharedPreferences when there are in the cache',
      () async {
        // arrange
        when(mockSharedPreferences?.getString(CACHED_POSTS)).thenReturn(fixture('posts_cached.json'));
        // act
        final result = await dataSource?.getLastSavedPosts();
        // assert
        verify(mockSharedPreferences?.getString(CACHED_POSTS));
        expect(result, equals(tPostModels));
      },
    );
    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences?.getString(CACHED_POSTS)).thenReturn(null);
      // act
      final call = dataSource?.getLastSavedPosts;
      // assert
      expect(() => call!(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheCachedPosts', () {
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

    test('should call SharedPreferences to cache the data', () async {
      // act
      await dataSource?.cachePosts(tPostModels);
      // assert
      final expectedJsonString = tPostModels.map((e) => json.encode(e.toJson())).toList();
      verify(mockSharedPreferences?.setStringList(
        CACHED_POSTS,
        expectedJsonString,
      ));
    });
  });
}

import 'dart:convert';
import 'package:clean_architecture_bloc_tdd_listing/core/constants/constants.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/errors/exceptions.dart';
import 'package:clean_architecture_bloc_tdd_listing/core/usecases/usecase.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/datasources/posts_remote_data_source.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  PostsRemoteDataSourceImplementation? dataSource;
  MockHttpClient? mockHttpClient;
  
  final tPostModels = (json.decode(fixture('posts_cached.json')).map((x) => PostModel.fromJson(x))).toList();

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = PostsRemoteDataSourceImplementation(client: mockHttpClient!);
  });
  void setUpMockHttpClientSuccess200(PaginatedParams tPostParmas) {
    final fullURL =
        Uri.parse(BASE_URL).replace(queryParameters: tPostParmas.toJson()).toString();
    when(mockHttpClient?.get(
      Uri.parse(fullURL),
      headers: {'Content-Type': 'application/json'},
    )).thenAnswer(
      (_) async => http.Response(fixture('posts_cached.json'), 200), // we need list to perform
    );
  }

  void setUpMockHttpClientFailure404(PaginatedParams tPostParmas) {
    final fullURL =
        Uri.parse(BASE_URL).replace(queryParameters: tPostParmas.toJson());
    when(mockHttpClient?.get(
      fullURL,
      headers: {'Content-Type': 'application/json'},
    )).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getPosts', () {
    const tPostParmas = PaginatedParams(page: '1', limit: '100');

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () {
        //arrange
        final fullURL =
        Uri.parse(BASE_URL).replace(queryParameters: tPostParmas.toJson());
        setUpMockHttpClientSuccess200(tPostParmas);
        // act
        dataSource?.getPosts(tPostParmas);
        // assert
        verify(mockHttpClient?.get(
          fullURL,
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        
        setUpMockHttpClientSuccess200(tPostParmas);
        // act
        final result = await dataSource?.getPosts(tPostParmas);
        // assert
        expect(result, equals(tPostModels));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404(tPostParmas);
        // act
        final call = dataSource?.getPosts;
        // assert
        expect(() => call!(tPostParmas),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}

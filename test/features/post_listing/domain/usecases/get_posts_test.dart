import 'package:clean_architecture_bloc_tdd_listing/core/usecases/usecase.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/entities/post.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/repositories/posts_repository.dart';
import 'package:clean_architecture_bloc_tdd_listing/features/post_listing/domain/usecases/get_post.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  GetPosts? usecase;
  MockPostsRepository? mockPostRepository;
  setUp(() {
    mockPostRepository = MockPostsRepository();
    usecase = GetPosts(mockPostRepository!);
  });
  const tParams= PaginatedParams(page: '10', limit: '10');
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
    'Should get posts from the repository',
    () async {
      // arrange
      when(mockPostRepository?.getPosts(tParams.page))
          .thenAnswer((_) async => const Right(tPosts));
      // act
      final result = await usecase!(tParams);
      // assert
      expect(result, const Right(tPosts));
      verify(mockPostRepository!.getPosts(tParams.page));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}

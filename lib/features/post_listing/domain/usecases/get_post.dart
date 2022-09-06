import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetPosts implements Usecase<List<Post>, PaginatedParams> {
  final PostsRepository repository;

  GetPosts(this.repository);
  
  @override
  Future<Either<Failure, List<Post>>> call(PaginatedParams pageNumber) async{
    return await repository.getPosts(pageNumber.page);
  } 
}
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts implements Usecase<List<Post>, PaginatedParams> {
  final PostRepository repository;

  GetPosts(this.repository);
  
  @override
  Future<Either<Failure, List<Post>>> call(PaginatedParams params) async{
    return await repository.getPost();
  }
  
}
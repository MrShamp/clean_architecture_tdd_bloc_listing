import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';

abstract class PostsRepository{
  Future<Either<Failure,List<Post>>> getPosts(PaginatedParams params);
}
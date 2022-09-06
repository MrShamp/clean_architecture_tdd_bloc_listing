import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

abstract class PostsRepository{
  Future<Either<Failure,List<Post>>> getPosts(String pageNumber);
}
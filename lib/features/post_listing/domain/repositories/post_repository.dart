import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

abstract class PostRepository{
  Future<Either<Failure,List<Post>>> getPost();
}
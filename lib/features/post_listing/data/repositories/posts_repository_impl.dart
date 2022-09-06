import 'package:clean_architecture_bloc_tdd_listing/core/constants/constants.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_data_source.dart';
import '../datasources/posts_remote_data_source.dart';

class PostRepositoryImplementation implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImplementation(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Post>>> getPosts(String pageNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final params = PaginatedParams(page: pageNumber, limit: PAGE_LIMIT);
        final result = await remoteDataSource.getPosts(params);
        localDataSource.cachePosts(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPostModels = await localDataSource.getLastSavedPosts();
        return Right(localPostModels);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

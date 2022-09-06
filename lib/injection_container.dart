import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/post_listing/data/datasources/posts_local_data_source.dart';
import 'features/post_listing/data/datasources/posts_remote_data_source.dart';
import 'features/post_listing/data/repositories/posts_repository_impl.dart';
import 'features/post_listing/domain/repositories/posts_repository.dart';
import 'features/post_listing/domain/usecases/get_post.dart';
import 'features/post_listing/presentation/bloc/post_listing_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features : Post Listing
  //Bloc
  sl.registerFactory<PostListingBloc>(
    () => PostListingBloc(
      getPosts: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetPosts>(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostsRepository>(
    () => PostRepositoryImplementation(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImplementation(client: sl()),
  );

  sl.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImplementation(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Client>(() => http.Client());
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
}

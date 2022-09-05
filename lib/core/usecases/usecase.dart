import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure,Type>> call(Params params); // We can proff here params consistency
}

class PaginatedParams extends Equatable {
  final String page;
  final String limit;

  const PaginatedParams({required this.page, required this.limit});

  @override
  List<Object?> get props => [page,limit];
  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "limit": limit,
    };
  }
}
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:tdd/core/error/Exceptions.dart';
import 'package:tdd/features/number_trivia/data/models/NumberTriviaModel.dart';

import '../../../../core/error/Faliure.dart';
import '../../../../core/platform/NetworkInfo.dart';
import '../../domain/entities/NumberTrivia.dart';
import '../../domain/repos/NumberTriviaRepo.dart';
import '../datasources/NumberTriviaLocalDataSource.dart';
import '../datasources/NumberTriviaRemoteDataSource.dart';

typedef Future<NumberTriviaModel> _ConcereteOrRandom();

class NumberTriviaRepoImpl implements NumberTriviaRepo {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepoImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Faliure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
      return await _getTrivia((){
        return remoteDataSource.getConcreteNumberTrivia(number);
      });
    // if (await networkInfo.isConnected) {
    //   try {
    //     final NumberTriviaModel finalNumberTriviaModel =
    //         await remoteDataSource.getConcreteNumberTrivia(number);
    //     await localDataSource.cacheNumberTrivia(finalNumberTriviaModel);
    //     return Right(finalNumberTriviaModel);
    //   } on ServerException {
    //     return Left(ServerFaliure());
    //   }
    // } else {
    //   try {
    //     final NumberTriviaModel finalNumberTriviaModel =
    //         await localDataSource.getLastTrivia();
    //     return Right(finalNumberTriviaModel);
    //   } on CacheException {
    //     return Left(CacheFaliure());
    //   }
    // }
  }

  @override
  Future<Either<Faliure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
    // if (await networkInfo.isConnected) {
    //   try {
    //     final NumberTriviaModel finalNumberTriviaModel =
    //         await remoteDataSource.getRandomNumberTrivia();
    //     await localDataSource.cacheNumberTrivia(finalNumberTriviaModel);
    //     return Right(finalNumberTriviaModel);
    //   } on ServerException {
    //     return (Left(ServerFaliure()));
    //   }
    // } else {
    //   try {
    //     final NumberTriviaModel finalNumberTriviaModel =
    //         await localDataSource.getLastTrivia();
    //     return Right(finalNumberTriviaModel);
    //   } on CacheException {
    //     return (Left(CacheFaliure()));
    //   }
    // }
  }

  Future<Either<Faliure, NumberTrivia>> _getTrivia(
     _ConcereteOrRandom getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final finalNumberTriviaModel = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(finalNumberTriviaModel);
        return Right(finalNumberTriviaModel);
      } on ServerException {
        return (Left(ServerFaliure()));
      }
    } else {
      try {
        final NumberTriviaModel finalNumberTriviaModel =
            await localDataSource.getLastTrivia();
        return Right(finalNumberTriviaModel);
      } on CacheException {
        return (Left(CacheFaliure()));
      }
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/Faliure.dart';
import '../entities/NumberTrivia.dart';

abstract class NumberTriviaRepo {
  Future<Either<Faliure,NumberTrivia>> getConcreteNumberTrivia (int number);
  Future<Either<Faliure,NumberTrivia>> getRandomNumberTrivia();
}
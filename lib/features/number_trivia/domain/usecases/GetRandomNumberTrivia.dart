import 'package:dartz/dartz.dart';
import '../../../../core/error/Faliure.dart';
import '../../../../core/usecase/UseCase.dart';
import '../entities/NumberTrivia.dart';
import '../repos/NumberTriviaRepo.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia,NoParams>{
  NumberTriviaRepo repo;

  GetRandomNumberTrivia(this.repo);

  Future<Either<Faliure,NumberTrivia>> call(NoParams params) async{
    return await this.repo.getRandomNumberTrivia();
  }
}
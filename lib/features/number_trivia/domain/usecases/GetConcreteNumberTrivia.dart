import 'package:dartz/dartz.dart';
import '../../../../core/error/Faliure.dart';
import '../../../../core/usecase/UseCase.dart';
import '../entities/NumberTrivia.dart';
import '../repos/NumberTriviaRepo.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia,int> {
  NumberTriviaRepo repo;

  GetConcreteNumberTrivia(this.repo);

  @override
  Future<Either<Faliure, NumberTrivia>> call(int number) async {
    return await this.repo.getConcreteNumberTrivia(number);
  }
}

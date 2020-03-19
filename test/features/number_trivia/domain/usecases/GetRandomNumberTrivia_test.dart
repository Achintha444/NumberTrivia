import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/core/usecase/UseCase.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:tdd/features/number_trivia/domain/repos/NumberTriviaRepo.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepo mockNumberTriviaRepo;

  setUp(() {
    mockNumberTriviaRepo = MockNumberTriviaRepo();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepo);
  });

  //final int tNumber = 1;
  final tNUmberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get a random number from the repo getRandomNumberTrivia()',
    () async {
      //arrange
      when(mockNumberTriviaRepo.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNUmberTrivia));
      
      //act
      final result = await usecase(NoParams());
      
      //assert
      expect(result, Right(tNUmberTrivia));
      verify(mockNumberTriviaRepo.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepo);
    },
  );
}

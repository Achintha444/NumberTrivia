import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:tdd/features/number_trivia/domain/repos/NumberTriviaRepo.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';

class MockNumberTriviaRepo extends Mock implements NumberTriviaRepo {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepo mockNumberTriviaRepo;

  setUp(() {
    mockNumberTriviaRepo = MockNumberTriviaRepo();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepo);
  });

  final int tNumber = 1;
  final tNUmberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get the number from the repo getConcreteNumberTrivia()',
    () async {
      //arrange
      when(mockNumberTriviaRepo.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNUmberTrivia));
      
      //act
      final result = await usecase(tNumber);
      
      //assert
      expect(result, Right(tNUmberTrivia));
      verify(mockNumberTriviaRepo.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepo);
    },
  );
}

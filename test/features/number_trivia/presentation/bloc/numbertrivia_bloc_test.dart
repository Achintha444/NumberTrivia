import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix1;
import 'package:mockito/mockito.dart';
import 'package:tdd/core/error/Faliure.dart';
import 'package:tdd/core/usecase/UseCase.dart';
import 'package:tdd/core/util/InputConverter.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/numbertrivia_bloc.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/numbertrivia_bloc.dart'
    as prefix0;

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

main() {
  NumbertriviaBloc numbertriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = new MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = new MockGetRandomNumberTrivia();
    mockInputConverter = new MockInputConverter();
    numbertriviaBloc = new NumbertriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    'initialState()',
    () async {
      //act
      final result = numbertriviaBloc.initialState;
      //assert
      expect(result, Empty());
    },
  );

  group(
    'GetConcreteNumberTrivia',
    () {
      final tNumberString = '1';
      final tNumber = 1;
      final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

      void setUpMockInputConverterSuccess() =>
          when(mockInputConverter.stringToUnsignedInt(any))
              .thenReturn(Right(tNumber));

      test(
        'should call the InputConverter to validate and convert the string to unsigned int',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          //act
          numbertriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInt(any));
          //assert
          verify(mockInputConverter.stringToUnsignedInt(tNumberString));
        },
      );

      test(
        'should emit [Error] when the input is invalid ',
        () async {
          //arrange
          when(mockInputConverter.stringToUnsignedInt(any))
              .thenReturn(Left(InvalidInputFaliure()));
          //act
          numbertriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          //assert
          expectLater(
            numbertriviaBloc.state,
            emitsInOrder(
              [
                Empty(),
                Error(message: INVALID_INPUT_FALIURE_MESSAGE),
              ],
            ),
          );
        },
      );

      test(
        'should get data from the GetConcreteNumberTrivia ',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          numbertriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          //assert
          verify(mockGetConcreteNumberTrivia(tNumber));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          numbertriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          //assert
          final expected = [
            Empty(),
            Loading(),
            Loaded(numberTrivia: tNumberTrivia)
          ];
          expectLater(numbertriviaBloc.state, emitsInOrder(expected));
        },
      );

      test(
        'should emit [Loading, Error] when data is getting data falied',
        () async {
          //arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFaliure()));
          //act
          numbertriviaBloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
          //assert
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FALIURE_MESSAGE)
          ];
          expectLater(numbertriviaBloc.state, emitsInOrder(expected));
        },
      );
    },
  );

  group(
    'GetRandomNumberTrivia',
    () {
      final tNumberTrivia = NumberTrivia(number: 1, text: 'Test');

      test(
        'should get data from the GetRandomNumberTrivia ',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          numbertriviaBloc.dispatch(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));
          //assert
          verify(mockGetRandomNumberTrivia(any));
        },
      );

      test(
        'should emit [Loading, Loaded] when data is gotten successfully',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          //act
          numbertriviaBloc.dispatch(GetTriviaForRandomNumber());
          //assert
          final expected = [
            Empty(),
            Loading(),
            Loaded(numberTrivia: tNumberTrivia)
          ];
          expectLater(numbertriviaBloc.state, emitsInOrder(expected));
        },
      );

      test(
        'should emit [Loading, Error] when data is getting data falied',
        () async {
          //arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFaliure()));
          //act
          numbertriviaBloc.dispatch(GetTriviaForRandomNumber());
          //assert
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FALIURE_MESSAGE)
          ];
          expectLater(numbertriviaBloc.state, emitsInOrder(expected));
        },
      );
    },
  );
}

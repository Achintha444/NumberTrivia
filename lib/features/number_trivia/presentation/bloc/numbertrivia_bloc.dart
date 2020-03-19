import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tdd/core/error/Faliure.dart';
import 'package:tdd/core/usecase/UseCase.dart';
import 'package:tdd/core/util/InputConverter.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:tdd/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';

import '../../domain/entities/NumberTrivia.dart';

part 'numbertrivia_event.dart';
part 'numbertrivia_state.dart';

const String SERVER_FALIURE_MESSAGE = 'Server Faliure';
const String CACHE_FALIURE_MESSAGE = 'Cache Faliure';
const String INVALID_INPUT_FALIURE_MESSAGE = 'Invalid Input Faliure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected Error';

class NumbertriviaBloc extends Bloc<NumbertriviaEvent, NumbertriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumbertriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter});

  @override
  NumbertriviaState get initialState => Empty();

  @override
  Stream<NumbertriviaState> mapEventToState(
    NumbertriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);

      yield* inputEither.fold((faliure) async* {
        yield Error(message: INVALID_INPUT_FALIURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final faliureOrTrivia = await getConcreteNumberTrivia(integer);
        yield* _eitherFaliureOrTriviaFold(faliureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final faliureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherFaliureOrTriviaFold(faliureOrTrivia);
    }
  }

  Stream<NumbertriviaState> _eitherFaliureOrTriviaFold(
      Either<Faliure, NumberTrivia> faliureOrTrivia) async* {
    yield faliureOrTrivia.fold(
        (faliure) => Error(message: _mapFaliureToMessage(faliure)),
        (numberTriva) => Loaded(numberTrivia: numberTriva));
  }

  String _mapFaliureToMessage(Faliure faliure) {
    switch (faliure.runtimeType) {
      case ServerFaliure:
        return SERVER_FALIURE_MESSAGE;

      case CacheFaliure:
        return CACHE_FALIURE_MESSAGE;

      default:
        return UNEXPECTED_ERROR_MESSAGE;
    }
  }
}

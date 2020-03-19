part of 'numbertrivia_bloc.dart';

abstract class NumbertriviaEvent extends Equatable {
  NumbertriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumbertriviaEvent{
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);

}

class GetTriviaForRandomNumber extends NumbertriviaEvent{}
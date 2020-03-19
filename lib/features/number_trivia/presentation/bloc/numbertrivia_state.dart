part of 'numbertrivia_bloc.dart';

abstract class NumbertriviaState extends Equatable {
  NumbertriviaState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NumbertriviaState {}

class Loading extends NumbertriviaState {}

class Loaded extends NumbertriviaState {

  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia}): super([numberTrivia]);

}

class Error extends NumbertriviaState {

  final String message;

  Error({@required this.message}): super([message]);

}

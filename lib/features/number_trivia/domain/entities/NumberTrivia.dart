import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class NumberTrivia extends Equatable {
  String text;
  int number;

  NumberTrivia({@required String text, @required int number}) : super([text, number]) {
    this.text = text;
    this.number = number;
  }

  String get getText {
    return this.text;
  }

  int get getNumber{
    return this.number;
  }
}

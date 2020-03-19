import 'package:flutter/widgets.dart';

import '../../domain/entities/NumberTrivia.dart';

class NumberTriviaModel extends NumberTrivia {
  String text;
  int number;
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'], number: (json['number'] as num).toInt());
  }

  Map<String, dynamic> toJson() {
    return {
      'text': super.getText,
      'number': super.getNumber,
    };
  }
}

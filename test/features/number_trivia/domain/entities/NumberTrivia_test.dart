import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';

void main() {
  final String text = 'This is a test';
  final int number = 1;

  final tNumberTrivia = NumberTrivia(text: text, number: number);

  test(
    'should be return the same text provided getText()',
    () async {
      //act
      final result = tNumberTrivia.getText;
      //assert
      expect(result,text);
    },
  );

  test(
    'should be return the same number provided getNumber()',
    () async {
      //act
      final result = tNumberTrivia.getNumber;
      //assert
      expect(result,number);
    },
  );
}

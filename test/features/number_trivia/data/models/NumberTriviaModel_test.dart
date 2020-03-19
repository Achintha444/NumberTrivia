import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';

import '../../../../Fixtures/FixtureReader.dart';

void main() {
  final tNumberTriviaModel =
      NumberTriviaModel(text: 'This is a test', number: 1);

  test(
    'should be a subclass of Numbertriva entity',
    () async {
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson()', () {
    test(
      'should return a valid model when the JSON number is an int',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixtureReader('trivia.json'));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return a valid model when the JSON number is a double',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixtureReader('triviaDouble.json'));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson()', () {
    test(
      'should return a JSON map containinf the proper data',
      () async {
        //act
        final result = tNumberTriviaModel.toJson();
        //assert
        final expectedMap = {'text': 'This is a test', 'number': 1};
        expect(result, expectedMap);
      },
    );
  });
}

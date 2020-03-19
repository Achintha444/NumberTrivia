import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/error/Faliure.dart';
import 'package:tdd/core/util/InputConverter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = new InputConverter();
  });

  group('stringToUnsignedInt()', () {
    test(
      'should return an int when string represents an unsigned int ',
      () async {
        //arrange
        final str = '123';
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Right(123));
      },
    );

    test(
      'should return InvalidInputFaliure when the String is not an int',
      () async {
        //arrange
        final str = 'abc';
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Left(InvalidInputFaliure()));
      },
    );

    test(
      'should return InvalidInputFaliure when the String is not an int',
      () async {
        //arrange
        final str = '-123';
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Left(InvalidInputFaliure()));
      },
    );
  });
}

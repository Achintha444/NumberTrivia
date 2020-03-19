import 'package:dartz/dartz.dart';
import '../error/Faliure.dart';

class InputConverter {
  Either<Faliure, int> stringToUnsignedInt(String str) {
    try {
      final response = int.parse(str);
      if (response < 0) throw FormatException();
      return Right(response);
    } on FormatException {
      return Left(InvalidInputFaliure());
    }
  }
}

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/error/Exceptions.dart';

import '../models/NumberTriviaModel.dart';

abstract class NumberTriviaLocalDataSource {
  /// Throws a [CacheException] for all error codes.
  Future<NumberTriviaModel> getLastTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastTrivia() {
    final String jsonNumberTriviaModelString =
        sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonNumberTriviaModelString != null) {
      return Future.value(
          NumberTriviaModel.fromJson(json.decode(jsonNumberTriviaModelString)));
    } else {
      //There is an error in throwing this error!
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaCache.toJson()));
  }
}

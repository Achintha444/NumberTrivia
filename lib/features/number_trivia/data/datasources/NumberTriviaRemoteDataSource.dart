import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/core/error/Exceptions.dart';

import '../models/NumberTriviaModel.dart';

abstract class NumberTriviaRemoteDataSource {
  //Here is the documentation of Flutter

  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/{random} endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({@required this.httpClient});

  Future<NumberTriviaModel> _getNumberTriviaIfClause(
      http.Response response) async {
    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await httpClient.get('http://numbersapi.com/$number',
        headers: {'Content-Type': 'application/json'});
    return await _getNumberTriviaIfClause(response);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final response = await httpClient.get('http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'});
    return await _getNumberTriviaIfClause(response);
  }
}

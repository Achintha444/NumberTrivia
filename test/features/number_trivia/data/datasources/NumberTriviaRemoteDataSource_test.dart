import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/error/Exceptions.dart';
import 'package:tdd/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:tdd/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';

import '../../../../fixtures/FixtureReader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = new MockHttpClient();
    remoteDataSourceImpl =
        new NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void mockHttpClientResponse200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixtureReader('trivia.json'), 200));
  }

  void mockHttpClientResponse404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixtureReader('trivia.json'), 404));
  }

  group('getConcreteNumberTrivia()', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtureReader('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        mockHttpClientResponse200();
        //act
        remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        //arrange
        mockHttpClientResponse200();
        //act
        final result =
            await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return ServerException when the response code is 404',
      () async {
        //arrange
        mockHttpClientResponse404();
        //act
        final call = remoteDataSourceImpl.getConcreteNumberTrivia; //assert
        expect(() => call(tNumber), throwsException);
      },
    );
  });

  group('getRandomTrivia()', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtureReader('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        mockHttpClientResponse200();
        //act
        remoteDataSourceImpl.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get('http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      () async {
        //arrange
        mockHttpClientResponse200();
        //act
        final result =
            await remoteDataSourceImpl.getRandomNumberTrivia();
        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return ServerException when the response code is 404',
      () async {
        //arrange
        mockHttpClientResponse404();
        //act
        final call = remoteDataSourceImpl.getRandomNumberTrivia; //assert
        expect(() => call(), throwsException);
      },
    );
  });
}

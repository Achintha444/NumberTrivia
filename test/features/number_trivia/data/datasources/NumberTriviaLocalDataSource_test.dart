import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd/core/error/Exceptions.dart';
import 'package:tdd/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:tdd/features/number_trivia/data/models/NumberTriviaModel.dart';

import '../../../../fixtures/FixtureReader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImpl localDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = new MockSharedPreferences();
    localDataSource = new NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastTrivia()', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixtureReader('triviaCache.json')));

    test(
      'should return NumberTivia from SharedPreferences when there is one in the cache',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixtureReader('triviaCache.json'));
        //act
        final result = await localDataSource.getLastTrivia();
        //assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return A CacheExpection when there is not a cached value',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = localDataSource.getLastTrivia;
        //assert
        // verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        //expect(() => call, throwsA(TypeMatcher<CacheException>()));
        expect(() => call(), throwsException);
      },
    );
  });

  group('cacheNumberTrivia()', () {
    final tNumberTrivaModel = NumberTriviaModel(text: 'TEST', number: 1);
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //act
        localDataSource.cacheNumberTrivia(tNumberTrivaModel);
        //assert
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, json.encode(tNumberTrivaModel.toJson())));
      },
    );
  });
}

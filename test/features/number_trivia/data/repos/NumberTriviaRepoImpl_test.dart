import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd/core/error/Exceptions.dart';
import 'package:tdd/core/error/Faliure.dart';
import 'package:tdd/core/platform/NetworkInfo.dart';
import 'package:tdd/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:tdd/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:tdd/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:tdd/features/number_trivia/data/repos/NumberTriviaRepoImpl.dart';
import 'package:tdd/features/number_trivia/domain/entities/NumberTrivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepoImpl repoImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = new MockRemoteDataSource();
    mockLocalDataSource = new MockLocalDataSource();
    mockNetworkInfo = new MockNetworkInfo();
    repoImpl = new NumberTriviaRepoImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void groupTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void groupTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia()', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        new NumberTriviaModel(text: 'This is a test', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repoImpl.getConcreteNumberTrivia(1);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    groupTestOnline(() {
      test(
        'should return remote data',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should cache remote data',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return ServerFaliure when the remote server is offline/not working',
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFaliure()));
        },
      );
    });

    groupTestOffline(() {
      test(
        'should return local data',
        () async {
          //arrange
          when(mockLocalDataSource.getLastTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'should return CacheFaliure when there is no cache',
        () async {
          //arrange
          when(mockLocalDataSource.getLastTrivia()).thenThrow(CacheException());
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Left(CacheFaliure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia()', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        new NumberTriviaModel(text: 'This is a test', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repoImpl.getRandomNumberTrivia();
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    groupTestOnline(() {
      test(
        'should return remote random data',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repoImpl.getRandomNumberTrivia();
          //assert
          expect(result, Right(tNumberTriviaModel));
          verify(mockRemoteDataSource.getRandomNumberTrivia());
        },
      );
      test(
        'should cache the remote random data',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          await repoImpl.getRandomNumberTrivia();
          //assert
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          verify(mockRemoteDataSource.getRandomNumberTrivia());
        },
      );
      test(
        'should return ServerFaliure when the remote server is offline/not working',
        () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //act
          final result = await repoImpl.getRandomNumberTrivia();
          //assert
          expect(result, Left(ServerFaliure()));
        },
      );
    });

    groupTestOffline(() {
      test(
        'should return local data',
        () async {
          //arrange
          when(mockLocalDataSource.getLastTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'should return CacheFaliure when there is no cache',
        () async {
          //arrange
          when(mockLocalDataSource.getLastTrivia()).thenThrow(CacheException());
          //act
          final result = await repoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Left(CacheFaliure()));
        },
      );
    });
  });
}

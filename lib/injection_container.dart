import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/NetworkInfo.dart';
import 'core/util/InputConverter.dart';
import 'features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'features/number_trivia/data/repos/NumberTriviaRepoImpl.dart';
import 'features/number_trivia/domain/repos/NumberTriviaRepo.dart';
import 'features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'features/number_trivia/presentation/bloc/numbertrivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Triva

  //* Bloc
   //  Never put Bloc classes as Singletons!!!
  sl.registerFactory(
    () => NumbertriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  //! UseCases
  //LazySingleton is only initanted only when they are called
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //* Repository
  sl. registerLazySingleton<NumberTriviaRepo>(
    () => NumberTriviaRepoImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //* DataSource
  sl. registerLazySingleton<NumberTriviaLocalDataSource>(() =>NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() =>NumberTriviaRemoteDataSourceImpl(httpClient:  sl()));


  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External Libraries
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(()  => sharedPreferences);
  sl.registerLazySingleton(()=> http.Client());
  sl.registerLazySingleton(()=> DataConnectionChecker());
}

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/domain/usecases/get_current_page.dart';
import 'package:untitled/domain/usecases/save_current_page.dart';
import '../../data/datasources/local/pokemon_local_datasource.dart';
import '../../data/datasources/remote/pokemon_remote_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_scroll_position.dart';
import '../../domain/usecases/save_scroll_position.dart';
import '../../presentation/bloc/pokemon_bloc.dart';
import '../network/network_info.dart';

final GetIt getIt = GetIt.instance;
final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<http.Client>(() => http.Client());

  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(client: getIt()),
  );

  getIt.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  sl.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => SaveScrollPosition(sl()));
  sl.registerLazySingleton(() => GetScrollPosition(sl()));
  sl.registerLazySingleton(() => GetAllPokemonsUsecase(sl()));
  sl.registerLazySingleton(() => SaveCurrentPage(sl()));
  sl.registerLazySingleton(() => GetCurrentPage(sl()));

  getIt.registerFactory<PokemonBloc>(
    () => PokemonBloc(
      getAllPokemons: getIt(),
      getScrollPosition: getIt(),
      saveScrollPosition: getIt(),
      saveCurrentPage: getIt(),
      getCurrentPage: getIt(),
    ),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  sl.registerLazySingleton(() => InternetConnectionChecker());
}

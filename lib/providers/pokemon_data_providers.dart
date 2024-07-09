import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_riverpod/Services/database_service.dart';
import 'package:pokemon_riverpod/Services/http_services.dart';
import 'package:pokemon_riverpod/models/pokemon.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpServices _httpServices = GetIt.instance.get<HttpServices>();
  Response? response = await _httpServices.get(url);
  if (response != null && response.data != null) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemonsProvider, List<String>>((ref) {
  return FavouritePokemonsProvider([]);
});

class FavouritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  String FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";

  FavouritePokemonsProvider(super._state) {
    _setUp();
  }

  Future<void> _setUp() async {
    List<String>? result =
        await _databaseService.getList(FAVOURITE_POKEMON_LIST_KEY);
    state = result ?? [];
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }

  void removeFavouritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }
}

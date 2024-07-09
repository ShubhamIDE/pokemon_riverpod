import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;
  PokemonListTile({required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    _favouritePokemonsProvider = ref.watch(favouritePokemonProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonProvider);

    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stacktrace) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.backDefault!),
              )
            : CircleAvatar(),
        title: Text(
          pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currently pokemon name is not available",
        ),
        subtitle: Text("Has ${pokemon?.moves?.length?.toString() ?? 0} moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favouritePokemons.contains(pokemonUrl)) {
              _favouritePokemonsProvider.removeFavouritePokemon(pokemonUrl);
            } else {
              _favouritePokemonsProvider.addFavouritePokemon(pokemonUrl);
            }
          },
          icon: Icon(
            _favouritePokemons.contains(pokemonUrl)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavouritePokemonsProvider _favouritePokemonsProvider;
  late List<String> _favouritePokemons;
  PokemonCard({required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    _favouritePokemonsProvider = ref.watch(favouritePokemonProvider.notifier);

    return pokemon.when(data: (data) {
      return card(context, false, data);
    }, error: (error, stacktrace) {
      return Text('Error: $error');
    }, loading: () {
      return card(context, true, null);
    });
  }

  Widget card(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).width * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).width * 0.02),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.name?.toLowerCase() ?? "Pokemon",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "#${pokemon?.id?.toString()}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
              child: CircleAvatar(
                backgroundImage: pokemon != null
                    ? NetworkImage(pokemon!.sprites!.frontDefault!)
                    : null,
                radius: MediaQuery.sizeOf(context).height * 0.05,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${pokemon?.moves?.length} Moves",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    _favouritePokemonsProvider
                        .removeFavouritePokemon(pokemonUrl);
                  },
                  icon: Icon(Icons.favorite, color: Colors.red),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

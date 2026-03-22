import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../services/api_service.dart';

class PokemonListScreen extends StatelessWidget {
  PokemonListScreen({super.key});

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon API'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: apiService.fetchPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay Pokémon disponibles'),
            );
          }

          final pokemons = snapshot.data!;

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];

              return ListTile(
                leading: Image.network(
                  pokemon.imageUrl,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.catching_pokemon);
                  },
                ),
                title: Text(
                  pokemon.name.toUpperCase(),
                ),
                subtitle: Text('ID: ${pokemon.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
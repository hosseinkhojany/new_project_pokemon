part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsEvent extends PokemonEvent {}

class LoadMorePokemonsEvent extends PokemonEvent {}

class LoadPreviousPokemonsEvent extends PokemonEvent {}

class SaveScrollPositionEvent extends PokemonEvent {
  final int page;
  final String pokemonName;

  const SaveScrollPositionEvent({required this.page, required this.pokemonName});

  @override
  List<Object> get props => [page, pokemonName];
}
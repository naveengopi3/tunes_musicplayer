part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteSongLoaded extends FavoriteState{
  final List<FavoriteModel> favSongs;

  FavoriteSongLoaded({required this.favSongs});
}

final class FavoriteSongPlaying extends FavoriteState{
  final int index;
  FavoriteSongPlaying({required this.index});
} 
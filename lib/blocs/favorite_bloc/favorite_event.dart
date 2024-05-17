part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}

class AddFavoriteSong extends FavoriteEvent{}

class PlayFavoriteSong extends FavoriteEvent{
  final int index;
  PlayFavoriteSong({required this.index});
}
class DeleteFavoriteSong extends FavoriteEvent {
  final int index;
  DeleteFavoriteSong({required this.index});
}
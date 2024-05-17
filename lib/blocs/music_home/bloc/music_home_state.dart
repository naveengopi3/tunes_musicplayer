part of 'music_home_bloc.dart';

@immutable
sealed class MusicHomeState {}

final class MusicHomeInitial extends MusicHomeState {}

class MusicHomeLoaded extends MusicHomeState {
  final List<AllSongs> songs;
  MusicHomeLoaded({required this.songs});
}

class MusicHomePlaying extends MusicHomeState {
  final int index;
  MusicHomePlaying({required this.index});
}

class MusicHomeError extends MusicHomeState {
  final String message;
  MusicHomeError({required this.message});
}

part of 'music_home_bloc.dart';

@immutable
sealed class MusicHomeEvent {}

class LoadSongs extends MusicHomeEvent {}

class PlaySong extends MusicHomeEvent {
  final int index;
  PlaySong({required this.index});
}

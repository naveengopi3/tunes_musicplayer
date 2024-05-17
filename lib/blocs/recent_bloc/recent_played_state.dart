

part of 'recent_played_bloc.dart';
class RecentPlayedState {
  List<RecentModel>recentSong;

  RecentPlayedState({required this.recentSong});
}

final class RecentPlayedInitial extends RecentPlayedState {
  RecentPlayedInitial():super(recentSong: []);
}

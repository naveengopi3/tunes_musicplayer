import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';

part 'recent_played_event.dart';
part 'recent_played_state.dart';

class RecentPlayedBloc extends Bloc<RecentPlayedEvent, RecentPlayedState> {
  RecentPlayedBloc() : super(RecentPlayedInitial()) {
    on<RecentSongsList>((event, emit) {
     List<RecentModel>recentBlocList = recentlyplayed.values.toList();
     emit(RecentPlayedState(recentSong: recentBlocList));
    });
  }
}

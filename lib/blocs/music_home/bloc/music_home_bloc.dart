import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/screens/splash_screen.dart';

part 'music_home_event.dart';
part 'music_home_state.dart';

class MusicHomeBloc extends Bloc<MusicHomeEvent, MusicHomeState> {
  MusicHomeBloc() : super(MusicHomeInitial()) {
    on<LoadSongs>((event, emit) async {
      try {
        final songs = await fetchSongs();
        emit(MusicHomeLoaded(songs: songs));
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<PlaySong>((event, emit) {
      try {
        _audioPlayer.open(
            Playlist(audios: convertAudio, startIndex: event.index),
            showNotification: true,
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
            loopMode: LoopMode.playlist);
        return MusicHomePlaying(index: event.index);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> convertAudio = [];
  Future<List<AllSongs>> fetchSongs() async {
    final List<AllSongs> songs = box.values.toList();

    convertAudio = songs
        .map((song) => Audio.file(song.songurl,
            metas: Metas(
                title: song.songname,
                artist: song.artists,
                id: song.id.toString())))
        .toList();
    return songs;
  }
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tunes_musicplayer/models/favorite_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddFavoriteSong>((event, emit) async {
      try {
        final favSongs = await addFavSongs();
        emit(FavoriteSongLoaded(favSongs: favSongs));
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<PlayFavoriteSong>((event, emit) {
      player.open(Playlist(audios: allSongs, startIndex: event.index),
          showNotification: true,
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
          loopMode: LoopMode.playlist);
    });
     on<DeleteFavoriteSong>((event, emit) async {
      try {
        await deleteFavSong(event.index);
        final favSongs = await addFavSongs();
        emit(FavoriteSongLoaded(favSongs: favSongs));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }


   final AssetsAudioPlayer player = AssetsAudioPlayer.withId('0');
  List<Audio> allSongs = [];
  Future<List<FavoriteModel>> addFavSongs() async {
    final favsongsDb = Hive.box<FavoriteModel>('favSongs').values.toList();

    for (var element in favsongsDb) {
      allSongs.add(Audio.file(element.favoriteSongurl.toString(),
          metas: Metas(
              artist: element.favoriteSongArtist,
              title: element.favoriteSongname,
              id: element.favoriteSongId.toString())));
    }
    return favsongsDb;
  }
  //------------------------------------------------
 Future<void> deleteFavSong(int index) async {
    final box = Hive.box<FavoriteModel>('favSongs');
    await box.deleteAt(index);
     
  }

}
// ignore_for_file: must_be_immutable

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/blocs/mp_bloc/mostplayed_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/favorite/add_to_fav.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/miniplayer/mini_player.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';
import 'package:tunes_musicplayer/playlist/add_from_home.dart';
import 'package:tunes_musicplayer/screens/splash_screen.dart';

class MostlyPlayed extends StatelessWidget {
   MostlyPlayed({
    super.key,
  });

  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");

  List<Audio> mpAudio = [];

  List<MostlyPlayedModel> mpSongs = [];

  List<AllSongs> fullSongsMp = box.values.toList();

  List<MostlyPlayedModel> mpSongsList = mostlyplayedSongs.values.toList();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MostplayedBloc()..add(MostlyScreenShow()),
      child: Scaffold(
        backgroundColor: CustomColors.black,
        appBar: AppBar(
          backgroundColor: CustomColors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: CustomColors.white,
            iconSize: 30,
          ),
          title: const Text(
            "Mostly Played",
            style: TextStyle(color: CustomColors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: BlocBuilder<MostplayedBloc, MostplayedState>(
                builder: (context, state) {
                  for (var oneSong in state.mpStateList) {
                    if (oneSong.songcount >= 3) {
                      mpSongs.remove(oneSong);
                      mpSongs.add(oneSong);
                    }
                  }
                  if (mpSongs.isEmpty) {
                    return Center(
                      child: Text(
                        "Nothing Played Yet",
                        style: TextStyle(color: CustomColors.white),
                      ),
                    );
                  } else {
                    List<MostlyPlayedModel> mpRevList =
                        mpSongs.reversed.toList();

                    for (var element in mpRevList) {
                      mpAudio.add(Audio.file(element.mostlysongurl,
                          metas: Metas(
                              title: element.mostlysongname,
                              artist: element.mostlyartistname,
                              id: element.mostlySongId.toString())));
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        RecentModel recentsong;
                        return ListTile(
                          onTap: () {
                            recentsong = RecentModel(
                                recentSongName: mpRevList[index].mostlysongname,
                                recentSongArtist:
                                    mpRevList[index].mostlyartistname,
                                recentSongDuration:
                                    mpRevList[index].mostlysongduration,
                                recentSongurl: mpRevList[index].mostlysongurl,
                                recentId: mpRevList[index].mostlySongId);

                            updateRecentPlayed(recentsong, index);

                            player.open(
                                Playlist(audios: mpAudio, startIndex: index),
                                showNotification: true,
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplug,
                                loopMode: LoopMode.playlist);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NowPlayingScreen(),
                              ),
                            );
                          },
                          leading: QueryArtworkWidget(
                            id: mpRevList[index].mostlySongId,
                            type: ArtworkType.AUDIO,
                            artworkQuality: FilterQuality.high,
                            quality: 100,
                            artworkBorder: BorderRadius.circular(30),
                            nullArtworkWidget: const CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage('assets/null-img.png'),
                            ),
                          ),
                          title: Text(
                            mpRevList[index].mostlysongname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: CustomColors.white),
                          ),
                          subtitle: Text(mpRevList[index].mostlyartistname,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(color: CustomColors.white)),
                          trailing: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0)),
                                  ),
                                  backgroundColor: Colors.grey,
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 130,
                                      width: 400,
                                      child: Column(
                                        children: [
                                          AddFromHome(songindex: index),
                                          const Divider(
                                            color: CustomColors.lightGrey,
                                          ),
                                          AddToFavorite(index: index),
                                          const Divider(
                                            color: CustomColors.lightGrey,
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: CustomColors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                            height: 0.1, color: CustomColors.darkGrey);
                      },
                      itemCount: mpRevList.length,
                    );
                  }
                },
              ))
            ],
          ),
        ),
        bottomSheet: const Miniplayer(),
      ),
    );
  }
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/blocs/recent_bloc/recent_played_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/favorite/add_to_fav.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/miniplayer/mini_player.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';
import 'package:tunes_musicplayer/playlist/add_from_home.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  List<Audio> rsongs = [];

  // @override
  // void initState() {
  //   List<RecentModel> recentdbsongs =
  //       recentlyplayed.values.toList().reversed.toList();

  //   for (var elements in recentdbsongs) {
  //     rsongs.add(Audio.file(elements.recentSongurl!,
  //         metas: Metas(
  //           title: elements.recentSongName,
  //           artist: elements.recentSongArtist,
  //           id: elements.recentId.toString(),
  //         )));
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecentPlayedBloc()..add(RecentSongsList()),
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
          ),
          title: const Text(
            "Recently played",
            style: TextStyle(color: CustomColors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: BlocBuilder<RecentPlayedBloc, RecentPlayedState>(
                builder: (context, state) {
                  rsongs.clear();
                  for(var element in state.recentSong){
                    rsongs.add(Audio.file(
                      element.recentSongurl,
                      metas: Metas(
                        id: element.recentId.toString(),
                        title: element.recentSongName,
                        artist: element.recentSongArtist,
                      )
                    ));

                  }
                  List<RecentModel> allrpsongs =
                        state.recentSong.reversed.toList();

                        if(allrpsongs.isEmpty){
                          return Center(
                            child: Text(
                              "Nothing Played Yet",style: TextStyle(color: CustomColors.white),
                            ),
                          );
                        }
                  return ListView.separated(
                          itemBuilder: (context, index) {
                            List<MostlyPlayedModel> allMostplayedsongs =
                                mostlyplayedSongs.values.toList();
                            MostlyPlayedModel mpsong =
                                allMostplayedsongs[index];
                                 //RecentModel recFullSong = allrpsongs[index];
                            return ListTile(
                              onTap: () {
                                final rsong = RecentModel(
                                    recentSongName:
                                        allrpsongs[index].recentSongName,
                                    recentSongArtist:
                                        allrpsongs[index].recentSongArtist,
                                    recentSongDuration:
                                        allrpsongs[index].recentSongDuration,
                                    recentSongurl: allrpsongs[index].recentSongurl,
                                    recentId: allrpsongs[index].recentId);
                                updateRecentPlayed(rsong, index);
                                updateMostlyPlayed(index, mpsong);

                                player.open(
                                    Playlist(audios: rsongs, startIndex: index),
                                    loopMode: LoopMode.playlist,
                                    showNotification: true,
                                    headPhoneStrategy:
                                        HeadPhoneStrategy.pauseOnUnplug);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const NowPlayingScreen()));
                              },
                              leading: QueryArtworkWidget(
                                id: allrpsongs[index].recentId,
                                type: ArtworkType.AUDIO,
                                artworkQuality: FilterQuality.high,
                                quality: 100,
                                nullArtworkWidget: const CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      AssetImage('assets/null-img.png'),
                                ),
                              ),
                              title: Text(
                                allrpsongs[index].recentSongName,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
                              subtitle: Text(
                                allrpsongs[index].recentSongArtist,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: CustomColors.white),
                              ),
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
                          itemCount: allrpsongs.length);
                },
              )
                  
                  
                   
            
            )
          ],
        )),
        bottomSheet: const Miniplayer(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/blocs/music_home/bloc/music_home_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/favorite/add_to_fav.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';
import 'package:tunes_musicplayer/playlist/add_from_home.dart';

class MusicHome extends StatelessWidget {
  MusicHome({super.key});

  final box = SongBox.getInstance();

  //List<Audio> convertAudio = [];
  // final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');

  // @override
  @override
  Widget build(BuildContext context) {
    // final mqheight = MediaQuery.of(context).size.height;
    // final mqwidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        create: (context) => MusicHomeBloc()..add(LoadSongs()),
        child: Scaffold(
            backgroundColor: CustomColors.black,
            body: BlocBuilder<MusicHomeBloc, MusicHomeState>(
              builder: (context, state) {
                if (state is MusicHomeInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MusicHomeLoaded) {
                  final songs = state.songs;

                  if (songs.isEmpty) {
                    return Center(
                      child: Text('No Songs Found'),
                    );
                  } 
                  List<MostlyPlayedModel> allMostplayedsongs =
                          mostlyplayedSongs.values.toList(); 
                  return ListView.separated(
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      

                      AllSongs songs = state.songs[index];
                      RecentModel recentsongs;
                      MostlyPlayedModel mPsongs = allMostplayedsongs[index];
                      return ListTile(
                          onTap: () {
                            recentsongs = RecentModel(
                              recentSongName: songs.songname!,
                              recentSongArtist: songs.artists!,
                              recentSongDuration: songs.duration!,
                              recentSongurl: songs.songurl,
                              recentId: songs.id,
                            );
                            updateRecentPlayed(recentsongs, index);
                            updateMostlyPlayed(index, mPsongs);

                            BlocProvider.of<MusicHomeBloc>(context)
                                .add(PlaySong(index: index));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const NowPlayingScreen()));
                          },
                          leading: QueryArtworkWidget(
                            id: songs.id,
                            type: ArtworkType.AUDIO,
                            artworkQuality: FilterQuality.high,
                            quality: 100,
                            artworkBorder: BorderRadius.circular(30),
                            nullArtworkWidget: const CircleAvatar(
                              radius: 26.3,
                              backgroundImage:
                                  AssetImage('assets/null-img.png'),
                            ),
                          ),
                          title: Text(
                            songs.songname!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: CustomColors.white),
                          ),
                          subtitle: Text(songs.artists!,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(color: CustomColors.white)),
                          trailing: SizedBox(
                            width: 56,
                            child: IconButton(
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
                                )),
                          ));
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 0.1,
                      color: CustomColors.darkGrey,
                    ),
                  );
                }
                return Container();
              },
            )));
  }
}

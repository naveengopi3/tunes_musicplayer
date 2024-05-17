import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';
import 'package:tunes_musicplayer/screens/splash_screen.dart';

class Miniplayer extends StatefulWidget {
  const Miniplayer({super.key});

  @override
  State<Miniplayer> createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> {
  final player = AssetsAudioPlayer.withId('0');
  late List<AllSongs> minisongs;

  @override
  void initState() {
    minisongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mqheight = MediaQuery.of(context).size.height;
    final mqwidth = MediaQuery.of(context).size.width;
    return PlayerBuilder.current(
        player: player,
        builder: (context, playing) {
          return Container(
              height: 76,
              width: mqwidth * 6,
              decoration: const BoxDecoration(
                color: CustomColors.darkGrey,
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 30,
                    blurStyle: BlurStyle.solid,
                  )
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NowPlayingScreen()));
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 11),
                          child: SizedBox(
                            height: mqheight * 0.079,
                            width: mqwidth * 0.17,
                            child: QueryArtworkWidget(
                              id: int.parse(playing.audio.audio.metas.id!),
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(80),
                              artworkQuality: FilterQuality.high,
                              nullArtworkWidget: const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage("assets/null-img.png"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70, 
                          width: 300 ,
                          child: ListTile(
                            title: Text(
                              player.getCurrentAudioTitle,
                              style: const TextStyle(
                                  color: CustomColors.white,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            subtitle: Text(
                              player.getCurrentAudioArtist,
                              style: const TextStyle(
                                  color: CustomColors.lightGrey,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  child:      PlayerBuilder.isPlaying(
                          player: player,
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: playing.index == 0 
                              ?(){}
                              :() async {

                                RecentModel precentsongs;

                                precentsongs = RecentModel(
                                 recentSongName: minisongs[playing.index-1].songname!, 
                                  recentSongArtist: minisongs[playing.index-1].artists!, 
                                  recentSongDuration: minisongs[playing.index-1].duration!, 
                                  recentSongurl: minisongs[playing.index-1].songurl,
                                   recentId: minisongs[playing.index-1].id
                                  );
                                  updateRecentPlayed(precentsongs, playing.index-1);
                                setState(() {});
                                await player.previous();

                                setState(() {});
                                if (isPlaying == false) {
                                  player.pause();
                                }
                              },
                              icon: const Icon(
                                Icons.skip_previous,
                                color: CustomColors.white,
                                size: 35,
                              ),
                            );
                          }),
                                ),
                                Container(
                                    height: mqheight * 0.08,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: CustomColors.purpleAccent
                                        ),
                                    child: PlayerBuilder.isPlaying(
                                        player: player,
                                        builder: (context, isPlaying) {
                                          return IconButton(
                                              onPressed: () {
                                                player.playOrPause();
                                              },
                                              icon: Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 35,
                                                color: CustomColors.white,
                                              ));
                                        })),
                                SizedBox(
                                  child:     PlayerBuilder.isPlaying(
                          player: player,
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: playing.index ==playing.playlist.audios.length-1
                              ?(){}
                              :() async {
                                
                                setState(() {});
                                await player.next();
                                setState(() {});
                                RecentModel nextrsongs;

                                nextrsongs = RecentModel(
                                  recentSongName: minisongs[playing.index+1].songname!, 
                                  recentSongArtist: minisongs[playing.index+1].artists!, 
                                  recentSongDuration: minisongs[playing.index+1].duration!, 
                                  recentSongurl: minisongs[playing.index+1].songurl,
                                   recentId: minisongs[playing.index+1].id
                                   );
                                   updateRecentPlayed(nextrsongs, playing.index+1);
                                  

                                if (isPlaying == false) {
                                  player.pause();
                                }
                              },
                              icon: playing.index ==
                                  playing.playlist.audios.length - 1
                              ? const Icon(
                                  Icons.skip_next_rounded,
                                   color: CustomColors.white,
                                  size: 35,
                                )
                              : const Icon(
                                  Icons.skip_next_rounded,
                                  color: CustomColors.white,
                                  size: 35,
                                ),
                            );
                          }),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
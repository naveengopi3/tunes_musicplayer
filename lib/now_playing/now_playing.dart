import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/favorite/now_playfav.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/playlist/add_from_np.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final player = AssetsAudioPlayer.withId('0');
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isRepeat = false;

  late List<AllSongs> dbSongs;

  final box = SongBox.getInstance();
  List<MostlyPlayedModel> mpsongs = mostlyplayedSongs.values.toList();

  @override
  void initState() {
    setState(() {});

    dbSongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mqWidth = MediaQuery.of(context).size.width;
    double mqHeight = MediaQuery.of(context).size.height;

    return PlayerBuilder.current(
        player: player,
        builder: (context, playing) {
          return Scaffold(
            backgroundColor: CustomColors.black,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 37,
                            color: CustomColors.white,
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: mqHeight * 0.1),
                        child: const Text(
                          'Now Playing',
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                      
                    ],
                  ),

                  //---------------------------------------Now Playing-----------------------------------------------
                  Padding(
                    padding: EdgeInsets.only(top: mqHeight * 0.1),
                    child: SizedBox(
                      height: mqHeight * 0.4,
                      width: mqWidth * 0.7,
                      child: QueryArtworkWidget(
                        id: int.parse(playing.audio.audio.metas.id!),
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.fill,
                        artworkBorder: BorderRadius.circular(0),
                        nullArtworkWidget: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              0), 
                          child: Image.asset(
                            'assets/null-img.png', 
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //------------------------------------image---------------------------------------------------------

                  Padding(
                    padding: const EdgeInsets.only(left: 40 ,right: 60,top: 60),
                    child: Row(
                      children: [
                        Column(
                        
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: mqHeight * 0.02),
                            SizedBox(
                              height: mqHeight * 0.03,
                              width: mqWidth * 0.70, 
                              child: Marquee(
                                  blankSpace: 100,
                                  velocity: 40,
                                  text: player.getCurrentAudioTitle,
                                  style: const TextStyle(
                                      color: CustomColors.white, fontSize: 17)),
                            ),
                            Align(
                               alignment: Alignment.centerLeft,
                              child: SizedBox(
                                  height: mqHeight * 0.04,
                                  width: mqWidth * 0.5,
                                  child: Text(
                                   player.getCurrentAudioArtist,
                                    style:
                                        const TextStyle(color: CustomColors.white,fontSize: 13),
                                  )),
                            ), 
                           
                          ],
                        ),
                        
                       
                      ],
                    ),
                  ),
                  
//-----------------------------------title&artist-----------------------------------------

                  Padding(
                    padding: const EdgeInsets.only(top: 10,),
                    child: SizedBox(
                        width: mqWidth * 0.8,
                        child: PlayerBuilder.realtimePlayingInfos(
                            player: player,
                            builder: (context, realtimePlayingInfos) {
                              final duration =
                                  realtimePlayingInfos.current!.audio.duration;

                              final position =
                                  realtimePlayingInfos.currentPosition;
                              return ProgressBar(
                                progress: position,
                                total: duration,
                                progressBarColor: CustomColors.white,
                                baseBarColor: CustomColors.darkGrey,
                                thumbColor: CustomColors.white,
                                barHeight: 3,
                                thumbRadius: 7,
                                bufferedBarColor: CustomColors.darkGrey,
                                timeLabelPadding: mqHeight * 0.005,
                                timeLabelTextStyle:
                                    const TextStyle(color: CustomColors.white),
                                onSeek: (duration) => player.seek(duration),
                              );
                            })),
                  ),
                  //-------------------------------------progressbar--------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                     player.builderCurrent(
                      builder: (context,playing){
                        return NowPlayingFav(index: dbSongs.indexWhere((element) => element.songname == playing.audio.audio.metas.title));
                      }
                      ), 
                      //-------------------------------------------------------------------------------------------------------
                      SizedBox(width: mqWidth * 0.05),
                      PlayerBuilder.isPlaying(
                          player: player,
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: playing.index == 0 
                              ?(){}
                              :() async {

                                RecentModel precentsongs;

                                precentsongs = RecentModel(
                                 recentSongName: dbSongs[playing.index-1].songname!, 
                                  recentSongArtist: dbSongs[playing.index-1].artists!, 
                                  recentSongDuration: dbSongs[playing.index-1].duration!, 
                                  recentSongurl: dbSongs[playing.index-1].songurl,
                                   recentId: dbSongs[playing.index-1].id
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
                      SizedBox(width: mqWidth * 0.05),
                      //-----------------------------------skipback-------------------------------------------------
                      Container(
                          height: mqHeight * 0.08,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.white),
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
                                    ));
                              })),
                      SizedBox(width: mqWidth * 0.05),
                      //---------------------------------------playbutton------------------------------------------------------------
                      PlayerBuilder.isPlaying(
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

                                MostlyPlayedModel mostPlayedsongs = mpsongs[playing.index];
                                nextrsongs = RecentModel(
                                  recentSongName: dbSongs[playing.index+1].songname!, 
                                  recentSongArtist: dbSongs[playing.index+1].artists!, 
                                  recentSongDuration: dbSongs[playing.index+1].duration!, 
                                  recentSongurl: dbSongs[playing.index+1].songurl,
                                   recentId: dbSongs[playing.index+1].id
                                   );
                                   updateRecentPlayed(nextrsongs, playing.index+1);
                                   updateMostlyPlayed(playing.index+1, mostPlayedsongs);

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
                      SizedBox(width: mqWidth * 0.05),
                      //----------------------------------------skipnext----------------------------------------------------
                      AddFromNowPlaying(songindex: playing.index)
                      //------------------------------------add playlist----------------------------------------------------------------
                    ], 
                  ),
                  SizedBox(
                    height: mqHeight * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ 
                        IconButton(
                          onPressed: (){
                           setState(() {
                             
                           });
                           player.toggleShuffle();
                          },
                           icon:player.isShuffling.value
                           ?const Icon(Icons.shuffle,color: CustomColors.purpleAccent,size: 30,)
                           :const Icon(Icons.shuffle,color: CustomColors.white,size: 30,)
                           ) ,
                           
                           IconButton(
                            onPressed:(){
                              if(isRepeat){
                                player.setLoopMode(LoopMode.none);
                                isRepeat = false;
                              }else{
                                player.setLoopMode(LoopMode.single);
                                isRepeat = true;
                              }
                              setState(() {
                                
                              });
                            },
                             icon:isRepeat
                             ?
                              const Icon(Icons.repeat,color: CustomColors.purpleAccent,size: 30,)
                              : const Icon(Icons.repeat,color: CustomColors.white,size: 30,)
                             )
                      ],  
                    ),
                  )
                ],
              ),
            )),
          );
        });
  }
}

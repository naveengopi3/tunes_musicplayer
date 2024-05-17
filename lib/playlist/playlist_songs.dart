import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/playlist_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';

class PlSongScreen extends StatefulWidget {
  final List<AllSongs> playlistSongs;
  final int playlistIndex;
  final String playlistName;

  const PlSongScreen(
      {super.key,
      required this.playlistSongs,
      required this.playlistIndex,
      required this.playlistName});

  @override
  State<PlSongScreen> createState() => _PlSongScreenState();
}

class _PlSongScreenState extends State<PlSongScreen> {
  AssetsAudioPlayer player = AssetsAudioPlayer.withId("0");
  List<Audio> playlistSongsAudio = [];

  @override
  void initState() {
    for (var song in widget.playlistSongs) {
      playlistSongsAudio.add(Audio.file(song.songurl.toString(),
          metas: Metas(
              title: song.songname,
              artist: song.artists,
              id: song.id.toString())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.black,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: CustomColors.white,
              )),
          title: Text(
            widget.playlistName,
            style: const TextStyle(color: CustomColors.white),
          ),
          centerTitle: true,
          backgroundColor: CustomColors.black,
        ),
        body: ValueListenableBuilder<Box<MyPlaylistModel>>(
            valueListenable: playlistbox.listenable(),
            builder: (context, index, _) {
              List<MyPlaylistModel> plsongs = playlistbox.values.toList();
              List<AllSongs>? songs =
                  plsongs[widget.playlistIndex].playlistSongs;

              if (songs!.isEmpty) {
                return const Center(
                  child: Text(
                    "No songs added",
                    style: TextStyle(color: CustomColors.white),
                  ),
                );
              } 
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          player.open(
                              Playlist(
                                  audios: playlistSongsAudio,
                                  startIndex: index),
                              showNotification: true,
                              loopMode: LoopMode.playlist);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NowPlayingScreen()));
                        },
                        leading: QueryArtworkWidget(
                          artworkFit: BoxFit.cover,
                          id: songs[index].id,
                          type: ArtworkType.AUDIO,
                          artworkQuality: FilterQuality.high,
                          quality: 100,
                          artworkBorder: BorderRadius.circular(30),
                          nullArtworkWidget: const CircleAvatar(
                            radius: 26.3,
                            backgroundImage: AssetImage('assets/null-img.png'),
                          ),
                        ),
                        title: Text(
                          songs[index].songname!,
                          style: const TextStyle(
                            color: CustomColors.white
                            ),
                        ),
                        trailing: PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: CustomColors.white,
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: const Text("Remove"),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Remove From Playlist"),
                                            content: const Text(
                                                "Are you sure you want to remove the song from playlist?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      songs.removeAt(index);
                                                      plsongs.removeAt(index);
                                                      playlistbox.putAt(
                                                          widget.playlistIndex,
                                                          MyPlaylistModel(
                                                              playListName: widget
                                                                  .playlistName,
                                                              playlistSongs:
                                                                  songs));
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  },
                                                  child: const Text("Remove"))
                                            ],
                                          );
                                        });
                                  },
                                )
                              ];
                            }),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                          height: 0.1,
                          color: CustomColors.darkGrey,
                        ),
                    itemCount: songs.length);
              }
            ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:tunes_musicplayer/blocs/music_home/bloc/music_home_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc()..add(AddFavoriteSong()),
      child: Scaffold(
        backgroundColor: CustomColors.black,
        body: SafeArea(
            child: Column(
          children: [
            Expanded(child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is MusicHomeInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FavoriteSongLoaded) {
                  final favSongs = state.favSongs;

                  if (favSongs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Favorite Songs',
                        style: TextStyle(color: CustomColors.white),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<FavoriteBloc>(context)
                          .add(AddFavoriteSong());
                    },
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              BlocProvider.of<FavoriteBloc>(context)
                                  .add(PlayFavoriteSong(index: index));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NowPlayingScreen()));
                            },
                            leading: QueryArtworkWidget(
                              id: favSongs[index].favoriteSongId!,
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
                            title: Text(favSongs[index].favoriteSongname!,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: CustomColors.white)),
                            subtitle: Text(favSongs[index].favoriteSongArtist!,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: CustomColors.white)),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Remove from favorite"),
                                          content: const Text("Are You Sure?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel")),
                                            TextButton(
                                                onPressed: () {
                                                  BlocProvider.of<FavoriteBloc>(
                                                          context)
                                                      .add(DeleteFavoriteSong(
                                                          index: index));
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Remove")),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                )),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                              height: 0.1,
                              color: CustomColors.darkGrey,
                            ),
                        itemCount: state.favSongs.length),
                  );
                }

                return Container();
              },
            ))
          ],
        )),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/favorite_model.dart';
import 'package:tunes_musicplayer/models/home_model.dart';

class NowPlayingFav extends StatefulWidget {
  int index;
  NowPlayingFav({super.key, required this.index});

  @override
  State<NowPlayingFav> createState() => _NowPlayingFavState();
}

class _NowPlayingFavState extends State<NowPlayingFav> {
  List<FavoriteModel> fav = [];
  bool favorited = false;
  final box = SongBox.getInstance();

  late List<AllSongs> dbsongs = box.values.toList();

  @override
  void initState() {
    dbsongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fav = favoriteSongs.values.toList();
    return fav
            .where((element) =>
                element.favoriteSongname == dbsongs[widget.index].songname)
            .isEmpty
        ? IconButton(
            onPressed: () {
              favoriteSongs.add(FavoriteModel(
                  favoriteSongname: dbsongs[widget.index].songname,
                  favoriteSongArtist: dbsongs[widget.index].artists,
                  favoriteSongDuration: dbsongs[widget.index].duration,
                  favoriteSongurl: dbsongs[widget.index].songurl,
                  favoriteSongId: dbsongs[widget.index].id));
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to Favorite")));
            },
            icon: const Icon(
              Icons.favorite,
              size: 30, 
              color: CustomColors.white,
            ))
        : IconButton(
            onPressed: () async {
              if (favoriteSongs.length < 1) {
                favoriteSongs.clear(); 
                setState(() {});
              } else {
                int currentIndex = fav.indexWhere((element) =>
                    element.favoriteSongId == dbsongs[widget.index].id);
                await favoriteSongs.deleteAt(currentIndex);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Remove From Favorites")));
              }
            },
            icon: const Icon(
              Icons.favorite,
              size: 30,
              color: CustomColors.purpleAccent,
            ));
  }
}

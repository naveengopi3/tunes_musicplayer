
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/favorite_model.dart';
import 'package:tunes_musicplayer/models/home_model.dart';

// ignore: must_be_immutable
class AddToFavorite extends StatefulWidget {
  int index;
   AddToFavorite({super.key,required this.index});

  @override
  State<AddToFavorite> createState() => _AddToFavoriteState();
}

class _AddToFavoriteState extends State<AddToFavorite> {

  List<FavoriteModel> fav = [];
  bool favorited = false;
  final box = SongBox.getInstance();
  late List<AllSongs>dbsongs;

  @override
  void initState() {
   dbsongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fav = favoriteSongs.values.toList();
    return fav
    .where((element) => element.favoriteSongname == dbsongs[widget.index].songname).isEmpty
    ? TextButton(
      onPressed: (){
        favoriteSongs.add(FavoriteModel(
          favoriteSongname: dbsongs[widget.index].songname, 
          favoriteSongArtist: dbsongs[widget.index].artists,
           favoriteSongDuration: dbsongs[widget.index].duration,
            favoriteSongurl: dbsongs[widget.index].songurl,
             favoriteSongId: dbsongs[widget.index].id
             ));
             setState(() {
                
             });
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Added to Favorites")
              ));
      }, 
      child: const Text("Add to Favorites",style: TextStyle(color: CustomColors.white,fontSize: 18),)
      )
      :TextButton(
        onPressed: ()async{
          if(favoriteSongs.length<1){
            favoriteSongs.clear();
            setState(() {
              
            });
          }else{
            int currentIndex = fav.indexWhere((element) => element.favoriteSongId== dbsongs[widget.index].id);
            await favoriteSongs.deleteAt(currentIndex);
            setState(() {
              
            });
            Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Removed From Favorites")
              ));

          }
        }, 
        child: const Text("Remove From Favorites")
        );

  }
}

import 'package:hive/hive.dart';
import 'package:tunes_musicplayer/models/favorite_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/playlist_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';

late Box<FavoriteModel> favoriteSongs;

openFavoriteModeldb() async{
  favoriteSongs = await Hive.openBox<FavoriteModel>('favSongs');
}

//---------------------------------------------------------------

late Box<MostlyPlayedModel>mostlyplayedSongs;

mostlyplayedSongsdb() async{
  mostlyplayedSongs = await Hive.openBox('mostlyPlayedSongs');
}



updateMostlyPlayed(int songIndex,MostlyPlayedModel classObject){
  int clickCount = classObject.songcount;

  classObject.songcount = clickCount +1;

  mostlyplayedSongs.putAt(songIndex, classObject);
}

//---------------------------------------------------------------

late Box<MyPlaylistModel>playlistbox;

openplaylistdb() async{
  playlistbox = await Hive.openBox<MyPlaylistModel>('playlist');
}

//---------------------------------------------------------------


late Box<RecentModel>recentlyplayed;

recentlyPlayedDb() async{
  recentlyplayed = await Hive.openBox('recentlyPlayedSongs');
}


updateRecentPlayed(RecentModel value,index){
 List<RecentModel> list = recentlyplayed.values.toList();

 bool isAlready = list.where((element){
  
  return element.recentSongName == value.recentSongName;
 },
 ).isEmpty;

 if(isAlready == true){
  recentlyplayed.add(value);
 }else{
  int index = list.indexWhere(
    (element) => element.recentSongName==value.recentSongName);
    recentlyplayed.deleteAt(index);
    recentlyplayed.add(value);
 }
}

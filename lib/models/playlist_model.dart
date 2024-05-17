
import 'package:hive/hive.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
part 'playlist_model.g.dart';


@HiveType(typeId: 3)
class MyPlaylistModel{

@HiveField(0)
String? playListName;

@HiveField(1)

List<AllSongs>?playlistSongs;


MyPlaylistModel({
  required this.playListName,
  required this.playlistSongs
});

}
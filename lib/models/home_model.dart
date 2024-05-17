import 'package:hive/hive.dart';
part 'home_model.g.dart';

@HiveType(typeId:0)

class AllSongs {
  @HiveField(0)
  String? songname;

  @HiveField(1)
  String? artists;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  String songurl;

  @HiveField(4)
  int id;

 AllSongs({
  required this.songname,
  required this.artists,
  required this.duration,
  required this.songurl,
  required this.id
 });

}


String boxname = 'Songs';

class SongBox {
  static Box<AllSongs>? _box;
  static Box<AllSongs> getInstance() {
    return _box ??= Hive.box(boxname);
  }
}




import 'package:hive/hive.dart';
part 'favorite_model.g.dart';


@HiveType(typeId: 2)

class FavoriteModel{
  @HiveField(0)
  String? favoriteSongname;

  @HiveField(1)
  String? favoriteSongArtist;

  @HiveField(2)
  int? favoriteSongDuration;

  @HiveField(3)
  String? favoriteSongurl;

  @HiveField(4)
  int? favoriteSongId;


  FavoriteModel({
    required this.favoriteSongname,
    required this.favoriteSongArtist,
    required this.favoriteSongDuration,
    required this.favoriteSongurl,
    required this.favoriteSongId
  });
}
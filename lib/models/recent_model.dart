import 'package:hive/hive.dart';
part 'recent_model.g.dart';

@HiveType(typeId: 1)

class RecentModel{

  @HiveField(0)
  String recentSongName;

  @HiveField(1)
  String recentSongArtist;

  @HiveField(2)
  int recentSongDuration;

  @HiveField(3)
  String recentSongurl;

  @HiveField(4)
  int recentId;

  RecentModel({
    required this.recentSongName,
    required this.recentSongArtist,
    required this.recentSongDuration,
    required this.recentSongurl,
    required this.recentId
  });

}
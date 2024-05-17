import 'package:hive/hive.dart';
part 'mostly_model.g.dart';

@HiveType(typeId: 4)

class MostlyPlayedModel{
@HiveField(0)
String mostlysongname;

@HiveField(1)
String mostlyartistname;

@HiveField(2)
int mostlysongduration;

@HiveField(3)
String mostlysongurl;

@HiveField(4)
int songcount;

@HiveField(5)
int mostlySongId;

MostlyPlayedModel({
required this.mostlysongname,
required this.mostlyartistname,
required this.mostlysongduration,
required this.mostlysongurl,
required this.songcount,
required this.mostlySongId
});

}
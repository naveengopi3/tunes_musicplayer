import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/screens/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final OnAudioQuery audioQuery = OnAudioQuery();
final box = SongBox.getInstance();

List<SongModel> fetchedSongs = [];
List<SongModel> allSongs = [];
List<Audio> fullsongs = [];

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    requestStoragePermission();
    gotoHomeScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mqWidth = MediaQuery.of(context).size.width;
    double mqHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/tunes.png',
              width: mqWidth * 1,
              height: mqHeight * 1,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestStoragePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.mediaLibrary,
      Permission.audio,
    ].request();

    if (statuses[Permission.storage] == PermissionStatus.granted ||
        statuses[Permission.mediaLibrary] == PermissionStatus.granted) {
      // Permission granted, proceed with fetching songs
      fetchedSongs = await audioQuery.querySongs();

      for (var element in fetchedSongs) {
        if (element.fileExtension == "mp3") {
          if (!box.values.any((song) => song.id == element.id)) {
            // If not add it to the hive box
            print("Adding to box: ${element.title}");
            box.add(AllSongs(
              songname: element.title,
              artists: element.artist,
              duration: element.duration,
              songurl: element.uri!,
              id: element.id,
            ));
          }

          print("Adding to mostlyplayedSongs: ${element.title}");
          mostlyplayedSongs.add(MostlyPlayedModel(
            mostlysongname: element.title,
            mostlyartistname: element.artist!,
            mostlysongduration: element.duration!,
            mostlysongurl: element.uri!,
            songcount: 0,
            mostlySongId: element.id,
          ));
        }
      }
    } else {
      // Permission not granted, handle the case
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Permission Denied"),
            content:
                const Text("This app requires storage permission to function."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void gotoHomeScreen(context) async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabScreen()));
  }
}

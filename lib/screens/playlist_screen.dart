import 'package:flutter/material.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/mostplayed/mostly_played.dart';
import 'package:tunes_musicplayer/playlist/playlist_screen.dart';
import 'package:tunes_musicplayer/recently_played.dart/recently_played.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black,
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  MostlyPlayed(),
              ));
            },
            child: ListTile(
              title: const Text(
                "Mostly Played",
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 18,
                ),
              ),
              trailing: rightArrow(),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  RecentlyPlayedScreen(),
              ));
            },
            child: ListTile(
              title: const Text(
                "Recently Played",
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 18,
                ),
              ),
              trailing: rightArrow(),
            ),
          ),
          InkWell(
            child: ListTile(
              title: const Text(
                'Playlists',
                style: TextStyle(
                  color: CustomColors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyPlaylistScreen()));
              }, 
              trailing: rightArrow(),
            ),
          )
        ],
      ),
    );
  }
}

Widget rightArrow() {
  return const Icon(
    Icons.chevron_right_sharp,
    color: CustomColors.white,
    size: 30,
  );
}

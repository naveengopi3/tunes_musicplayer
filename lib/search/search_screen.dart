
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/now_playing/now_playing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final box = SongBox.getInstance();
  late List<AllSongs> dbsongs;
  AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId("0");
  List<Audio> allSongs = [];

  @override
  void initState() {
    dbsongs = box.values.toList();
    super.initState();
  }

  late List<AllSongs> searchResults = List.from(dbsongs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black ,
      body: SafeArea(
        child: Column(
          children: [
            searchBar(context),
            Expanded(child: searchHistory()),
          ],
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) => updateSearch(value),
        style: const TextStyle(color: CustomColors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: CustomColors.white),
           
          hintText: 'Search for a Song',
          hintStyle: const TextStyle(color: CustomColors.white),
          filled: true,
          fillColor: CustomColors.darkGrey,
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget searchHistory() {
    return searchResults.isEmpty
        ? const Center(
            child: Text("No Songs Found",style: TextStyle(color: CustomColors.white,fontSize: 20),),
          )
        : ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  _audioPlayer.open(
                    Playlist(audios: allSongs, startIndex: index),
                    headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                    loopMode: LoopMode.playlist,
                  );
                        Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NowPlayingScreen())); 
                },
                leading: QueryArtworkWidget(
                  id: searchResults[index].id,
                  type: ArtworkType.AUDIO,
                  artworkQuality: FilterQuality.high,
                  quality: 100,
                  artworkBorder: BorderRadius.circular(28),
                  nullArtworkWidget: const CircleAvatar(
                    radius: 26.3,
                    backgroundImage: AssetImage('assets/null-img.png'),
                  ),
                ),
                title: Text(
                  searchResults[index].songname!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: CustomColors.white),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: searchResults.length,
          );
  }

  void updateSearch(String value) {
    setState(() {
      searchResults = dbsongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      allSongs.clear();
      for (var item in searchResults) {
        allSongs.add(
          Audio.file(
            item.songurl.toString(),
            metas: Metas(
              artist: item.artists,
              title: item.songname,
              id: item.id.toString(),
            ),
          ),
        ); 
      }
    });
  }
}

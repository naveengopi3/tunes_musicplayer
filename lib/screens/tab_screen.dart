import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunes_musicplayer/blocs/tab_bloc/tab_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/miniplayer/mini_player.dart';
import 'package:tunes_musicplayer/more_option/more_option.dart';
import 'package:tunes_musicplayer/favorite/favorite_screen.dart';
import 'package:tunes_musicplayer/allsongs/music_home.dart';
import 'package:tunes_musicplayer/screens/playlist_screen.dart';
import 'package:tunes_musicplayer/search/search_screen.dart';

class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBloc(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: CustomColors.black,
          appBar: AppBar(
            backgroundColor: CustomColors.black,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MoreOptionScreen()));
                },
                icon: const Icon(
                  Icons.sort,
                  color: CustomColors.white,
                )),
            title: const Text(
              'tunes',
              style: TextStyle(color: CustomColors.white),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Songs'),
                Tab(text: 'Favorites'),
                Tab(text: 'Playlist'),
              ],
              indicatorColor: CustomColors.purpleAccent,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: CustomColors.white,
              labelColor: CustomColors.purpleAccent,
              dividerHeight: 0.1,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  SearchScreen()));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: CustomColors.white,
                  )),
            ],
          ),
          body: BlocBuilder<TabBloc,TabState>(
            builder:(context,state){
              return TabBarView(
                
          
                children: [ 
                   MusicHome(),
                    FavoriteScreen(),
                    PlayListScreen(),
                ]
                );
            }
            ),
          bottomSheet: const Miniplayer(),
        ),
      ),
    );
  }
}

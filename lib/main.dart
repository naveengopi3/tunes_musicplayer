import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tunes_musicplayer/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:tunes_musicplayer/blocs/mp_bloc/mostplayed_bloc.dart';
import 'package:tunes_musicplayer/blocs/music_home/bloc/music_home_bloc.dart';
import 'package:tunes_musicplayer/blocs/recent_bloc/recent_played_bloc.dart';
import 'package:tunes_musicplayer/blocs/tab_bloc/tab_bloc.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/favorite_model.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/mostly_model.dart';
import 'package:tunes_musicplayer/models/playlist_model.dart';
import 'package:tunes_musicplayer/models/recent_model.dart';
import 'package:tunes_musicplayer/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(AllSongsAdapter());
  await Hive.openBox<AllSongs>(boxname);

  Hive.registerAdapter(RecentModelAdapter());
  recentlyPlayedDb();

  Hive.registerAdapter(FavoriteModelAdapter());
  openFavoriteModeldb();

  Hive.registerAdapter(MyPlaylistModelAdapter());
  openplaylistdb();

  Hive.registerAdapter(MostlyPlayedModelAdapter());
  await mostlyplayedSongsdb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TabBloc()),
        BlocProvider(create: (context) => MusicHomeBloc()),
        BlocProvider(create: (context) => FavoriteBloc()),
        BlocProvider(create: (context) => MostplayedBloc()),
        BlocProvider(create: (context) => RecentPlayedBloc()),

         
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: CustomColors.black,
        ),
        title: 'Tunes',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

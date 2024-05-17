// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/home_model.dart';
import 'package:tunes_musicplayer/models/playlist_model.dart';

class AddFromNowPlaying extends StatefulWidget {
  int songindex;
   AddFromNowPlaying({super.key,required this.songindex});

  @override
  State<AddFromNowPlaying> createState() => _AddFromNowPlayingState();
}

class _AddFromNowPlayingState extends State<AddFromNowPlaying> {

 TextEditingController textEditingController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()async{
        await playlistBottomSheet(context);
      },
       icon: const Icon(Icons.playlist_add,color: CustomColors.white,size: 30,)
       );
  }

  Future<dynamic> playlistBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 137,
              //    color: CustomColors.lightGrey,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: CustomColors.black),
              child: ValueListenableBuilder(
                  valueListenable: playlistbox.listenable(),
                  builder: (context, Box<MyPlaylistModel> playlistbox, _) {
                    List<MyPlaylistModel> playlist =
                        playlistbox.values.toList();

                    if (playlistbox.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Create a playlist to add",
                              style: TextStyle(
                                  color: CustomColors.white, fontSize: 25),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => bottomSheet(context),
                                  );
                                },
                                child: const Text(
                                  "Create Playlist",
                                )),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        const Text(
                          "Your Playlist",
                          style: TextStyle(
                              color: CustomColors.white, fontSize: 25),
                        ),
                        Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Image(
                                      image: AssetImage("assets/playlist.png"),
                                      height: 18,
                                      width: 18,
                                    ),
                                    title: Text(
                                      playlist[index].playListName.toString(),
                                      style: const TextStyle(
                                          color: CustomColors.white),
                                    ),
                                    onTap: () {
                                      MyPlaylistModel? plsongs =
                                          playlistbox.getAt(index);

                                      List<AllSongs>? plNewSongs =
                                          plsongs!.playlistSongs;

                                      Box<AllSongs> box = Hive.box('Songs');

                                      List<AllSongs> dbAllSongs =
                                          box.values.toList();

                                      bool isAlreadyAdded = plNewSongs!.any(
                                          (element) =>
                                              element.id ==
                                              dbAllSongs[widget.songindex].id);

                                      if (!isAlreadyAdded) {
                                        plNewSongs.add(AllSongs(
                                            songname:
                                                dbAllSongs[widget.songindex]
                                                    .songname,
                                            artists:
                                                dbAllSongs[widget.songindex]
                                                    .artists,
                                            duration:
                                                dbAllSongs[widget.songindex]
                                                    .duration,
                                            songurl:
                                                dbAllSongs[widget.songindex]
                                                    .songurl,
                                            id: dbAllSongs[widget.songindex]
                                                .id));

                                        playlistbox.putAt(
                                            index,
                                            MyPlaylistModel(
                                                playListName: playlist[index]
                                                    .playListName,
                                                playlistSongs: plNewSongs));

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    CustomColors.black,
                                                content: Text(
                                                    "${dbAllSongs[widget.songindex].songname}Added to ${playlist[index].playListName}")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    CustomColors.black,
                                                content: Text(
                                                    '${dbAllSongs[widget.songindex].songname} is already added ')));
                                      }

                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemCount: playlist.length))
                      ],
                    );
                  }),
            );
          });
        });
  }

  Widget bottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: CustomColors.black,
          height: 230,
          child: Column(
            children: [playlistform(context)], 
          ),
        ),
      ),
    );
  } 

  Padding playlistform(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: Column(
          children: [
            const Text(
              "Create Playlist",
              style: TextStyle(color: CustomColors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
                key: formGlobalKey,
                child: TextFormField(
                  controller: textEditingController,
                  cursorHeight: 25,
                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black)),
                    hintText: "Enter a name",
                  ),
                  validator: (value) {
                    List<MyPlaylistModel> values = playlistbox.values.toList();

                    bool isAlreadyAdded = values
                        .where(
                            (element) => element.playListName == value!.trim())
                        .isNotEmpty;

                    if (value!.trim() == '') {
                      return 'Name required';
                    }
                    if (value.trim().length > 10) {
                      return 'Enter Characters below 10 ';
                    }

                    if (isAlreadyAdded) {
                      return 'Name Already Exists';
                    }
                    return null;
                  },
                )),
            formbuttons(context)
          ],
        ),
      ),
    );
  }

  Row formbuttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              final isValid = formGlobalKey.currentState!.validate();

              if (isValid) {
                playlistbox.add(MyPlaylistModel(
                    playListName: textEditingController.text,
                    playlistSongs: []));
                Navigator.pop(context);
              }
            },
            child: const Text("Create"))
      ],
    );
  }
}
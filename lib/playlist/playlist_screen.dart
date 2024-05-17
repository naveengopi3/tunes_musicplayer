import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/functions/db_functions.dart';
import 'package:tunes_musicplayer/models/playlist_model.dart';
import 'package:tunes_musicplayer/playlist/playlist_songs.dart';

class MyPlaylistScreen extends StatefulWidget {
  const MyPlaylistScreen({super.key});

  @override
  State<MyPlaylistScreen> createState() => _MyPlaylistScreenState();
}

class _MyPlaylistScreenState extends State<MyPlaylistScreen> {
  TextEditingController playlistNameController = TextEditingController();
  TextEditingController playlistNameEditor = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final editorFormKey = GlobalKey<FormState>();

  List<MyPlaylistModel> listOfPlaylists = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: CustomColors.white,
            )),
        title: const Text(
          "Playlists",
          style: TextStyle(color: CustomColors.white),
        ),
        centerTitle: true,
        backgroundColor: CustomColors.black,
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Divider(
            color: CustomColors.white,
            thickness: 0.2,
            height: 0.1,
          ),
          ElevatedButton.icon(
              onPressed: () {
                createplaylist(context);
              },
              icon: const Icon(
                Icons.add,
                color: CustomColors.purpleAccent,
                size: 30,
              ),
              label: const Text(
                "Create Playlist",
                style: TextStyle(
                    color: CustomColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 30),
                  shape: LinearBorder.end(),
                  backgroundColor: CustomColors.black,
                  alignment: Alignment.bottomLeft)),
          const Divider(
            color: CustomColors.white,
            thickness: 0.2,
            height: 0.3,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ValueListenableBuilder<Box<MyPlaylistModel>>(
                  valueListenable: playlistbox.listenable(),
                  builder: (context, value, child) {
                    List<MyPlaylistModel> listOfPlaylists =
                        value.values.toList();
                    return listOfPlaylists.isEmpty
                        ? const Center(
                            child: Text(
                              "No Playlists Created",
                              style: TextStyle(
                                  color: CustomColors.white, fontSize: 15),
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PlSongScreen(
                                                playlistSongs:
                                                    listOfPlaylists[index]
                                                        .playlistSongs!,
                                                playlistIndex: index,
                                                playlistName:
                                                    listOfPlaylists[index]
                                                        .playListName!)));
                                  },
                                  leading: const Image(
                                    image: AssetImage("assets/playlist.png"),
                                    height: 40,
                                    width: 50,
                                  ),
                                  title: Text(
                                    listOfPlaylists[index]
                                        .playListName
                                        .toString(),
                                    style: const TextStyle(
                                        color: CustomColors.white),
                                  ),
                                  trailing: PopupMenuButton<int>(
                                    
                                    color: CustomColors.lightGrey,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: CustomColors.white,
                                    ),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: const Text("Edit"),
                                          onTap: () {
                                            editplaylistName(context, index);
                                  
                                          },
                                        ),
                                        const PopupMenuDivider(),
                                        PopupMenuItem<int>(
                                          value: 2,
                                          child: const Text("Delete"),
                                          onTap: () {
                                            deletePlaylist(index);
                                          },
                                        ),
                                      ];
                                    },
                                  ));
                            },
                            separatorBuilder: (context, index) => const Divider(
                                  height: 0.1,
                                  color: CustomColors.darkGrey,
                                ),
                            itemCount: listOfPlaylists.length);
                  }))
        ],
      )),
    );
  }

  //-----------------------------------------------------------------------------------------------------
  void createplaylist(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Create Playlist"),
            content: Form(
                key: formKey,
                child: TextFormField(
                    controller: playlistNameController,
                    decoration:
                        const InputDecoration(hintText: "Enter playlist name"),
                    validator: (value) {
                      List<MyPlaylistModel> playlistDetails =
                          playlistbox.values.toList();
                      bool isAlreadyThere = playlistDetails
                          .where((element) =>
                              element.playListName == value!.trim())
                          .isNotEmpty;

                      if (value!.trim() == "") {
                        return "Name required";
                      }

                      if (value.trim().isEmpty) {
                        return "Name required";
                      }
                      if (isAlreadyThere) {
                        return "Name Already Exist";
                      } else {
                        return null;
                      }
                    })),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (isValid) {
                      playlistbox.add(MyPlaylistModel(
                        playListName: playlistNameController.text,
                        playlistSongs: [],
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }

//------------------------createPlaylist-----------------------------------------------------------------------------------------------
  void deletePlaylist(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Playlist"),
          content: const Text("Are you sure you want to delete this playlist?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                playlistbox.deleteAt(index);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

//------------------------------------------------------deletefunction--------------------------------------------------------------
  void editplaylistName(BuildContext context, int index) {
    playlistNameEditor = playlistNameController;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Playlist"),
            content: Form(
                key: editorFormKey,
                child: TextFormField(
                  controller: playlistNameEditor,
                  decoration: const InputDecoration(
                      hintText: "New Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.black))),
                  validator: (value) {
                    List<MyPlaylistModel> editValid =
                        playlistbox.values.toList();
                    bool isAlreadyThere = editValid
                        .where((element) =>
                            element.playListName == value!.trim() &&
                            element.playListName !=
                                playlistbox.getAt(index)!.playListName)
                        .isNotEmpty;

                    if (value!.trim() == "") {
                      return "Name required";
                    }

                    if (value.trim().isEmpty) {
                      return "Name required";
                    }
                    if (isAlreadyThere) {
                      return "Name Already Exist";
                    } else {
                      return null;
                    }
                  },
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                  onPressed: () {
                    final isValid = editorFormKey.currentState!.validate();
                    if (isValid) {
                      playlistbox.putAt(
                          index,
                          MyPlaylistModel(
                              playListName: playlistNameEditor.text,
                              playlistSongs:
                                  playlistbox.getAt(index)!.playlistSongs));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"))
            ],
          );
        });
  }
//-------------------------------------------------editfunciton-----------------------------------------
}

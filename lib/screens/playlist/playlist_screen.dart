import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_bliss/controller/playlist_controller.dart';

import '../../database/functions/playlist_db_function.dart';
import '../../model/song_model.dart';
import '../bottom_nav.dart';
import '../home/miniplayer.dart';
import '../liked/liked_screen.dart';

import '../settings_screen.dart';
import 'current_playlist.dart';

final playlistObj = PlaylistController();

class Playlist extends StatelessWidget {
  Playlist({super.key});

  final playlistNameController = TextEditingController();
  final renameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ' Playlist',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(gradient: bodyGradient),
                          height: displayHeight * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  'Give the playlist name.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                TextField(
                                  controller: playlistNameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(
                                      Icons.playlist_play_rounded,
                                      size: 25,
                                    ),
                                    // suffixIcon: Icon(Icons.clear_rounded),
                                    hintText: 'Playlist name',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        elevation: 2,
                                        backgroundColor: Color(0xFF20225D)),
                                    onPressed: () {
                                      if (playlistNameController.text.trim() ==
                                          '') {
                                        playlistNameController.clear();
                                        Get.back();
                                        snack(context,
                                            message:
                                                'Playlist name cannot be empty',
                                            color: Colors.red);
                                      } else if (!playlistObj.playlist
                                          .map((e) => e.playlistName)
                                          .contains(playlistNameController.text
                                              .trim())) {
                                        playlistObj.playlistcreating(
                                            playlistNameController.text.trim());

                                        playlistNameController.clear();

                                        snack(context,
                                            message: 'Playlist Added',
                                            color: Color(0xFF4CAF50));
                                        Get.back();
                                      } else if (playlistObj.playlist
                                          .map((e) => e.playlistName)
                                          .contains(playlistNameController.text
                                              .trim())) {
                                        playlistNameController.clear();

                                        Get.back();
                                        snack(context,
                                            message: 'Playlist already exist',
                                            color: Colors.red);
                                      }
                                    },
                                    child: Text('Create'))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(Settings());
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: playlistObj.playlist.isEmpty
                  ? Center(
                      child: Container(
                        child: Text(
                          'No Playlist Found',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: playlistObj.playlist.length,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30),
                      itemBuilder: (context, index) {
                        if (currentlyplaying != null) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            showBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) =>  MiniPlayer(),
                            );
                          });
                        }
                        return InkWell(
                          highlightColor: Colors.white,
                          onTap: () {
                            Get.to(PlaylistDetails(
                                  currentPlaylist: playlistObj.playlist[index]));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/playlistcover.jpg'))),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Color(0xFF07014F),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .drive_file_rename_outline_rounded,
                                                      color: Colors.white),
                                                  Text(
                                                    'Rename',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                          PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.white),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ))
                                        ],
                                        onSelected: (value) async {
                                          if (value == 0) {
                                            renameController.text = playlistObj
                                                .playlist[index].playlistName;

                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      backgroundColor:
                                                          Color(0xFF07014F),
                                                      title: Center(
                                                          child: Text(
                                                        'Rename',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      content: TextField(
                                                        controller:
                                                            renameController,
                                                        decoration:
                                                            InputDecoration(
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons.edit,
                                                                ),
                                                                hintText:
                                                                    'Rename',
                                                                hintStyle:
                                                                    TextStyle(),
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20))),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                elevation: 2,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF20225D)),
                                                            onPressed:
                                                                () async {
                                                              await playlistObj.playlistRename(
                                                                  oldName: playlistObj
                                                                      .playlist[
                                                                          index]
                                                                      .playlistName,
                                                                  newName:
                                                                      renameController
                                                                          .text);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Rename')),
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                elevation: 2,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF20225D)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Cancel'))
                                                      ],
                                                      actionsAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                    ));
                                          }
                                          if (value == 1) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      backgroundColor:
                                                          Color(0xFF07014F),
                                                      title: Center(
                                                          child: Text(
                                                        'Are you sure you want to delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                elevation: 2,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF20225D)),
                                                            onPressed:
                                                                () async {
                                                              await playlistObj
                                                                  .playlistDelete(
                                                                      index);

                                                              snack(context,
                                                                  message:
                                                                      'Playlist Removed',
                                                                  color: Color(
                                                                      0xFFF44336));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Delete')),
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                elevation: 2,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF20225D)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                Text('Cancel'))
                                                      ],
                                                      actionsAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                    ));
                                          }
                                        },
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20)),
                                            color: Colors.black.withOpacity(.5),
                                          ),
                                          width: double.infinity,
                                          height: 30,
                                          child: Center(
                                            child: Text(
                                              playlistObj
                                                  .playlist[index].playlistName,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              )),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// List<EachPlaylist> playlist = [];

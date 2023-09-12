import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/database/functions/playlist_db_function.dart';
import 'package:tune_bliss/screens/home/miniplayer.dart';
import 'package:tune_bliss/screens/now_playing.dart';
import 'package:tune_bliss/screens/playlist/playlist_screen.dart';

import '../../functions/fetch_songs.dart';
import '../../model/song_model.dart';
import '../bottom_nav.dart';
import '../liked/liked_screen.dart';
import 'playlist_add_songs.dart';

// ValueNotifier currentPlaylistBodyNotifier = ValueNotifier([]);

class PlaylistDetails extends StatelessWidget {
  final EachPlaylist currentPlaylist;
  const PlaylistDetails({super.key, required this.currentPlaylist});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: Container(
        height: displayHeight,
        width: displayWidth,
        decoration: BoxDecoration(gradient: bodyGradient),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(
              right: displayWidth * .05,
              left: displayWidth * .05,
              top: displayWidth * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () =>
                        Get.to(PlaylistAddSongs(object: currentPlaylist)),
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: displayHeight * .35,
                  width: displayWidth * .7,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          blurRadius: 10,
                          color: Color(0xFF9DA8CD),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage('assets/images/playlistcover.jpg'))),
                ),
              ),
              SizedBox(
                height: displayHeight * .03,
              ),
              Row(
                children: [
                  Text(
                    currentPlaylist.playlistName,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      playingAudio(currentPlaylist.playlistSongs, 0);
                      Get.to(NowPlaying());
                    },
                    child: Stack(children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        color: Color(0xFF20225D),
                      ),
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 55,
                      ),
                    ]),
                  ),
                ],
              ),
              SizedBox(
                height: displayHeight * .03,
              ),
              Expanded(
                  child: Material(
                color: Colors.black.withOpacity(0),
                child: GetBuilder(
                  init: playlistObj,
                  builder: (controller) => currentPlaylist.playlistSongs.isEmpty
                      ? Center(
                          child: Text(
                            'No Songs found',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isliked;
                            if (favObj.likedSongs.contains(allsongs[index])) {
                              isliked = true;
                            } else {
                              isliked = false;
                            }
                            return ListTile(
                              onTap: () {
                                playingAudio(
                                    currentPlaylist.playlistSongs, index);
                                Get.to(NowPlaying());
                              },
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              tileColor: Color(0xFF20225D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              leading: QueryArtworkWidget(
                                artworkHeight: 60,
                                artworkWidth: 60,
                                size: 3000,
                                quality: 100,
                                artworkQuality: FilterQuality.high,
                                artworkBorder: BorderRadius.circular(12),
                                artworkFit: BoxFit.cover,
                                id: currentPlaylist.playlistSongs[index].id!,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                      'assets/images/albumCover.png'),
                                ),
                              ),
                              title: Text(
                                currentPlaylist.playlistSongs[index].songname!,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                              subtitle: Text(
                                currentPlaylist.playlistSongs[index].artist!,
                                style: TextStyle(
                                    color: Color(0xFF9DA8CD),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: Color(0xFF9DA8CD),
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
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.delete_rounded),
                                              Text(
                                                'Remove',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ))
                                    ],
                                    onSelected: (value) {
                                      if (value == 0) {
                                        playlistObj.playlistRemoveDB(
                                            currentPlaylist
                                                .playlistSongs[index],
                                            currentPlaylist.playlistName);
                                        currentPlaylist.playlistSongs.remove(
                                            currentPlaylist
                                                .playlistSongs[index]);
                                        // currentPlaylistBodyNotifier
                                        //     .notifyListeners();
                                        snack(context,
                                            message: 'Removed from playlist',
                                            color: Colors.red);
                                        //  playlistRemoveDB(removingSong, playlistName)
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: displayHeight * 0.013,
                              ),
                          itemCount: currentPlaylist.playlistSongs.length),
                ),
              )),
            ],
          ),
        )),
      ),
    );
  }
}

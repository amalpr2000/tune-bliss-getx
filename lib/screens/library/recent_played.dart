import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/controller/recent_controller.dart';

import 'package:tune_bliss/screens/home/miniplayer.dart';
import 'package:tune_bliss/screens/liked/liked_screen.dart';
import 'package:tune_bliss/screens/playlist/add_to_playlist.dart';

import '../../model/song_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/like_icon.dart';
import '../bottom_nav.dart';

// ValueNotifier<List<Songs>> recentSongs = ValueNotifier([]);
final recentObj = RecentController();

class RecentPlayed extends StatelessWidget {
  const RecentPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
              AppBarRow(title: 'Recently Played'),
              Container(
                color: Colors.transparent,
                height: displayHeight * 0.0155,
              ),
              (recentObj.recentSongs.isEmpty)
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                          ),
                          Text(
                            'No Recent Songs Found',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  : Obx(() => Expanded(
                          child: Material(
                        color: Colors.black.withOpacity(0),
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  playerMini.stop();
                                  playingAudio(recentObj.recentSongs, index);
                                  showBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(20),
                                      child:  MiniPlayer(),
                                    ),
                                  );
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
                                  id: recentObj.recentSongs[index].id!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/albumCover.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${recentObj.recentSongs[index].songname}',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                subtitle: Text(
                                  '${recentObj.recentSongs[index].artist}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF9DA8CD),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LikedButton(
                                        isfav: favObj.likedSongs.contains(
                                            recentObj.recentSongs[index]),
                                        currentSongs:
                                            recentObj.recentSongs[index]),
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
                                                Icon(Icons.playlist_add),
                                                Text(
                                                  'Add to Playlist',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ))
                                      ],
                                      onSelected: (value) =>
                                          Get.to(recentObj.recentSongs[index]),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, likedSongIndex) =>
                                SizedBox(
                                  height: displayHeight * 0.013,
                                ),
                            itemCount: recentObj.recentSongs.length),
                      )))
            ],
          ),
        )),
      ),
    );
  }
}

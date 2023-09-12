import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/controller/now_playing_controller.dart';
import 'package:tune_bliss/screens/home/miniplayer.dart';
import 'package:tune_bliss/screens/library/most_played.dart';
import 'package:tune_bliss/screens/liked/liked_screen.dart';
import 'package:tune_bliss/screens/playlist/add_to_playlist.dart';
import 'package:tune_bliss/widgets/like_icon.dart';

import 'bottom_nav.dart';
  final nowPlayingObj = NowPlayingController();

class NowPlaying extends StatelessWidget {
  NowPlaying({super.key});

  bool isenteredtomostplayed = false;

  // bool isrepeat = false;

  // bool isShuffle = playerMini.isShuffling.value;
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(body: SingleChildScrollView(
      child: playerMini.builderCurrent(
        builder: (context, playing) {
          int id = int.parse(playing.audio.audio.metas.id!);
          currentSongFinder(id);
          bool isenteredtomostplayed = false;
          return Container(
            height: displayHeight,
            width: displayWidth,
            decoration: BoxDecoration(gradient: bodyGradient),
            child: Padding(
              padding: EdgeInsets.only(
                  right: displayWidth * .05,
                  left: displayWidth * .05,
                  top: displayWidth * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: displayWidth * .05,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.all(displayWidth * .03),
                      child: Center(
                        child: Container(
                          height: displayWidth * .012,
                          width: displayWidth * .08,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF9DA8CD)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayWidth * .18,
                  ),
                  Center(
                    child: Container(
                      height: displayHeight * .4,
                      width: displayWidth * .85,
                      child: QueryArtworkWidget(
                        size: 3000,
                        quality: 100,
                        keepOldArtwork: true,
                        artworkQuality: FilterQuality.high,
                        artworkBorder: BorderRadius.circular(10),
                        artworkFit: BoxFit.cover,
                        id: int.parse(playing.audio.audio.metas.id!),
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipRRect(
                          child: Image.asset(
                            'assets/images/albumCover.png',
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurStyle: BlurStyle.outer,
                            blurRadius: 10,
                            color: Color(0xFF9DA8CD),
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayWidth * .22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerMini.getCurrentAudioTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            playerMini.getCurrentAudioArtist,
                            style: TextStyle(
                                color: Color(0xFF9DA8CD),
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                           Get.to(AddToPlaylist(song: currentlyplaying!));
                          },
                          icon: Icon(
                            Icons.playlist_add,
                            size: 30,
                            color: Colors.white,
                          )),
                      LikedButton(
                          isfav: favObj.likedSongs.contains(currentlyplaying),
                          currentSongs: currentlyplaying!,
                          fromplayscreen: true),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  playerMini.builderRealtimePlayingInfos(
                      builder: (context, infos) {
                    Duration currentposition = infos.currentPosition;
                    Duration totalduration = infos.duration;
                    double currentposvalue =
                        currentposition.inMilliseconds.toDouble();
                    double totalvalue = totalduration.inMilliseconds.toDouble();
                    double value = currentposvalue / totalvalue;
                    if (!isenteredtomostplayed && value > 0.5) {
                      int id = int.parse(playing.audio.audio.metas.id!);
                      mostPlayedObj.mostplayedaddtodb(id);
                      isenteredtomostplayed = true;
                    }
                    return ProgressBar(
                      progress: currentposition,
                      // buffered: Duration(milliseconds: 2000),
                      total: totalduration,
                      progressBarColor: Colors.white,
                      baseBarColor: Color(0xFF9DA8CD),
                      bufferedBarColor: Color.fromARGB(0, 5, 58, 234),
                      timeLabelTextStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      thumbColor: Color.fromARGB(255, 255, 255, 255),
                      onSeek: (to) {
                        playerMini.seek(to);
                      },
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Obx(
                      IconButton(
                          onPressed: () {
                            playerMini.toggleShuffle();
                            nowPlayingObj
                                .shuffleFunction(playerMini.isShuffling.value);
                          },
                          icon: Obx(
                            () => nowPlayingObj.isShuffle.value
                                ? Icon(
                                    Icons.shuffle_on_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.shuffle_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                          )),

                      GestureDetector(
                        onTap: () {
                          playerMini.previous();
                        },
                        child: Icon(
                          color: Colors.white,
                          size: 50,
                          Icons.skip_previous_rounded,
                        ),
                      ),
                      PlayerBuilder.isPlaying(
                          player: playerMini,
                          builder: (context, isPlaying) => InkWell(
                                onTap: () async {
                                  await playerMini.playOrPause();
                                  nowPlayingObj.playPause();
                                  // playerMini.playerState;
                                },
                                child: Obx(
                                  () => (nowPlayingObj.isPlaying.value)
                                      ? Icon(
                                          size: 80,
                                          Icons.pause_circle_filled_rounded,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          size: 80,
                                          Icons.play_circle_fill_rounded,
                                          color: Colors.white,
                                        ),
                                ),
                              )),
                      GestureDetector(
                        onTap: () async {
                          await playerMini.next();
                        },
                        child: Icon(
                          color: Colors.white,
                          size: 50,
                          Icons.skip_next_rounded,
                        ),
                      ),
                      Obx(
                        () => IconButton(
                            onPressed: () {
                              // setState(() {
                              if (nowPlayingObj.isrepeat.value == false) {
                                nowPlayingObj.isrepeat.value = true;
                                playerMini.setLoopMode(LoopMode.single);
                              } else {
                                nowPlayingObj.isrepeat.value = false;
                                playerMini.setLoopMode(LoopMode.playlist);
                              }
                              // });
                            },
                            icon: nowPlayingObj.isrepeat.value
                                ? Icon(
                                    Icons.repeat_on_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.repeat_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

class IconNew extends StatelessWidget {
  IconNew({
    super.key,
    required this.size,
    required this.icon,
  });

  double size;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: Colors.white,
        iconSize: size,
        onPressed: () {},
        icon: Icon(icon));
  }
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/controller/now_playing_controller.dart';
import 'package:tune_bliss/database/functions/most_played_function.dart';
import 'package:tune_bliss/database/functions/recent_db_function.dart';
import 'package:tune_bliss/functions/fetch_songs.dart';
import 'package:tune_bliss/model/song_model.dart';
import 'package:tune_bliss/screens/library/most_played.dart';
import 'package:tune_bliss/screens/library/recent_played.dart';
import 'package:tune_bliss/screens/now_playing.dart';

final AssetsAudioPlayer playerMini = AssetsAudioPlayer.withId('0');
int? playingId;
Songs? currentlyplaying;
List<Audio> playinglistAudio = [];

class MiniPlayer extends StatelessWidget {
   MiniPlayer({super.key});

  bool isenteredtomostplayed = false;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Get.to( NowPlaying());
      },
      child: SizedBox(
        height: displayHeight * 0.096,
        width: displayWidth,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            color: Color(0xFF07014F),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
            child: playerMini.builderCurrent(
              builder: (context, playing) {
                int id = int.parse(playing.audio.audio.metas.id!);
                currentSongFinder(id);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: displayHeight * 0.070,
                          // width: MediaQuery.of(context).size.width * 0.14,
                          width: displayHeight * 0.075,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            child: QueryArtworkWidget(
                              keepOldArtwork: true,
                              artworkQuality: FilterQuality.high,
                              artworkBorder: BorderRadius.circular(10),
                              artworkFit: BoxFit.cover,
                              id: int.parse(playing.audio.audio.metas.id!),
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                                child: Image.asset(
                                  'assets/images/albumCover.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 80.w),
                        SizedBox(
                          // color: Colors.red,
                          height: 30,

                          width: displayWidth * 0.3,
                          child: Marquee(
                            text: playerMini.getCurrentAudioTitle,
                            pauseAfterRound: const Duration(seconds: 3),
                            velocity: 30,
                            blankSpace: 35,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          // color: Colors.red,
                          width: 2,
                        ),
                        PlayerBuilder.isPlaying(
                          player: playerMini,
                          builder: (context, isPlaying) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      Future.delayed(
                                          Duration(microseconds: 800));
                                      await playerMini.previous();
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await playerMini.playOrPause();
                                      nowPlayingObj.playPause();
                                    },
                                    icon: Obx(
                                      () => Icon(
                                        nowPlayingObj.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      Future.delayed(
                                          Duration(microseconds: 800));
                                      await playerMini.next();
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.007,
                                right:
                                    MediaQuery.of(context).size.width * 0.007,
                              ),
                              child: PlayerBuilder.realtimePlayingInfos(
                                player: playerMini,
                                builder: (context, infos) {
                                  Duration currentpos = infos.currentPosition;
                                  Duration total = infos.duration;
                                  double currentposvalue =
                                      currentpos.inMilliseconds.toDouble();
                                  double totalvalue =
                                      total.inMilliseconds.toDouble();
                                  double value = currentposvalue / totalvalue;
                                  if (!isenteredtomostplayed && value > 0.5) {
                                    int id = int.parse(
                                        playing.audio.audio.metas.id!);
                                    mostPlayedObj.mostplayedaddtodb(id);
                                    isenteredtomostplayed = true;
                                  }

                                  return LinearProgressIndicator(
                                    backgroundColor: Color(0xFF9DA8CD),
                                    color: Colors.white,
                                    minHeight: 2.5,
                                    value: value,
                                  );
                                },
                              ),
                            )))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

playingAudio(List<Songs> songs, int index) async {
  currentlyplaying = songs[index];
  playerMini.stop();

  playinglistAudio.clear();
  for (int i = 0; i < songs.length; i++) {
    playinglistAudio.add(Audio.file(songs[i].songurl!,
        metas: Metas(
          title: songs[i].songname,
          artist: songs[i].artist,
          id: songs[i].id.toString(),
        )));
  }

  await playerMini.open(Playlist(audios: playinglistAudio, startIndex: index),
      showNotification: true,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}

currentSongFinder(int? playingId) {
  for (Songs song in allsongs) {
    if (song.id == playingId) {
      currentlyplaying = song;
      break;
    }
  }
  recentObj.addrecent(currentlyplaying!);
}

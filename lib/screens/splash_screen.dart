import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tune_bliss/screens/library/most_played.dart';
import 'package:tune_bliss/screens/library/recent_played.dart';
import 'package:tune_bliss/screens/playlist/playlist_screen.dart';
import 'package:tune_bliss/screens/user_details.dart';
import '../database/model/liked_model/liked_model.dart';
import '../database/model/playlist_model/playlist_model.dart';
import '../functions/fetch_songs.dart';
import '../model/song_model.dart';
import 'bottom_nav.dart';
import 'liked/liked_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final audioQuery = OnAudioQuery();

  // @override
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 3000), () async {
        await fetchSongs();

        final userNameDb = await Hive.openBox<String>('userName');
        if (userNameDb.isNotEmpty) {
          userId = userNameDb.values.last;
                                Get.off(BottomNav());

        } else {
                                Get.off(BottomNav());

        }
      });
    });
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: displayHeight,
        width: displayWidth,
        decoration: BoxDecoration(gradient: bodyGradient),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                  image: AssetImage('assets/images/splashAnimation.gif'),
                  width: displayWidth,
                  height: displayHeight * .9),
            ),
          ],
        )),
      ),
    );
  }

  fetchSongs() async {
    final status = await requestPermission();
    if (status) {
      List<SongModel> fetchsongs = await audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      for (SongModel element in fetchsongs) {
        if (element.fileExtension == 'mp3') {
          allsongs.add(Songs(
              songname: element.displayNameWOExt,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri));
        }
      }
    }
    await favFetching();
    await playlistfetch();
    await mostplayedfetch();
    await recentFetch();
  }

  Future favFetching() async {
    List<LikedSongs> favSongCheck = [];
    Box<LikedSongs> likeddb = await Hive.openBox('likedsongs');

    favSongCheck.addAll(likeddb.values);

    for (var favs in favSongCheck) {
      int count = 0;
      for (var songs in allsongs) {
        if (favs.id == songs.id) {
          favObj.likedSongs.add(songs);
          continue;
        } else {
          count++;
        }
      }
      if (count == allsongs.length) {
        var key = favs.key;
        likeddb.delete(key);
      }
    }
    likeddb.close();
  }

  Future playlistfetch() async {
    Box<PlaylistModal> playlistDB = await Hive.openBox('playlist');
    for (PlaylistModal element in playlistDB.values) {
      String name = element.playlistName;
      EachPlaylist playlistfetch = EachPlaylist(playlistName: name);
      if (element.playlistSongID.isNotEmpty) {
        for (int id in element.playlistSongID) {
          for (Songs songs in allsongs) {
            if (id == songs.id) {
              playlistfetch.playlistSongs.add(songs);
              break;
            }
          }
        }
      }
      playlistObj.playlist.add(playlistfetch);
    }
    playlistDB.close();
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  mostplayedfetch() async {
    Box<int> mostplayedDb = await Hive.openBox('mostplayed');
    if (mostplayedDb.isEmpty) {
      for (Songs song in allsongs) {
        mostplayedDb.put(song.id, 0);
      }
    } else {
      List<List<int>> mostplayedTemp = [];
      for (Songs song in allsongs) {
        int count = mostplayedDb.get(song.id)!;
        mostplayedTemp.add([song.id!, count]);
      }
      for (int i = 0; i < mostplayedTemp.length - 1; i++) {
        for (int j = i + 1; j < mostplayedTemp.length; j++) {
          if (mostplayedTemp[i][1] < mostplayedTemp[j][1]) {
            List<int> temp = mostplayedTemp[i];
            mostplayedTemp[i] = mostplayedTemp[j];
            mostplayedTemp[j] = temp;
          }
        }
      }
      List<List<int>> temp = [];
      for (int i = 0; i < mostplayedTemp.length && i < 10; i++) {
        temp.add(mostplayedTemp[i]);
      }
      mostplayedTemp = temp;
      for (List<int> element in mostplayedTemp) {
        for (Songs song in allsongs) {
          if (element[0] == song.id && element[1] > 3) {
            mostPlayedObj.mostPlayedList.add(song);
          }
        }
      }
    }
  }

  recentFetch() async {
    Box<int> recentdb = await Hive.openBox('recent');

    List<Songs> recentlist = [];

    for (var element in recentdb.values) {
      for (Songs songs in allsongs) {
        if (element == songs.id) {
          recentlist.add(songs);
          break;
        }
      }
      recentObj.recentSongs.value = recentlist.reversed.toList();
    }
  }
}

String userId = 'UserID#4546';

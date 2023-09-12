import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tune_bliss/screens/library/most_played.dart';

import '../database/model/playlist_model/playlist_model.dart';
import '../model/song_model.dart';
import '../screens/playlist/playlist_screen.dart';

List<Songs> allsongs = [];

class FetchSong {
  final _audioQuery = OnAudioQuery();
  fetchSongs() async {
    if (await requestPermission()) {
      List<SongModel> fetchsongs = [];
      fetchsongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      for (SongModel element in fetchsongs) {
        allsongs.add(Songs(
            songname: element.displayNameWOExt,
            artist: element.artist,
            duration: element.duration,
            id: element.id,
            songurl: element.uri));
      }
    }
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_bliss/database/functions/playlist_db_function.dart';
import 'package:tune_bliss/screens/playlist/current_playlist.dart';
import 'package:tune_bliss/screens/playlist/playlist_screen.dart';
import '../../../model/song_model.dart';

class AddSongToPlaylist extends StatelessWidget {
  AddSongToPlaylist({super.key, required this.object, required this.song});
  final EachPlaylist object;
  final Songs song;
  // late bool isadded;

  @override
  Widget build(BuildContext context) {
    // isadded = object.playlistSongs.contains(song);
    return GetBuilder(
      init: playlistObj,
      builder: (controller) => IconButton(
          onPressed: () {
            if (!object.playlistSongs.contains(song)) {
              object.playlistSongs.add(song);
              playlistObj.playlistAddDB(song, object.playlistName);

              // currentPlaylistBodyNotifier.notifyListeners();
            } else {
              object.playlistSongs.remove(song);
              playlistObj.playlistRemoveDB(song, object.playlistName);

              // currentPlaylistBodyNotifier.notifyListeners();
            }
          },
          icon: object.playlistSongs.contains(song)
              ? Icon(Icons.remove)
              : Icon(Icons.add)),
    );
  }
}

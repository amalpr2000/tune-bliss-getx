import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tune_bliss/database/model/liked_model/liked_model.dart';
import 'package:tune_bliss/model/song_model.dart';

class FavController extends GetxController {
  var likedSongs = [].obs;

  addToLiked(Songs song) async {
    likedSongs.add(song);

    Box<LikedSongs> likeddb = await Hive.openBox('likedsongs');

    LikedSongs likedSongModel = LikedSongs(id: song.id);
    print(likeddb.values);
    likeddb.add(likedSongModel);
    likeddb.close();
  }

  removeFromLiked(Songs song) async {
    likedSongs.remove(song);
    List<LikedSongs> templist = [];
    Box<LikedSongs> likeddb = await Hive.openBox('likedsongs');
    templist.addAll(likeddb.values);

    for (var elements in templist) {
      if (elements.id == song.id) {
        var key = elements.key;
        likeddb.delete(key);
        break;
      }
    }
  }
}

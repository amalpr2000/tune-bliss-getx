import 'package:hive_flutter/hive_flutter.dart';

import '../../model/song_model.dart';
import '../../screens/liked/liked_screen.dart';
import '../model/liked_model/liked_model.dart';

// addToLiked(Songs song) async {
//   likedSongsNotifier.value.add(song);

//   Box<LikedSongs> likeddb = await Hive.openBox('likedsongs');

//   LikedSongs likedSongModel = LikedSongs(id: song.id);

//   likeddb.add(likedSongModel);
//   likeddb.close();
// }

// removeFromLiked(Songs song) async {
//   likedSongsNotifier.value.remove(song);
//   List<LikedSongs> templist = [];
//   Box<LikedSongs> likeddb = await Hive.openBox('likedsongs');
//   templist.addAll(likeddb.values);

//   for (var elements in templist) {
//     if (elements.id == song.id) {
//       var key = elements.key;
//       likeddb.delete(key);
//       break;
//     }
//   }
// }

// hello()async{

// final song=await Hive.openBox<Songs>('trial');
// final model=Songs(songname: 'ff', artist: 'artist', duration: 1, id: 1, songurl: 'songurl');
// song.put(1, model);
//  List<Songs> newlist=[];
// newlist.addAll(song.values);

// }

hi() async {
  final box = await Hive.openBox<EachPlaylist>('asdf');
  final model = EachPlaylist(playlistName: 'asdf');
  box.add(model);
  box.putAt(5, model); 
  box.deleteAt(1);
  box.put(5, model);
  List<EachPlaylist> list = [];
  // list.addAll(box.values);
}




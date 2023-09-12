import 'package:get/get.dart';
import 'package:tune_bliss/functions/fetch_songs.dart';
import 'package:tune_bliss/model/song_model.dart';

class SearchController extends GetxController{
  
  List<Songs> searchList = List<Songs>.from(allsongs);

  search(String value) {
    searchList = allsongs
        .where((element) =>
            element.songname!.toLowerCase().contains(value.toLowerCase()))
        .toList();
        update();
  }
}




import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tune_bliss/functions/fetch_songs.dart';
import 'package:tune_bliss/model/song_model.dart';

class MostPlayedController{



var mostPlayedList = <Songs>[].obs;

mostplayedaddtodb(int id) async {

  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  int count = mostplayedDb.get(id)!;
  mostplayedDb.put(id, count + 1);
  await mostplayedaddtolist();

}

mostplayedaddtolist() async {
  Box<int> mostplayedDb = await Hive.openBox('mostplayed');
  mostPlayedList.clear();
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
        mostPlayedList.add(song);
      }
    }
  }
  // mostPlayedList.notifyListeners();
}


}
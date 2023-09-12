import 'package:get/get.dart';
import 'package:tune_bliss/screens/home/miniplayer.dart';

class NowPlayingController extends GetxController {
  RxBool isrepeat = false.obs;
  RxBool isShuffle = false.obs;
  RxBool isPlaying = true.obs;

  shuffleFunction(bool value) {
    isShuffle.value = value;
  }

  playPause() {
    isPlaying.value = !isPlaying.value;
  }
}

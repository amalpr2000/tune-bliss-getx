class Songs {
  String? songname;
  String? artist;
  int? duration;
  String? songurl;
  int? id;
  Songs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songurl});
}

class EachPlaylist {
  String playlistName;
  List<Songs> playlistSongs = [];
  EachPlaylist({required this.playlistName});
}

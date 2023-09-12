import 'package:hive_flutter/hive_flutter.dart';
part 'liked_model.g.dart';

@HiveType(typeId: 0)
class LikedSongs extends HiveObject {
  @HiveField(0)
  int? id;
  LikedSongs({required this.id});
}




hi() async{
  Box<LikedSongs> likedatabase=await Hive.openBox('like');

  List temp=[];
  temp.addAll(likedatabase.values);

  LikedSongs likeobj=LikedSongs(id: 1);
  likedatabase.add(likeobj);

  likedatabase.put(1, likeobj);
}
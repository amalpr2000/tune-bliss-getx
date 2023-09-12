import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'database/model/liked_model/liked_model.dart';
import 'database/model/playlist_model/playlist_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(LikedSongsAdapter().typeId)) {
    Hive.registerAdapter(LikedSongsAdapter());
  }
  if (!Hive.isAdapterRegistered(PlaylistModalAdapter().typeId)) {
    Hive.registerAdapter(PlaylistModalAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

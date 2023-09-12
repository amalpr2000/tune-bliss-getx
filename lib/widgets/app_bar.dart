import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_bliss/screens/search_screen.dart';

import '../screens/settings_screen.dart';

class AppBarRow extends StatelessWidget {
  AppBarRow({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => Search(),
            // ));
            Get.to(Search());
          },
          icon: Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.to(Settings());
          },
          icon: Icon(
            Icons.settings,
            color: Colors.white,
            size: 25,
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home/home_screen.dart';
import 'library/library_screen.dart';
import 'liked/liked_screen.dart';
import 'playlist/playlist_screen.dart';

LinearGradient bodyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF07014F), Color(0xFF020326)]);

class BottomNav extends StatelessWidget {
  var currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    List<Widget> screens = [
      HomePage(),
      Playlist(),
      Liked(displayWidth: displayWidth),
      MyLibrary()
    ];

    return Obx(
      () => Scaffold(
        extendBody: true,
        body: Container(
          height: displayHeight,
          width: displayWidth,
          decoration: BoxDecoration(gradient: bodyGradient),
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(
                    right: displayWidth * .05,
                    left: displayWidth * .05,
                    top: displayWidth * .05),
                child: screens.elementAt(currentIndex.value)),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(displayWidth * .06),
          height: displayWidth * .155,
          decoration: BoxDecoration(
            color: Color(0xFF07014F),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: listOfIcons.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                currentIndex.value = index;
                HapticFeedback.lightImpact();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex.value
                        ? displayWidth * .32
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height:
                          index == currentIndex.value ? displayWidth * .12 : 0,
                      width:
                          index == currentIndex.value ? displayWidth * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex.value
                            ? Color(0xFF20225D)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex.value
                        ? displayWidth * .31
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex.value
                                  ? displayWidth * .13
                                  : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == currentIndex.value ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == currentIndex.value
                                    ? '${listOfStrings[index]}'
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == currentIndex.value
                                  ? displayWidth * .03
                                  : 20,
                            ),
                            Icon(
                              listOfIcons[index],
                              size: displayWidth * .076,
                              color: index == currentIndex.value
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.playlist_play_rounded,
    Icons.favorite_rounded,
    Icons.library_music_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Playlist',
    'Liked',
    'Library',
  ];
}

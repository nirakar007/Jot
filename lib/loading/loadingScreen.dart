import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});


  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {


  late FlutterGifController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = FlutterGifController(vsync: this);
    // loop from 0 frame to 29 frame
    controller.repeat(min:0, max:29, period:const Duration(milliseconds:1));

// jumpTo thrid frame(index from 0)
    controller.value = 0;

// from current frame to 26 frame
    controller.animateTo(23,duration: Duration(milliseconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

      child:
      GifImage(
        controller: controller,
        image: const AssetImage("assets/gif/introScreen.gif"),
      )



    ,
      ),
    );
  }
}

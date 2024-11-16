import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool showTitle = false;
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    startAnimationSequence();
  }

  Future<void> startAnimationSequence() async {
    await Future.delayed(
      const Duration(seconds: 7),
    );
    setState(() {
      showTitle = true;
      showLoading = false;
    });
    await Future.delayed(
      const Duration(seconds: 2), 
    );
    Navigator.popAndPushNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if(showLoading)
              Center(
                child: Lottie.asset(
                  "assets/splashLogo/Animation - 1731764985164.json",
                ),
              ),
              Center(
                child: AnimatedOpacity(
                  opacity: showTitle ? 1.0 : 0.0, 
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    "assets/app_title/b456015b7c55a8d7addfca493fc01420.png",
                    width: devicewidth*0.7,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

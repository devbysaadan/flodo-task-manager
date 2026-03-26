import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kaaju/screens/homepage/home_page.dart';
import 'package:kaaju/screens/registration/registration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override

  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    
    Future.delayed(Duration(seconds: 3),() {
      if (!mounted) return;
      final box = GetStorage();
      final bool isRegistered = box.read('isRegistered') ?? false;
      
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=> isRegistered ? const HomePage() : const HomeScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3c096c),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(),
            Text('KaaJu',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              color: Color(0xffE0AAFF)
            ),
            ).animate().fadeIn(duration: 800.ms)
          ],
        ),
      ),
    );
  }
}

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override

  Widget build(BuildContext context) {
    return Animate(
      effects: [FadeEffect(delay: 500.ms), ScaleEffect(duration: 500.ms)],
        child: Image(image: AssetImage('assets/images/logo.png'))
    );
  }
}

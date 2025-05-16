import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LandingPage());
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Solid black background
      body: Column(
        children: [
          // Smaller image at the top
          Container(
            width: double.infinity,
            height: 500, // Kept your adjusted height
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bread-landing.png'),
                fit: BoxFit.contain, // Ensures image fits without stretching
              ),
            ),
          ),
          // Text below the image with limited expansion
          Expanded(
            flex: 2, // Reduced flex to give more space to the button area
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pay less, Eat More!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Where sweet treats meet sweet deals.\nIndulge in delightful pastries without the guilt or the high price!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button moved higher with adjusted spacing
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 50.0,
              left: 16.0,
              right: 16.0,
            ), // Increased top padding, reduced bottom
            child: SizedBox(
              width: double.infinity, // Full screen width
              child: ElevatedButton(
                onPressed: () {
                  // Add navigation or action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

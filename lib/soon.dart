import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'SettingsProvider.dart'; // Import the SettingsProvider

class ComingSoonScreen extends StatefulWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  _ComingSoonScreenState createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Define the scaling animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current settings from the provider
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animate the watch icon with scaling effect
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.watch_later,
                size: 100,
                color: settings.isDarkMode ? Colors.white : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            // Animated text that changes opacity for a modern effect
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Coming Soon...',
                  textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: settings.isDarkMode ? Colors.white : Colors.black,
                  ),
                  duration: const Duration(milliseconds: 4500),
                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 3,
            ),
            const SizedBox(height: 10),
            // Subtle text below with a fade-in effect
            FadeTransition(
              opacity: _controller,
              child: Text(
                'We\'re working hard to bring you this feature!',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: settings.isDarkMode ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
    );
  }
}

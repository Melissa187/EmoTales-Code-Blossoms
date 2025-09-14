import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html; // Flutter Web only

void main() => runApp(const EmotalesApp());

class EmotalesApp extends StatelessWidget {
  const EmotalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotales Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.comicNeueTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const EmotalesHomePage(),
    );
  }
}

class EmotalesHomePage extends StatefulWidget {
  const EmotalesHomePage({super.key});

  @override
  State<EmotalesHomePage> createState() => _EmotalesHomePageState();
}

class _EmotalesHomePageState extends State<EmotalesHomePage> {
  final TextEditingController _controller = TextEditingController();

  // Chat messages: {'sender':'user'/'bot', 'text':...}
  final List<Map<String, String>> _messages = [];

  // Moods, colors, icons, and video links
  final Map<String, Color> _moodColors = {
    "Happy": Colors.amberAccent.shade100,
    "Calm": Colors.lightGreen.shade200,
    "Sad": Colors.blue.shade200,
    "Brave": Colors.deepOrange.shade200,
    "Excited": Colors.pinkAccent.shade100,
    "Sleepy": Colors.purple.shade100,
    "Cozy": Colors.orange.shade100,
  };

  final Map<String, IconData> _moodIcons = {
    "Happy": Icons.sentiment_very_satisfied,
    "Calm": Icons.self_improvement,
    "Sad": Icons.sentiment_very_dissatisfied,
    "Brave": Icons.local_fire_department,
    "Excited": Icons.emoji_emotions,
    "Sleepy": Icons.bedtime,
    "Cozy": Icons.wb_sunny,
  };

  final Map<String, String> _moodLinks = {
    "Happy": 'https://www.youtube.com/watch?v=DC7Y6sC7Ae4',
    "Calm": 'https://youtu.be/Zu5EOcd-L4U?si=vE6F1pGZyJkNtkVU',
    "Sad": 'https://www.youtube.com/watch?v=AOugNiqUXYE',
    "Brave": 'https://youtu.be/ot4nXeZUMcc?si=7SxA3ynDKSiSmRKI',
    "Excited": 'https://youtu.be/Fk7A-pd82Kg?si=4cGtlsaCy1GDmLk9',
    "Sleepy": 'https://youtu.be/_mhJPa46Qs4?si=NACd9yAJKffVOyU1',
    "Cozy": 'https://youtu.be/MYPVQccHhAQ?si=gJdE969HDA0lEl1f',
  };

  // Keywords for smart mood detection
  final Map<String, List<String>> _moodKeywords = {
    "Happy": ["happy", "joy", "glad", "excited", "yay"],
    "Calm": ["calm", "relaxed", "peaceful", "serene"],
    "Sad": ["sad", "down", "blue", "unhappy", "depressed"],
    "Brave": ["brave", "courage", "bold", "fearless"],
    "Excited": ["excited", "thrilled", "amazing", "wow"],
    "Sleepy": ["sleepy", "tired", "zzz", "sleep"],
    "Cozy": ["cozy", "warm", "snug", "comfortable"],
  };

  // Open link in new tab
  void _openVideoLink(String url) {
    html.window.open(url, '_blank');
  }

  // Send mood (from button or text input) with smart keyword detection
  void _sendMood(String input) {
    String key = "Happy"; // default mood
    String userInput = input.toLowerCase();

    // Check keywords
    _moodKeywords.forEach((mood, keywords) {
      for (var word in keywords) {
        if (userInput.contains(word)) {
          key = mood;
          break;
        }
      }
    });

    // Update chat messages
    setState(() {
      _messages.add({'sender': 'user', 'text': 'I feel $input 😅'});
      _messages.add({'sender': 'bot', 'text': 'Here’s a story for your $key mood! 🌸'});
    });

    // Open the video link
    _openVideoLink(_moodLinks[key]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '🌸 Emotales Chatbot 🌸',
                textAlign: TextAlign.center,
                style: GoogleFonts.caveat(
                  textStyle: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A)),
                ),
              ),
              const SizedBox(height: 16),

              // Mood buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _moodColors.keys.map((mood) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _sendMood(mood),
                        icon: Icon(_moodIcons[mood], size: 28),
                        label: Text(
                          mood,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _moodColors[mood],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                          shadowColor: Colors.pinkAccent.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Chat area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.pink.shade100.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      bool isUser = msg['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.pink.shade200 : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(msg['text']!, style: const TextStyle(fontSize: 16)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Input field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your mood here...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMood(_controller.text.trim());
                        _controller.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

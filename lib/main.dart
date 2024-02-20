import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_app/views/chat.dart';
import 'package:gemini_app/views/chat_speech.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyBMxju6DQRU81wgfft6iIFFmiceCqC8Ghc');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatSpeechScreen(),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatSpeechScreen extends StatefulWidget {
  const ChatSpeechScreen({super.key});

  @override
  State<ChatSpeechScreen> createState() => _ChatSpeechScreenState();
}

class _ChatSpeechScreenState extends State<ChatSpeechScreen> {
  TextEditingController inputController = TextEditingController();
  TextEditingController responseController = TextEditingController();
  final gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Chat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: 'Enter a message',
                  suffixIcon: IconButton(
                    onPressed: inputController.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              ElevatedButton(
                onPressed: () {
                  gemini
                      .streamGenerateContent(inputController.text)
                      .listen((value) {
                    responseController.text = value.output.toString();
                  }).onError((e) {
                    log('streamGenerateContent exception', error: e);
                  });
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 50,),
              TextField(
                controller: responseController,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

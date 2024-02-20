import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatSpeechScreen extends StatefulWidget {
  const ChatSpeechScreen({super.key});

  @override
  State<ChatSpeechScreen> createState() => _ChatSpeechScreenState();
}

class _ChatSpeechScreenState extends State<ChatSpeechScreen> {
  TextEditingController inputController = TextEditingController();
  TextEditingController responseController = TextEditingController();
  final gemini = Gemini.instance;

  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });

    if(result.recognizedWords.isNotEmpty){
      gemini
          .streamGenerateContent(lastWords)
          .listen((value) {
        responseController.text = value.output.toString();
      }).onError((e) {
        log('streamGenerateContent exception', error: e);
      });
    }

  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();



    setState(() {});
  }

  @override
  initState() {
    super.initState();
    initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Chat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    // If listening is active show the recognized words
                    speechToText.isListening
                        ? lastWords
                    // If listening isn't active but could be tell the user
                    // how to start it, otherwise indicate that speech
                    // recognition is not yet ready or not supported on
                    // the target device
                        : speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
                  ),
                ),
              ),
              Text(lastWords, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 12,),
              // ElevatedButton(
              //   onPressed: () {
              //     gemini
              //         .streamGenerateContent(inputController.text)
              //         .listen((value) {
              //       responseController.text = value.output.toString();
              //     }).onError((e) {
              //       log('streamGenerateContent exception', error: e);
              //     });
              //   },
              //   child: const Text('Submit'),
              // ),
              const SizedBox(height: 50,),
              TextField(
                controller: responseController,
                maxLines: null,
              ),
              const SizedBox(height: 200,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        // If not yet listening for speech start, otherwise stop
        speechToText.isNotListening ? startListening : stopListening,
        tooltip: 'Listen',
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}

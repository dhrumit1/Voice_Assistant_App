import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:gpt/DrawerPage.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:gpt/openAI_service.dart';
import 'package:gpt/recentData.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_translate/flutter_translate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = "";
  final OpenAIservice openAIservic = OpenAIservice();
  // final flutterTts = FlutterTts();
  String? generatedContent;
  String? generateImagesUrl;
  bool micGlow = false;

  List<RecentData> recentData = [];

  // SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    // initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  // Future<void> initTextToSpeech() async {
  //   setState(() {

  //   });

  // }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  // Future<void> systemSpeak(String content) async {
  //   await flutterTts.speak(content);
  //   setState(() {

  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    // flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Assistant App"),
        titleSpacing: 30.00,
      ),
      drawer: DrawerPage(recentData),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Center(
              child: Image.asset(
                "images/bot1.jpg",
                height: 150,
                width: 150,
              ),
            ),
          ),
          Visibility(
            visible: generateImagesUrl == null,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black54,
                ),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  generatedContent == null
                      ? 'Good morning, what task can i do for you?'
                      : generatedContent!,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: generatedContent == null ? 18 : 13),
                ),
              ),
            ),
          ),
          if (generateImagesUrl != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generateImagesUrl!)),
            ),
          Visibility(
            visible: generatedContent == null && generateImagesUrl == null,
            child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  'Here are a few features',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ),
          Visibility(
              visible: generatedContent == null && generateImagesUrl == null,
              child: Column()),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: AvatarGlow(
        animate: micGlow,
        glowColor: Colors.deepPurpleAccent,
        endRadius: 60.0,
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
              setState(() {
                micGlow = true;
              });
            } else if (speechToText.isListening) {
              RecentData rd = new RecentData();
              rd.question = lastWords;
              final speech = await openAIservic.chatGPTAPI(lastWords);
              rd.answere = speech;
              recentData.add(rd);
              print(speech);
              if (speech.contains('https')) {
                generateImagesUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generateImagesUrl = null;
                generatedContent = speech;
                setState(() {});
                // await systemSpeak(speech);
              }
              await stopListening();
              setState(() {
                micGlow = false;
              });
            } else {
              initSpeechToText();
              micGlow = true;
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TtsState { playing, stopped }

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool speaking = false;

  bool darkMode = false;
  toggleDarkMode(){
    setState(() {
      darkMode = !darkMode;
      print(darkMode);
    });
  }

  final textHolder = TextEditingController();
  clearTextInput(){
    textHolder.clear();
  }

  String _newVoiceText;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
        speaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        speaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print("lang: ${languages}");
    if (languages != null) setState(() => languages);
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
        speaking = true;
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    speaking = false;
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (String type in languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
    });
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return languages != null ? Scaffold(
      backgroundColor: darkMode ? Colors.grey[850] : Colors.grey[300],
      appBar: AppBar(
        title: Center(
          child: Text(
            'TYPSAY',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontFeatures: [FontFeature.enable('smcp')],
                color: darkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
                letterSpacing: .5,
                fontSize: 29,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _inputSection(),
            languages != null ? _languageDropDownSection() : Text(""),
            _buildSliders(),
            bottomBar(),
          ],
        ),
      ),
    ):
    Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.black,
          size: 100.0,
        ),
      ),
    );
  }

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
      child: Neumorphic(
        margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
        style: NeumorphicStyle(
          color: darkMode ? Colors.grey[850] : Colors.grey[300],
          depth: NeumorphicTheme.embossDepth(context),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(29)),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: TextField(
          enableInteractiveSelection: true,
          toolbarOptions: ToolbarOptions(
            paste: true,
            cut: true,
            copy: true,
            selectAll: true,
          ),
          autofocus: false,
          controller: textHolder,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontFeatures: [FontFeature.enable('smcp')],
              color: darkMode ? Colors.white : Colors.black,
              letterSpacing: .5,
            ),
          ),
          maxLines: 9,
          decoration: InputDecoration.collapsed(
            hintText: "type to say something...",
            hintStyle: TextStyle(
              fontFeatures: [FontFeature.enable('smcp')],
              color: Colors.grey,
            ),
          ),
          onChanged: (String value) {
            _onChange(value);
          },
        ),
      ));

  Widget _languageDropDownSection() => Container(
    padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
    child: Neumorphic(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      style: NeumorphicStyle(
        color: darkMode ? Colors.grey[850] : Colors.grey[300],
        boxShape: NeumorphicBoxShape.stadium(),
      ),
      child: DropdownButton(
        elevation: 99,
        dropdownColor: darkMode ? Colors.grey[850] : Colors.grey[300],
        style: TextStyle(
          fontFeatures: [FontFeature.enable('smcp')],
          color: darkMode ? Colors.white : Colors.black,
          letterSpacing: .5,
        ),

        hint: Text(
          "LANG",
          style: TextStyle(
            color: darkMode ? Colors.white : Colors.black,
          ),
        ),
        value: language,
        items: getLanguageDropDownMenuItems(),
        onChanged: changedLanguageDropDownItem,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        underline: SizedBox(),
      ),
    ),
  );

  Widget _buildSliders() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sliderTitle("VOLUME"),
        _volume(),
        SizedBox(
          height: 9,
        ),
        _sliderTitle("PITCH"),
        _pitch(),
        SizedBox(
          height: 9,
        ),
        _sliderTitle("RATE"),
        _rate(),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _sliderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Neumorphic(
        style: NeumorphicStyle(
          color: darkMode ? Colors.grey[850] : Colors.grey[300],
          depth: NeumorphicTheme.embossDepth(context),
          boxShape: NeumorphicBoxShape.stadium(),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: Text(
          title,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontFeatures: [FontFeature.enable('smcp')],
              color: darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _volume() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: NeumorphicSlider(
        style: SliderStyle(
          accent: darkMode ? Colors.grey[900] : Colors.grey,
          variant: darkMode ? Colors.grey[900] : Colors.grey,
        ),
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
      ),
    );
  }

  Widget _pitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: NeumorphicSlider(
        style: SliderStyle(
          accent: darkMode ? Colors.grey[900] : Colors.grey,
          variant: darkMode ? Colors.grey[900] : Colors.grey,
        ),
        value: pitch,
        onChanged: (newPitch) {
          setState(() => pitch = newPitch);
        },
        min: 0.5,
        max: 2.0,
      ),
    );
  }

  Widget _rate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: NeumorphicSlider(
        style: SliderStyle(
          accent: darkMode ? Colors.grey[900] : Colors.grey,
          variant: darkMode ? Colors.grey[900] : Colors.grey,
        ),
        value: rate,
        onChanged: (newRate) {
          setState(() => rate = newRate);
        },
        min: 0.0,
        max: 1.0,
      ),
    );
  }

  Widget bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NeumorphicButton(
          style: NeumorphicStyle(
            color: darkMode ? Colors.grey[850] : Colors.grey[300],
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.wb_sunny_outlined, size: 40,
            color: darkMode ? Colors.white : Colors.black,),
          onPressed: toggleDarkMode,
        ),
        SizedBox(width: 29),
        NeumorphicButton(
          style: NeumorphicStyle(
            color: darkMode ? Colors.grey[850] : Colors.grey[300],
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.refresh_rounded, size: 40,
            color: darkMode ? Colors.white : Colors.black,),
          onPressed: clearTextInput,
        ),
        SizedBox(width: 29),
        speaking
            ? NeumorphicButton(
          style: NeumorphicStyle(
            color: darkMode ? Colors.grey[850] : Colors.grey[300],
            shape: NeumorphicShape.convex,
            boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.stop_circle_rounded, size: 40,
            color: darkMode ? Colors.white : Colors.black,),
          onPressed: _stop,
        )
            : NeumorphicButton(
          style: NeumorphicStyle(
            color: darkMode ? Colors.grey[850] : Colors.grey[300],
            shape: NeumorphicShape.convex,
            boxShape:
            NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.play_arrow_rounded, size: 40,
            color: darkMode ? Colors.white : Colors.black,),
          onPressed: _speak,
        ),
        SizedBox(width: 29),
        NeumorphicButton(
          style: NeumorphicStyle(
            color: darkMode ? Colors.grey[850] : Colors.grey[300],
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(Icons.info_outlined, size: 40,
            color: darkMode ? Colors.white : Colors.black,),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return AboutScreen(darkMode: darkMode,);
                }));
          },
        ),
      ],
    );
  }
}

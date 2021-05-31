import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({@required this.darkMode});

  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
            color: darkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'ABOUT US',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontFeatures:[FontFeature.enable('smcp')],
              color: darkMode ? Colors.white : Colors.black87,
              letterSpacing: .5,
              fontSize: 30,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: darkMode ? Colors.grey[850] : Colors.grey[300],
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(99)),
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        color: darkMode ? Colors.grey[850] : Colors.grey[300],
                    ),
                    child: Image.asset(
                      "assets/images/about.png",
                      height: 140,
                    ),
                ),
                SizedBox(height: 30,),
                Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                    color: darkMode ? Colors.grey[850] : Colors.grey[300],
                  ),
                  child: Container(
                    height: (150),
                    width: (150),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/humanimaly_logo.png"),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: 8,
                        lightSource: LightSource.topLeft,
                        color: darkMode ? Colors.grey[850] : Colors.grey[300],
                      ),
                      child: Container(
                        height: (100),
                        width: (100),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/male.png"),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: (20)),
                Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                    color: darkMode ? Colors.grey[850] : Colors.grey[300],
                  ),
                  child: Text(
                    '\n Thanks for checking us out!\nThis app is made by Yeshwin Anil\n'
                        ' The project was created as a part of  \nlearning neumorphic designs.'
                        '  \nWe hope you liked our work!\n  ',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontFeatures:[FontFeature.enable('smcp')],
                        color: darkMode ? Colors.white : Colors.grey[500],
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: (10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

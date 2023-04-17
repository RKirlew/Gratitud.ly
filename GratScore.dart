import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
class GratScore extends StatefulWidget {
  const GratScore({Key? key}) : super(key: key);

  @override
  State<GratScore> createState() => _GratScoreState();
}

class _GratScoreState extends State<GratScore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Low Mood Tips',style: GoogleFonts.inter(),),
    backgroundColor: Color(0xFF49DED2),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {

    Navigator.pop(context);
    },
    ),
    ),
    );
  }
}

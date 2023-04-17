import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratus/Welcome.dart';
import 'package:gratus/components/Tracker.dart';

import 'JournalPage.dart';
import 'MoodDiary.dart';
import 'SettingsPage.dart';

class MyBottomNavBar extends StatefulWidget {
  final User? user;
  const MyBottomNavBar({Key? key, this.user}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Color(0xFF49DED2),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedLabelStyle: GoogleFonts.inter(),
        unselectedLabelStyle: GoogleFonts.inter(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        currentIndex: _currentIndex,

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              tooltip: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Profile'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_rounded),
            label: 'Mood Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracker',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GratitudePage(widget.user)));
          }
          else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage(user:widget.user)));
          } else if (index == 2) {
            // Navigate to journal page
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JournalPage(user:widget.user)));
          }
          else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MoodDiary(user:widget.user)));
          }
          else if (index == 4) {
            // Navigate to journal page
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Tracker(user:widget.user)));
          }
        },
      ),
    );
  }
}

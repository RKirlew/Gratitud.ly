import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:gratus/SignUpPage.dart';
import 'package:gratus/components/SettingsPage.dart';

import '../LoginPage.dart';
class SideBar extends StatelessWidget {
  final User? user;
  const SideBar({Key? key,this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 100,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color:Color(0xFF4B8C5D),
            ),
            child: Text(
                '${user?.displayName}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                )
            ),
          ),
        ),ListTile(
          leading: Icon(Icons.settings,color: Color(0xFF576954),size: 30,),
          title:Text(
              'Settings',
              style: GoogleFonts.inter(
                color: Color(0xFF13678A),
                fontSize: 20,

              )
          ),

          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage(user:user)));
          },
        ),
        ListTile(
          leading: Icon(Icons.book,color: Color(0xFF576954),size: 30,),
          title:Text(
              'Gratitude Journal',
              style: GoogleFonts.inter(
                color: Color(0xFF13678A),
                fontSize: 20,

              )
          ),

          onTap: () {
            // Navigate to settings page
          },
        ),
        ListTile(
          leading: Icon(Icons.emoji_emotions_rounded,color: Color(0xFF576954),size: 30,),
          title:Text(
              'Mood Diary',
              style: GoogleFonts.inter(
                color: Color(0xFF13678A),
                fontSize: 20,

              )
          ),

          onTap: () {
            // Navigate to settings page
          },
        ),
        ListTile(
          leading: Icon(Icons.track_changes,color: Color(0xFF576954),size: 30,),
          title:Text(
              'Gratitude Tracker',
              style: GoogleFonts.inter(
                color: Color(0xFF13678A),
                fontSize: 20,

              )
          ),

          onTap: () {
            // Navigate to settings page
          },
        ),

        Padding(
          padding: const EdgeInsets.only(top:500.0),
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Color(0xFF576954),
              size: 30,
            ),
            title: Text(
              'Log Out',
              style: GoogleFonts.inter(
                color: Color(0xFF13678A),
                fontSize: 20,
              ),
            ),
            onTap: () async {
              // Navigate to about page
              await googleSignIn.signOut();
              print('Signing out of Google account...');

              try {
                await FirebaseAuth.instance.signOut();
                print('User is signed out and logged out!');
              } catch (e) {
                print('Error signing out of Firebase: $e');
              }

              googleSignIn.disconnect();
              FirebaseAuth.instance.authStateChanges();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}

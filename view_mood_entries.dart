import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratus/components/MoodDiary.dart';
import 'package:intl/intl.dart';

import '../Welcome.dart';

List<String> imageUrls = [  'https://images.unsplash.com/photo-1438786657495-640937046d18?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://images.unsplash.com/photo-1678723097718-8c7f5ece3a3c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8NnNNVmpUTFNrZVF8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=60',
  'https://images.unsplash.com/photo-1678719510034-a2d3efb68e85?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=718&q=80',
  'https://images.unsplash.com/photo-1678614034519-6d142721173f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
  'https://images.unsplash.com/photo-1678125690568-d3f224222aab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',];
int randomIndex = Random().nextInt(imageUrls.length);
String selectedImageUrl = imageUrls[randomIndex];
class ViewMoodEntry extends StatefulWidget {
  final User? user;

  const ViewMoodEntry({Key? key,  this.user}) : super(key: key);

  @override
  State<ViewMoodEntry> createState() => _ViewMoodEntryState();
}

class _ViewMoodEntryState extends State<ViewMoodEntry> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Mood Entries", style: GoogleFonts.inter(),),
          backgroundColor: Color(0xFF49DED2),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MoodDiary(user:widget.user)),
          );
        },
      ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('moodEntries')
              .where('user', isEqualTo: widget.user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text('Loading...');
            }

            List entries =
            snapshot.data!.docs.map((doc) => doc['moodEntry']).toList();
            List moodEntry =
            snapshot.data!.docs.map((doc) => doc['mood']).toList();
            List dateEntry = snapshot.data!.docs.map((doc) => DateFormat('MMM dd, yyyy').format(doc['date'].toDate())).toList();

            List<DocumentSnapshot> testEntries = snapshot.data!.docs;

            return Container(


              child:
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Stack(
                                children: [

                                  Dismissible(
                                    key:ValueKey<String>(entries[index]),
                                    onDismissed: (DismissDirection direction) {

                                      testEntries[index].reference.delete().then((value) {
                                        setState(() {
                                          entries.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Entry deleted successfully.'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      });
                                          },
                                    child: Container(

                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15.0),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrls[ Random().nextInt(imageUrls.length)]),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      height: 350.0,
                                      width: 250.0,

                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.0),
                                            Container(

                                              color: Colors.black.withOpacity(0.4),
                                              child: Text(
                                                '${dateEntry[index]}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Container(

                                              color: Colors.black.withOpacity(0.4),
                                              child: Text(
                                                '${moodEntry[index]}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Container(

                                                color: Colors.black.withOpacity(0.4),
                                                child: Text('${entries[index]}',style: GoogleFonts.inter(color: Colors.white),)
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),



                                ]
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),


            );
          },
        ),
      )
    );
  }
}

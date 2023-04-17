import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gratus/components/view_mood_entries.dart';
import 'package:intl/intl.dart';

import '../Welcome.dart';
class MoodDiary extends StatefulWidget {
  final User? user;

  const MoodDiary({Key? key,  this.user}) : super(key: key);

  @override
  State<MoodDiary> createState() => _MoodDiaryState();
}

class _MoodDiaryState extends State<MoodDiary> {
  String mood ="";
  bool absorbPointer=true;
  bool _showWidgets = false;
  final _entryController = TextEditingController();
  String _textFormFieldValue = '';
  void _toggleWidgets() {
    setState(() {
      _showWidgets = !_showWidgets;
    });
  }
  @override
  void initState() {
    super.initState();

  }
  @override

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    void setMood(String newMood) {
      setState(() {
        mood = newMood;
      });
    }
    final firestoreInstance = FirebaseFirestore.instance;

    String formattedDate = 'Today ${DateFormat('dd MMM').format(now)}';

    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Your Mood Diary',style: GoogleFonts.inter(),),
        backgroundColor: Color(0xFF49DED2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GratitudePage(widget.user)),
            );
          },
        ),
      ),
      body: Container(
        color: Color(0xB6F0FCFC),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           SizedBox(height: 2),
           Center(child: Text(formattedDate, style: GoogleFonts.inter(color: Colors.black.withOpacity(0.4),fontSize: 16.0))),
           SizedBox(height: 18),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('Hi ${widget.user?.displayName}',style: GoogleFonts.inter(color: Colors.grey
                 ,fontWeight: FontWeight.w400,fontSize: 18.0),),
           ),
           SizedBox(height: 18),
          Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'How are you feeling today?',
                  style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 20.0)
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
                GestureDetector(

                  onTap:(){

                      setMood("Happy");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));
                  },

                  child: SizedBox(
                  width: 112,
                  height: 100,
                  child: Container(
                  decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(12.0),
                  border:Border.all(
                  color:  Color(0xFF49DED2),
                  width: 3
                  ),
                  color:  Color(0xFF49DED2)
                  ),

                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\u{1F60A}',
                              style: TextStyle(fontSize: 40.0),
                            ),
                            Text(
                              'Happy',
                              style:GoogleFonts.inter(color:Colors.white,fontWeight:FontWeight.w500,fontSize: 16.0 ),
                            ),
                            SizedBox(height: 10.0),

                          ],
                        ),





                      ],
                    ),
                  )
                  ),
                ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Sad";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(12.0),
                          border:Border.all(
                              color:  Color(0xFF49DED2),
                              width: 3
                          ),
                          color:  Color(0xFF49DED2)
                      ),

                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F614}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Sad',
                                style:GoogleFonts.inter(color:Colors.white,fontWeight:FontWeight.w500,fontSize: 16.0 ),
                              ),
                              SizedBox(height: 10.0),

                            ],
                          ),





                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Excited";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(12.0),
                          border:Border.all(
                              color:  Color(0xFF49DED2),
                              width: 3
                          ),
                          color:  Color(0xFF49DED2)
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F929}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Excited',
                                style:GoogleFonts.inter(color:Colors.white,fontWeight:FontWeight.w500,fontSize: 16.0 ),
                              ),
                              SizedBox(height: 10.0),

                            ],
                          ),





                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Anxious";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F61F}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Anxious',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Grateful";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F64F}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Grateful',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Angry";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F620}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Angry',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Joyful";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F602}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Joyful',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Calm";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F60C}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Calm',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Loved";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{2764}\u{FE0F}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Loved',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),
              SizedBox(width: 18,),
              InkWell(
                onTap:(){
                  setState(() {
                    mood="Stressed";
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selected mood:${mood}")));

                  });
                },
                child: SizedBox(
                    width: 132,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Color(0xFF49DED2),
                              width: 3
                          ),
                          color: Color(0xFF49DED2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\u{1F62B}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                              Text(
                                'Stressed',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    )
                ),
              ),

            ],
          ),
        ),

       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text(
                 'Describe  your state of mind',
                 style: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w400, fontSize: 24.0)
             ),
       ),

           Container(

             child: Expanded(

               child: Container(

                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(125.0),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.03),
                       spreadRadius: 25,
                       blurRadius: 45,
                       offset: Offset(0, 25), // Shadow position, bottom
                     ),
                   ],),
                 child: FocusScope(
                   child: TextFormField(

                     maxLines: 13,
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     controller: _entryController,
                     decoration: InputDecoration(
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(25.0),
                         borderSide: BorderSide(
                             width: 3,
                             color: Color(0xFF49DED2)
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(25.0),
                         borderSide: BorderSide(
                             width: 3,
                             color:Color(0xFF49DED2)
                         ),
                       ),
                       hintText: 'Today I am feeling...',
                       hintStyle: TextStyle(
                         color: Colors.white,
                         fontFamily: 'Inter',
                         fontWeight: FontWeight.w400,
                         shadows: [
                           Shadow(
                             blurRadius: 13.0,
                             color: Colors.black.withOpacity(0.8),
                             offset: Offset(0.0, 3.0),
                           ),
                         ],

                       ),
                       filled: true,
                       fillColor:  Color(0xFF49DED2).withOpacity(0.5),
                     ),
                   ),
                 ),
               ),
             ),
           ),
           ElevatedButton(
               style:ElevatedButton.styleFrom(
                   backgroundColor: Color(0xFF13678A),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),

                   )),


               onPressed: () async {
                 try {
                   await firestoreInstance.collection("moodEntries").add({
                     "mood": "$mood",
                     "moodEntry": _entryController.text,
                     "user": widget.user?.uid,
                     "date": DateTime.now(),
                   });

                   // Show snackbar for successful entry
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('Entry added successfully!'),
                       duration: Duration(seconds: 2),
                     ),
                   );
                 } catch (e) {
                   // Handle error
                   print('Error adding entry: $e');

                   // Show snackbar for error
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text('Error adding entry. Please try again.'),
                       duration: Duration(seconds: 2),
                     ),
                   );
                 }
               }, child: Text("Add to Diary", style: GoogleFonts.inter(color: Colors.white,fontSize: 20.0),))
           ,
           SizedBox(height: 20,),
           ElevatedButton(
               style:ElevatedButton.styleFrom(
                   backgroundColor: Color(0xFF13678A),

                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(125.0),

                   )),


               onPressed: (){
                 Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) =>  ViewMoodEntry(user:widget.user)),
                 );
               }, child: Text("View All Entries", style: GoogleFonts.inter(color: Colors.white),))
         ],

       ),
      ),

    );
  }
}

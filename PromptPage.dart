import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class PromptPage extends StatelessWidget {
  final String?payload;
  final User? user;
  const PromptPage({Key? key, this.payload, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;

    final String formattedDate = 'Today ${DateFormat('dd MMM').format(DateTime.now())}';
    final _entryController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF49DED2),
        title: Text(formattedDate),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  payload??'',
                  style:GoogleFonts.inter(fontSize: 18.0)
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                        hintText: 'I am grateful for "what"...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontStyle: FontStyle.italic,
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
                    await firestoreInstance.collection("promptEntries").add({
                      "prompt":payload,
                      "moodEntry": _entryController.text,
                      "user": user?.uid,
                      "date": DateTime.now(),
                    });

                    // Show snackbar for successful entry
                    _entryController.clear();
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
          ],
        ),
      ),
    );

  }
}

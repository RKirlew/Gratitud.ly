import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../Welcome.dart';
List<String> imageUrls = [  'https://images.unsplash.com/photo-1438786657495-640937046d18?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://images.unsplash.com/photo-1678723097718-8c7f5ece3a3c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8NnNNVmpUTFNrZVF8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=60',
  'https://images.unsplash.com/photo-1678719510034-a2d3efb68e85?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=718&q=80',
  'https://images.unsplash.com/photo-1678614034519-6d142721173f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
  'https://images.unsplash.com/photo-1678125690568-d3f224222aab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',];
int randomIndex = Random().nextInt(imageUrls.length);
String selectedImageUrl = imageUrls[randomIndex];
class GratitudeEntry extends StatelessWidget {
  final Text?gratitudeEntry;
  const GratitudeEntry({Key? key,required this.gratitudeEntry}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gratitude Entry', style: GoogleFonts.inter(),),
        backgroundColor: Color(0xFF49DED2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
                  Navigator.pop(context);

          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Stack(
                children: [

                  Container(

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: NetworkImage(selectedImageUrl),
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
                  height: 400.0,
                  width: 300.0,

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Text(
                            'Gratitude Entry',
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
                            child: gratitudeEntry
                        )
                      ],
                    ),
                  ),
                ),



              ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}

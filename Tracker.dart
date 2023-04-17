import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';
import '../Welcome.dart';
import 'MoodTipsPage.dart';
class Tracker extends StatefulWidget {
  final User?user;

  const Tracker({Key? key, this.user}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  Map<String, double> moodValues = {
    'Happy': 10.0,
    'Excited': 8.5,
    'Content': 7.0,
    'Neutral': 5.0,
    'Stressed': 3.0,
    'Anxious':2.0,
    'Angry':2.5,
    'Grateful':7.5,
    'Joyful':9.5,
    'Loved':8.0,
    'Calm':7.0,
    'Sad': 1.0,
  };
  late List<double> gratX=[];
  late List<double> moodY=[];
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

// Function to display the mood score information dialog box
  Future<void> _showMoodScoreDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mood Score Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your mood score is a value between 1 and 10 that represents your overall mood for the day.'),
                SizedBox(height: 8),
                Text('1 represents the lowest mood, a sad mood, while 10 represents the highest mood, a very happy mood.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<DocumentSnapshot?> fetchEntryForDay(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;
    final entriesRef = FirebaseFirestore.instance
        .collection('gratitudeEntries')
        .where('user', isEqualTo: widget.user?.uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(day))
        .where('date', isLessThan: Timestamp.fromDate(day.add(Duration(days: 1))))
        .limit(1);

    final querySnapshot = await entriesRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  Future<Set<DateTime>> fetchGratitudeEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    final entriesRef = FirebaseFirestore.instance
        .collection('gratitudeEntries')
        .where('user', isEqualTo: widget.user?.uid);

    final querySnapshot = await entriesRef.get();
    final entryDates = querySnapshot.docs.map((doc) {
      final entryDate = (doc.data() as Map<String, dynamic>)['date'] as Timestamp;
      final date = entryDate.toDate().toUtc();
      return DateTime(date.year, date.month, date.day);
    }).toSet();

    return entryDates;
  }
  Future<double> fetchGratScore() async {
    double gratScore = 0;
    int numGratEntries = 0;
    final gratEntries = await FirebaseFirestore.instance
        .collection('gratitudeEntries')
        .where('user', isEqualTo: '${widget.user?.uid}')
        .get();
    gratEntries.docs.forEach((doc) {
      numGratEntries++;
      gratScore+=doc.data()['score'];
      gratX.add(doc.data()['score']);
    });
    if (numGratEntries > 0) {  // Check if there are any mood entries
      final avgGratScore = gratScore / numGratEntries;
      return avgGratScore;
    } else {
      return 0;  // Return 0 if there are no mood entries
    }
    return gratScore;
  }
  Future<double> fetchMoodScore() async {
    final moodEntries = await FirebaseFirestore.instance
        .collection('moodEntries')
        .where('user', isEqualTo: '${widget.user?.uid}')
        .get();
    double totalMoodScore = 0;
    int numMoodEntries = 0;

    moodEntries.docs.forEach((doc) {
      final mood = doc.data()['mood'];
      debugPrint(doc.data()['mood']);
      // Match mood to numerical value in map
      final moodValue = moodValues[mood];

     // debugPrint(moodValues['Excited'].toString());
      if (moodValue != null) {  // Check if moodValue is not null or NaN
        // Add mood value to total mood score
        moodY.add(moodValue);
        totalMoodScore += moodValue;

        // Increment count of mood entries
        numMoodEntries++;
      }
    });

    if (numMoodEntries > 0) {  // Check if there are any mood entries
      final avgMoodScore = totalMoodScore / numMoodEntries;
      return avgMoodScore;
    } else {
      return 0;  // Return 0 if there are no mood entries
    }
  }
  bool isSameDate(DateTime date1, DateTime date2) {


    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _entryDates = {};

  @override
  void initState() {
    super.initState();
    fetchMoodScore();
    fetchGratitudeEntries().then((dates) {
      setState(() {
        _entryDates = dates;

      });


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Gratitude Tracker'),
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
      body:  FutureBuilder<Set<DateTime>>(
        future: fetchGratitudeEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final entryDates = snapshot.data!;
          DateTime now = DateTime.now();
          DateTime firstDay = DateTime(now.year, now.month - 1, 1);
          DateTime lastDay = DateTime(now.year, now.month + 1, 0);
          DateTime focusedDay = now;

          return Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now().subtract(Duration(days: 365)),
                      lastDay: DateTime.now().add(Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) async {
                        debugPrint(selectedDay.toString());
                        if (_entryDates.any((entryDate) => isSameDate(entryDate, selectedDay))) {
    final entryDoc = await fetchEntryForDay(selectedDay);
    if (entryDoc != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          final entryData = entryDoc.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gratitude Entry',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 16),
                      Text(entryData['entry'] ?? '',style: GoogleFonts.inter(fontSize: 16),),

                    ],

            ),
          );
        },
      );
    }
        }

                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },

                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          final normalizedDay = DateTime(day.year, day.month, day.day).toUtc();
                          if (_entryDates.any((entryDate) => isSameDate(entryDate, normalizedDay))){
                            return Icon(
                              Icons.check,
                              color: Colors.green,
                            );
                          }else{
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    FutureBuilder<double>(
                        future: fetchMoodScore(),
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }else{
                            final double moodScore = snapshot.data!;
                            final int filledPercentage = moodScore.round() * 10;

                            return Stack(

                              children: [
                              Center(
                                child: SizedBox(
                                width: 250,
                                height: 250,
                                child: GestureDetector(
                                  onTap: () {
                                    // Show the mood score information dialog box when the user taps on the mood indicator
                                    _showMoodScoreDialog(context);
                                  },
                                  child: CircularProgressIndicator(
                                    value: filledPercentage / 100,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _getColorForPercentage(filledPercentage)),
                                  ),
                                ),
                            ),
                              ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 20,),
                                      Text(
                                        moodScore.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text("Mood Score", style: GoogleFonts.inter(fontSize: 20.0),),
                                     if(moodScore>8)
                                       Center(child: Text("You had a great week", style: GoogleFonts.inter(fontSize: 16.0,fontWeight: FontWeight.w400),)),

                                      if(moodScore<4)
                                        ElevatedButton(
                                          style:ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF13678A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),

                                              )),

                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const MoodTipsPage( tips: [

                                                {
                                                  'tip': 'Take a relaxing bath',
                                                  'image': 'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                                },
                                              ],)),
                                            );
                                          },
                                          child:  Text('Improve Your Mood', style: GoogleFonts.inter(),),
                                        ),
                                    ],
                                  ),
                                ),
                          ]);
                          }

                        }
                    ),
                    SizedBox(height: 20.0,),
                    FutureBuilder<double>(
                        future: fetchGratScore(),
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }else{
                            final double gratScore = snapshot.data!;
                            final int filledPercentage = gratScore.round() * 10;

                            return Stack(

                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 250,
                                      height: 250,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Show the mood score information dialog box when the user taps on the mood indicator
                                          _showMoodScoreDialog(context);
                                        },
                                        child: CircularProgressIndicator(
                                          value: filledPercentage / 100,
                                          strokeWidth: 10,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              _getGratColorForPercentage(filledPercentage)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          gratScore.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text("Gratitude Score", style: GoogleFonts.inter(fontSize: 20.0),),
                                        if(gratScore>8)
                                          Center(child: Text("You had a great week", style: GoogleFonts.inter(fontSize: 16.0,fontWeight: FontWeight.w400),)),

                                        if(gratScore<4)
                                          ElevatedButton(
                                            style:ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF13678A),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25.0),

                                                )),

                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const MoodTipsPage( tips: [

                                                  {
                                                    'tip': 'Take a relaxing bath',
                                                    'image': 'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                                  },
                                                ],)),
                                              );
                                            },
                                            child:  Text('Improve Your Mood', style: GoogleFonts.inter(),),
                                          ),
                                      ],
                                    ),
                                  ),
                                ]);
                          }

                        }
                    )

                  ],
                ),
              );
            }
          );
        },
      ),
    );
  }
}
Color _getColorForPercentage(int filledPercentage) {
  if (filledPercentage <= 30) {
    return Colors.red;
  } else if (filledPercentage <= 70) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}

Color _getGratColorForPercentage(int filledPercentage) {
  if (filledPercentage <= 30) {
    return Colors.red;
  } else if (filledPercentage <= 70) {
    return Colors.purple;
  } else {
    return Colors.lightBlue;
  }
}

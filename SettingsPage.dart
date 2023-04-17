import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../Welcome.dart';
import 'dart:math';

import 'PromptPage.dart';
class SettingsPage extends StatefulWidget {
  final User? user;

  const SettingsPage({Key? key,  this.user}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  final List<String> gratitudePrompts = [
    'What is something you are grateful for today?',
    'Name one person who made a positive impact on your life recently.',
    'What is a happy memory you can recall and be thankful for?',
    'Think of a challenge you overcame and be grateful for the growth it brought.',
    'What is one simple pleasure that brings you joy?',
    'Name a skill or talent you have that you are grateful for.',
    'What is an accomplishment you achieved that you are proud of?',
    'Think of something in nature that you appreciate.',
    'What is a positive quality of someone close to you that you are grateful for?',
    'Name one thing that made you smile or laugh today.',
    'What is a personal possession you own that makes your life easier?',
    'Think of a recent experience that made you feel grateful.',
    'What is a lesson you learned recently that you are thankful for?',
    'What is an act of kindness someone has done for you that you are grateful for?',
    'Name one thing about your health or well-being that you appreciate.',
    'What is a book, movie, or song that has positively impacted your life?',
    'Think of a place you have visited that you are grateful for experiencing.',
    'What is a positive change in your life that you are grateful for?',
    'Name someone who has helped you grow \n and be thankful for their guidance.',
    'What is one thing you can do today to express gratitude to someone?'
  ];
  @override
  void initState() {
    tz.initializeTimeZones();
    _emailController.text = widget.user?.email ?? '';
    _displayNameController.text = widget.user?.displayName ?? '';
    super.initState();

    _loadSettings();
  }
  Future<void> _showEditModal(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),

          title: Text('Edit Profile',style: GoogleFonts.inter(),),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',

              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF49DED2)
              ),
              onPressed: () async {
                final user = widget.user;
                if (user == null) {
                  return;
                }

                try {
                  await user.updateEmail(_emailController.text);
                  await user.updateDisplayName(_displayNameController.text);
                  await widget.user?.reload();
                  User? updatedUser = FirebaseAuth.instance.currentUser;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile updated successfully.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GratitudePage(updatedUser)));
                } on FirebaseAuthException catch (e) {
                  String message;
                  switch (e.code) {
                    case 'invalid-email':
                      message = 'The email address is invalid.';
                      break;
                    case 'email-already-in-use':
                      message = 'The email address is already in use.';
                      break;
                    case 'requires-recent-login':
                      message = 'Please sign in again to update your profile.';
                      break;
                    default:
                      message = 'An error occurred while updating your profile.';
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('An error occurred while updating your profile.'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },

              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  String getRandomGratitudePrompt() {
    final random = Random();
    final index = random.nextInt(gratitudePrompts.length);
    return gratitudePrompts[index];
  }
  Future<void> _loadSettings() async {

    final prefs = await SharedPreferences.getInstance();
    final notifsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    final selectedHour = prefs.getInt('selectedHour') ?? 9;
    final selectedMinute = prefs.getInt('selectedMinute') ?? 0;
    setState(() {
      _notificationsEnabled = notifsEnabled;
      _selectedTime = TimeOfDay(hour: selectedHour, minute: selectedMinute);
    });
  }
  Future<void> _saveSettings() async {

    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setInt('selectedHour', _selectedTime.hour);
    prefs.setInt('selectedMinute', _selectedTime.minute);

    if (_notificationsEnabled) {
      final now = DateTime.now();
      final scheduledDate = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
      final scheduledNotificationDateTime = scheduledDate.isBefore(now) ? scheduledDate.add(Duration(days: 1)) : scheduledDate;
      await _scheduleDailyNotification(scheduledNotificationDateTime);
    } else {
      await _cancelDailyNotification();
    }
  }
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
  Future<void> _onSelectNotification(String? payload) async {
    // Navigate to the desired page here
    debugPrint(payload);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PromptPage(payload: payload,user: widget.user,)),
    );
  }
  Future<void> _scheduleDailyNotification(DateTime scheduledNotificationDateTime) async {
    String randomGratitudePrompt = getRandomGratitudePrompt();
    final platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_notification_channel_id',
        'Daily Notifications',
        'Receive daily notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
          styleInformation: BigTextStyleInformation(''),

      ),
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(
    );
    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Gratitude Prompt',
      randomGratitudePrompt,

      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
        payload: randomGratitudePrompt
    );
  }

  Future<void> _cancelDailyNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(0);
  }
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Settings Page', style: GoogleFonts.inter(),),
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
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Container(

                child:Column(
                  children: [
                    Card(
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:Color(0xFFA4C0A0),
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                      ),
                      elevation:10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1,color:Colors.transparent),
                          Center(
                            child:Text("Profile", style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.bold),)
                          ),
                          Divider(thickness: 1,color:Colors.transparent),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${widget.user?.email}', style: GoogleFonts.inter(color: Colors.grey),),
                          ),

                            Padding(
                              padding: const EdgeInsets.only(left:8.0,bottom: 14.0),
                              child: Row(
                                children: [
                                  Text('${widget.user?.displayName}', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20.0),),

                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: GestureDetector(
                                        onTap: (){
                                          _showEditModal(context);
                                        },
                                        child: Icon(Icons.edit)),
                                  )
                                ],
                              ),
                            ),


                        ],
                      ),
                    ),

                    Card(
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:Color(0xFFA4C0A0),
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                      ),
                      elevation:10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1,color:Colors.transparent),
                          Center(
                              child:Text("Push Notifications", style: GoogleFonts.inter(fontSize: 18.0, fontWeight: FontWeight.bold),)
                          ),
                          Divider(thickness: 1,color:Colors.transparent),


                          SwitchListTile(
                            activeColor: Color(0xFF49DED2),
                            title: Text('Enable daily notifications', style: GoogleFonts.inter()),
                            value: _notificationsEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                              _saveSettings();
                            },
                          ),
                          Builder(
                            builder: (context) {
                              return ListTile(
                                title: Text('Notification time', style: GoogleFonts.inter(),),
                                subtitle: Text('Every day at ${_selectedTime.format(context)}' , style: GoogleFonts.inter()),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTime,
                                  );
                                  if (picked != null && picked != _selectedTime) {
                                    setState(() {
                                      _selectedTime = picked;
                                    });
                                    showSnackBar(context, 'Notification time updated!');
                                    _saveSettings();
                                  }
                                },
                              );
                            }
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

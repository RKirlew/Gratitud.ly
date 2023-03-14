import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gratus/SignUpPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gratitud.ly Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(290.0), // Set the desired height
        child: Stack(
          children:[

            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Color(0xFFDAFDBA),
            ),
            width: double.infinity,
            height: kToolbarHeight + MediaQuery.of(context).padding.top+800.0,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),

          ),
            Padding(
              padding: EdgeInsets.only(top: 110),
              child: Center(
                child: Image.asset(
                  'assets/images/meditate.png',
                  width: 250.0,
                  height: 330.0, // Set the desired height
                  fit: BoxFit.cover,
                ),
              ),
            ),

          ]
        ),
      ),
      body:Container(
        child: Column(
          children: [
                      Center(
                          child: Text("Gratitud.ly",style: GoogleFonts.coiny( textStyle: TextStyle(color:  Color(0xFF45C4B0),fontSize: 40.0),))
                      ),
            SizedBox(height: 30.0,),
            Center(
                child: Text("Transform your perspective,",style: GoogleFonts.lexendExa( textStyle: TextStyle(color:Colors.black,fontSize: 20.0),))
            ),
            Center(
                child: Text("cultivate gratitude every day!",style: GoogleFonts.lexendExa( textStyle: TextStyle(color:Colors.black,fontSize: 20.0),))
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Gratitude brings ",style: GoogleFonts.coiny( textStyle: TextStyle(color: Color(0xFF13678A),fontSize: 16.0),)),
          AnimatedTextKit(
          pause: Duration(seconds: 2),
            animatedTexts: [
              TyperAnimatedText('peace',textStyle: GoogleFonts.coiny(color:  Color(0xFF13678A))),
              TyperAnimatedText('prosperity',textStyle: GoogleFonts.coiny(color:  Color(0xFF13678A))),
              TyperAnimatedText('increased happiness' ,textStyle: GoogleFonts.coiny(color:  Color(0xFF13678A))),
              TyperAnimatedText('improved mental health' ,textStyle: GoogleFonts.coiny(color:  Color(0xFF13678A))),
              TyperAnimatedText('greater sense of fulfillment', textStyle: GoogleFonts.coiny(color: Color(0xFF13678A))),
              TyperAnimatedText('increased focus', textStyle: GoogleFonts.coiny(color: Color(0xFF13678A))),
              TyperAnimatedText('improved communication skills', textStyle: GoogleFonts.coiny(color: Color(0xFF13678A))),
              TyperAnimatedText('increased creativity', textStyle: GoogleFonts.coiny(color: Color(0xFF13678A)))
            ], repeatForever: true,),

        ],
      ),
            Padding(
              padding: const EdgeInsets.only(top:78.0),
              child: Center(
                child: InkWell(
                  splashColor: Color(0xFF13678A),
                  highlightColor: Color(0xFF13678A),

                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:  (context) => const SignUpPage()));
                  },
                  child: Container(
                    width: 193.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(50.0),
                      color: Color(0xFF13678A),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.lexendExa(textStyle: TextStyle(color:Colors.white,fontSize: 16.0)),
                          ),
                        ),
                        Icon(Icons.arrow_forward,color: Colors.white,)
                      ],
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(38.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Already Have An Account?",
                      style: GoogleFonts.lexendExa(textStyle: TextStyle(color:Colors.black,fontSize: 14.0)),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left:3.0),
                      child: TextButton(
                        onPressed: () {
                          debugPrint("4rfinwe");
                        },
                        child:Text("Login",
                        style: GoogleFonts.lexendExa(textStyle: TextStyle(color:Color(0xFF45C4B0),fontSize: 14.0)),)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    )
    );
  }
}


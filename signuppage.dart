import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gratitud.ly  Onboarding",
      home: Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:120.0),
                child: Center(
                    child: Text("Gratitud.ly",style: GoogleFonts.coiny( textStyle: TextStyle(color:  Color(0xFF45C4B0),fontSize: 40.0),))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Thankful Starts Here",style: GoogleFonts.lexendExa( textStyle: TextStyle(color:  Color(0xFF45C4B0),fontSize: 18.0),))),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Create An Account",style: GoogleFonts.lexendExa( textStyle: TextStyle(color:  Color(0xFF45C4B0),fontSize: 18.0, fontWeight: FontWeight.bold),))),
              ),*/

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),


              TextFormField(

                controller: _passwordController,
                obscureText: _isObscured,
                decoration: InputDecoration(
                  hintText: ' Password. min. 6 characters',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _toggleObscure,
                    icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility,color: Color(0xFF45C4B0),),
                  ),
                ),

              ),
              SizedBox(height: 20.0,),
              SizedBox(
                width: 300.0,
                height: 38.0,
                child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),

                  backgroundColor: Color(0xFF13678A)
                ),
                  onPressed: () {
                    // Your code here
                  },
                  child: Text('Continue'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color:  Color(0xFF45C4B0),
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: GoogleFonts.lexendExa( textStyle: TextStyle(color:  Color(0xFF45C4B0),fontSize: 14.0,fontWeight: FontWeight.bold),),)
                  ),
                  Expanded(
                    child: Divider(
                      color:  Color(0xFF45C4B0),
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              Row(
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
              SizedBox(height: 20.0,),

              SizedBox(
                width: 320.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your button logic here
                  },
                  icon: Image.asset(
                    'assets/google.png', // Replace with your Google icon asset path
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: Text(
                    'Sign Up with Google',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              SizedBox(
                width: 320.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your button logic here
                  },
                  icon: Image.asset(
                    'assets/apple.png', // Replace with your Google icon asset path
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: Text(
                    'Sign Up with Apple',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
              TextButton(onPressed: (){

                  Navigator.pop(context);

              }, child: Text("Go back"))
            ],
          ),
        ),
      ),
    );
  }
}

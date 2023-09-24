import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leanify/home.dart';
import 'package:leanify/login.dart';
import 'package:pinput/pinput.dart';
class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var code = "";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const Text(" Login Page",style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.cover),),
              ),
              const  SizedBox(height: 50,),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: LoginScreen.verfy, smsCode: code);
                        await auth.signInWithCredential(credential);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } catch (e) {
                        print("wrong otp");
                      }
                    },
                    child: const Text("Verify OTP",style: TextStyle(color: Colors.white),)),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: ()
          {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }, child: const Text(
                        "Change your phone number?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),

              const SizedBox(height: 20,),
             const Text("By Signin up you agree with our Term and Conditions",style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}

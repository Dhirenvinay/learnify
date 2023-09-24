import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leanify/otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String verfy = "";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryController = TextEditingController();
  var phone = "";
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
          setState(() {
            _connectivityResult = result;
            updateButtonState();
          });
        });
    countryController.text = "+91";
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  void updateButtonState() {
    final hasInternet = _connectivityResult != ConnectivityResult.none;
    final isPhoneNumberValid = phone.length == 10;
    setState(() {
      isButtonEnabled = hasInternet && isPhoneNumberValid;
    });
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
          content: Text('No internet connection. Please check your network.'),
        ),
      );
    }
  }
  bool isButtonEnabled = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
            const SizedBox(height: 50,),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const  SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          phone = value;
                          final hasInternet = _connectivityResult != ConnectivityResult.none;
                          final isPhoneNumberValid = phone.length == 10;

                          setState(() {
                            isButtonEnabled = hasInternet && isPhoneNumberValid;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),)
                  ],
                ),
              ),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () async {
                    if (_connectivityResult != ConnectivityResult.none) {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber:  '${countryController.text + phone}',

                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          LoginScreen.verfy = verificationId;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MyVerify(),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No internet connection. Please check your network.'),
                        ),
                      );
                    }
                  }
                      : null,
                  child: const Text("Get OTP",style: TextStyle(color: Colors.white),),
                ),
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

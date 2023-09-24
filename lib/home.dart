import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Home"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/logo.png"),fit: BoxFit.cover),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

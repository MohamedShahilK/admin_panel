// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      // width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(isPressed ? 0.4 : 0.3),
        color: Colors.white,
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomCenter,
        //   // colors: [Colors.white.withOpacity(.7), Colors.blue[300]!],
        //   // colors: [Colors.white.withOpacity(.7), Colors.deepPurpleAccent[100]!],
        //   colors: [Colors.white.withOpacity(.8), const Color.fromARGB(255, 255, 255, 255)!],
        // ),
        borderRadius: BorderRadius.circular(25),        
        // border: Border.all(width: 2, color: Colors.blue.withOpacity(.5)),
        border: Border.all(width: 2, color: Colors.deepPurpleAccent.withOpacity(.2)),
        //Optional

        // image: const DecorationImage(
        //   //Noise Background Image
        //   image: NetworkImage(
        //     'https://images.unsplash.com/photo-1580243117731-a108c2953e2c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
        //   ),
        //   fit: BoxFit.cover,
        //   // opacity: .2
        //   opacity: 0.05,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.3),
        //     blurRadius: 25,
        //     spreadRadius: -5,
        //   ),
        // ],
      ),
      child: child,
    );
  }
}

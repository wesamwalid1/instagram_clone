import 'package:flutter/material.dart';

class stories extends StatelessWidget {
  const stories({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:15),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 40,
        backgroundImage:  AssetImage('assets/images/add_icon.png',),
      ),
    );
  }
}

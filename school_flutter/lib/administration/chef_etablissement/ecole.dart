import 'package:flutter/material.dart';


/// ----------------------
/// 4. École
/// ----------------------
class EcolePage extends StatelessWidget {
  const EcolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Gestion de l'École",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
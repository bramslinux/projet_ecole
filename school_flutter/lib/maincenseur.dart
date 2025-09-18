import 'package:flutter/material.dart';
import 'administration/censeur/censeur_login_screen.dart';



void main() {
  runApp(const SchoolManagementApp ());
}

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plateforme de Gestion Scolaire',
      debugShowCheckedModeBanner: false,
      
    
      home: CenseurLoginScreen(),
    

    );
  }

}
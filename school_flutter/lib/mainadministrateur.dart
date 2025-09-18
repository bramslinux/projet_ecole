import 'package:flutter/material.dart';
import 'administration/Administrateur/admin_bashboard.dart';



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
      
      home: AdministrateurDashboard(),
      
    

    );
  }

}
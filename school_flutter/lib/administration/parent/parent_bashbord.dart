import 'package:flutter/material.dart';
import 'package:school_flutter/administration/parent/dasboard_basique_parent.dart';
import 'package:school_flutter/administration/parent/infoEleve.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SchoolMap",
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const ParentDashboard(),
    );
  }
}
/*
/// --------------------
/// PAGE DE CONNEXION - PARENT
/// --------------------
class parentEspaceLogin extends StatefulWidget {
  const parentEspaceLogin({super.key});

  @override
  State<parentEspaceLogin> createState() => _parentEspaceLoginState();
}

class _parentEspaceLoginState extends State<parentEspaceLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_emailController.text == "parent" &&
        _passwordController.text == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Identifiants incorrects"),
          backgroundColor: Colors.red[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Fonction pour gérer le retour
  void _goBack() {
    // Vous pouvez personnaliser cette fonction selon vos besoins
    Navigator.of(context).pop();
    // Ou naviguer vers une page d'accueil spécifique :
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ajout de l'AppBar avec bouton de retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2D3748),
              size: 20,
            ),
          ),
          onPressed: _goBack,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8E8F5), // Couleur lilas très claire
              Color(0xFFF5F5F5), // Blanc cassé
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      const Text(
                        "Connexion - Parent d'élève",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Champ Identifiant
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Identifiant (parent)",
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 107, 184, 255),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Champ Mot de passe
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Mot de passe (1234)",
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 107, 225, 255),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Bouton de connexion
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 107, 188, 255),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                    
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

/// --------------------
/// DASHBOARD - PARENT
/// --------------------
// parent_dashboard.dart
class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});
  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 0;
  String? _matricule;
  final List<String> _titles = [
    "Accueil",
    "Informations de l'élève",
    "Notes",
    "Emploi du temps",
    "Notifications",
    "Nombre d'élèves souscrits",
  ];
  final List<IconData> _icons = [
    Icons.home,
    Icons.info,
    Icons.grade,
    Icons.schedule,
    Icons.notifications,
    Icons.people,
  ];

  bool _requiresMatricule(int index) {
    // Assume indices 1 to 4 require matricule (Informations, Notes, Emploi, Notifications)
    // Adjust as needed for your logic
    return index >= 1 && index <= 4;
  }

  Future<String?> _showMatriculeDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Entrer le matricule de l\'élève'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Matricule"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                final String matricule = controller.text.trim();
                if (matricule.isNotEmpty) {
                  Navigator.of(context).pop(matricule);
                } else {
                  // Optionally show error, but for simplicity, pop null
                  Navigator.of(context).pop(null);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:
        return InfoElevePage(matricule: _matricule!);
      /* case 2:
        return NotesPage(matricule: _matricule!);
      case 3:
        return EmploiDuTempsPage(matricule: _matricule!);
      case 4:
        return NotificationsPage(matricule: _matricule!);
      case 5:
        return const NombreElevesSouscritsPage();*/
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 176, 255),
        foregroundColor: Colors.white,
        title: Text(
          "Parent - ${_titles[_selectedIndex]}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 107, 201, 255),
                    Color.fromARGB(255, 92, 202, 246),
                  ],
                ),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.school,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Espace Parent",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Suivi de l'élève",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (int i = 0; i < _titles.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: ListTile(
                        leading: Icon(
                          _icons[i],
                          color:
                              i == _selectedIndex
                                  ? const Color.fromARGB(255, 107, 188, 255)
                                  : Colors.grey[600],
                        ),
                        title: Text(
                          _titles[i],
                          style: TextStyle(
                            color:
                                i == _selectedIndex
                                    ? const Color.fromARGB(255, 107, 220, 255)
                                    : Colors.grey[800],
                            fontWeight:
                                i == _selectedIndex
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                        selected: i == _selectedIndex,
                        selectedTileColor: const Color.fromARGB(
                          255,
                          107,
                          233,
                          255,
                        ).withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () async {
                          if (_requiresMatricule(i) && _matricule == null) {
                            final String? enteredMatricule =
                                await _showMatriculeDialog(context);
                            if (enteredMatricule == null) {
                              Navigator.pop(context);
                              return;
                            }
                            setState(() {
                              _matricule = enteredMatricule;
                            });
                          }
                          setState(() {
                            _selectedIndex = i;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  const Divider(indent: 16, endIndent: 16, thickness: 1),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.grey[600]),
                      title: Text(
                        "Déconnexion",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParentLoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _buildPage(),
    );
  }
}

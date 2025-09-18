import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/importation.dart';
import 'package:school_flutter/administration/chef_etablissement/notification.dart';
import 'package:school_flutter/administration/chef_etablissement/utilisateur.dart';
import 'package:school_flutter/administration/chef_etablissement/pages/batiment_page.dart';
import 'package:school_flutter/administration/chef_etablissement/pages/salle_page.dart';
import 'package:school_flutter/administration/chef_etablissement/pages/classe_page.dart';
import 'package:school_flutter/administration/chef_etablissement/pages/matiere_page.dart';
import 'package:school_flutter/administration/chef_etablissement/pages/periode_page.dart';
import 'gestion_note.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SchoolMap",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChefLogin(),
    );
  }
}

/// --------------------
/// PAGE DE CONNEXION
/// --------------------
class ChefLogin extends StatefulWidget {
  const ChefLogin({super.key});

  @override
  State<ChefLogin> createState() => _ChefLoginState();
}

class _ChefLoginState extends State<ChefLogin> {
  final _ineController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Identifiants fixes provisoires
    if (_ineController.text == "abdoul@gmail.com" &&
        _passwordController.text == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChefEtablissementDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Identifiants incorrects")),
      );
    }
  }

  // Fonction pour gérer le retour
  void _goBack() {
    Navigator.of(context).pop();
    // Alternative : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Connexion - Chef d'établissement",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Champ Identifiant
                      TextField(
                        controller: _ineController,
                        decoration: InputDecoration(
                          hintText: "Email (abdoul@gmail.com)",
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
                              color: Color.fromARGB(255, 107, 208, 255),
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
                              color: Color.fromARGB(255, 107, 213, 255),
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
                            backgroundColor: const Color.fromARGB(255, 107, 176, 255),
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
}

/// --------------------
/// DASHBOARD - CHEF D'ÉTABLISSEMENT
/// --------------------
class ChefEtablissementDashboard extends StatefulWidget {
  const ChefEtablissementDashboard({super.key});

  @override
  State<ChefEtablissementDashboard> createState() =>
      _ChefEtablissementDashboardState();
}

// Énumération pour les différentes pages
enum PageType {
  accueil,
  utilisateur,
  batiments,
  salles,
  periodes,
  classes,
  matieres,
  gestionNotes,
  notification,
  importation
}

class _ChefEtablissementDashboardState extends State<ChefEtablissementDashboard> {
  PageType _currentPage = PageType.accueil;

  String _getTitle(PageType page) {
    switch (page) {
      case PageType.accueil:
        return "Accueil";
      case PageType.utilisateur:
        return "Utilisateur";
      case PageType.batiments:
        return "Bâtiments";
      case PageType.salles:
        return "Salles";
      case PageType.periodes:
        return "Périodes";
      case PageType.classes:
        return "Classes";
      case PageType.matieres:
        return "Matières";
      case PageType.gestionNotes:
        return "Gestion des Notes";
      case PageType.notification:
        return "Notification";
      case PageType.importation:
        return "Importation";
    }
  }

  // Méthode pour naviguer vers la page correspondante
  void _navigateToPage(PageType page) {
    if (page == PageType.accueil) {
      setState(() {
        _currentPage = page;
      });
      return;
    }

    Widget pageWidget = _buildPage(page);
    if (pageWidget is! Container) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTitle(page)} - En cours de développement'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Construction de la page en fonction du type
  Widget _buildPage(PageType page) {
    switch (page) {
      case PageType.utilisateur:
        return const UtilisateurPage();
      case PageType.batiments:
        return const BatimentPage();
      case PageType.salles:
        return const SallePage();
      case PageType.periodes:
        return const PeriodePage();
      case PageType.classes:
        return const ClassePage();
      case PageType.matieres:
        return const MatierePage();
         case PageType.gestionNotes:
        return const NotesPage();
      case PageType.notification:
        return const NotificationPage();
      case PageType.importation:
        return const ImportationPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 78, 125),
        title: Text("SchoolMap - ${_getTitle(_currentPage)}"),
        actions: [
         
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 46, 109, 125),
                    const Color.fromARGB(255, 67, 126, 160),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.school, size: 35, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "SchoolMap",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const Text(
                    "Chef d'établissement",
                    style: TextStyle(
                      color: Colors.white70, 
                      fontSize: 14
                    ),
                  ),
                ],
              ),
            ),
            // Menu Accueil
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Accueil"),
              selected: _currentPage == PageType.accueil,
              onTap: () => Navigator.pop(context),
            ),

            // Menu Utilisateur
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Utilisateur"),
              selected: _currentPage == PageType.utilisateur,
              onTap: () => _navigateToPage(PageType.utilisateur),
            ),
            // Menu École avec sous-menus
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.school),
                title: const Text("École"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.business, size: 20),
                    title: const Text("Bâtiments"),
                    contentPadding: const EdgeInsets.only(left: 50.0),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToPage(PageType.batiments);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.meeting_room, size: 20),
                    title: const Text("Salles"),
                    contentPadding: const EdgeInsets.only(left: 50.0),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToPage(PageType.salles);
                    },
                  ),
                ],
              ),
            ),

            // Menu Pédagogie avec sous-menus
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: const Icon(Icons.menu_book),
                title: const Text("Pédagogie"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule, size: 20),
                    title: const Text("Périodes"),
                    contentPadding: const EdgeInsets.only(left: 50.0),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToPage(PageType.periodes);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.class_, size: 20),
                    title: const Text("Classes"),
                    contentPadding: const EdgeInsets.only(left: 50.0),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToPage(PageType.classes);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subject, size: 20),
                    title: const Text("Matières"),
                    contentPadding: const EdgeInsets.only(left: 50.0),
                    onTap: () {
                      Navigator.pop(context);
                      _navigateToPage(PageType.matieres);
                    },
                  ),
                ],
              ),
            ),
            // Autres menus
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Gestion des Notes"),
              selected: _currentPage == PageType.gestionNotes,
              onTap: () => _navigateToPage(PageType.gestionNotes),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notification"),
              selected: _currentPage == PageType.notification,
              onTap: () => _navigateToPage(PageType.notification),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text("Importation"),
              selected: _currentPage == PageType.importation,
              onTap: () => _navigateToPage(PageType.importation),
            ),
              SizedBox(height: 20),
                           ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Déconnexion",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context); // ferme le drawer
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ChefLogin()),
                      );
                    },
                  ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Bienvenue dans ${_getTitle(_currentPage)}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
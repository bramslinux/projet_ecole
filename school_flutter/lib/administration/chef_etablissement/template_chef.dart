import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/chef_subscription_screen.dart';
import 'package:school_flutter/administration/chef_etablissement/chef_etablissement_bashboard.dart';
import 'package:school_flutter/administration/censeur/censeur_workspace_screen.dart';
import 'package:school_flutter/administration/caissier/financier_workspace_screen.dart';
import 'package:school_flutter/administration/enseignant/teacher_workspace_screen.dart';
import 'package:school_flutter/administration/acceuil/pulic_home_screens.dart';

class ChefEtablissementbashboardTemplate extends StatefulWidget {
  const ChefEtablissementbashboardTemplate({super.key});

  @override
  State<ChefEtablissementbashboardTemplate> createState() => _ChefEtablissementbashboardTemplateState();
}

class _ChefEtablissementbashboardTemplateState extends State<ChefEtablissementbashboardTemplate> {

  void _deconnexion(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TemplateChefLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Chef Établissement'),
        backgroundColor:  Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
        ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Chef d\'établissement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.subscriptions),
              title: const Text('Souscription'),
              onTap: () { 
                Navigator.pop(context);
                _showCodeEtablissementDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Espace de travail'),
              onTap: () {
                Navigator.pop(context);
                _navigateToChefEtablissementWorkspace();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () => _deconnexion(context),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: 80,
              color: Color(0xFF2D3748),
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenue Chef d\'établissement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Utilisez le menu pour naviguer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Correction du nom de la méthode et navigation vers l'espace de travail
  void _navigateToChefEtablissementWorkspace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChefLogin()),
    );
  }

  void _showCodeEtablissementDialog() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // Données fictives pour la démonstration (remplacez par votre API ou base de données)
    final Map<String, String> _mockEtablissements = {
      'CODE123': 'Lycée Moderne',
      'CODE456': 'Collège International',
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          width: isSmallScreen ? MediaQuery.of(context).size.width * 0.9 : 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isSmallScreen ? 60 : 70,
                    height: isSmallScreen ? 60 : 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 145, 150).withOpacity(0.8),
                          const Color.fromARGB(255, 0, 170, 212).withOpacity(0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 15, 150).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.business_rounded,
                      size: isSmallScreen ? 30 : 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  Text(
                    'Souscription Chef d\'Établissement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'Entrez le code d\'établissement fourni par l\'administrateur',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 28),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ex: CODE123',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 16 : 18,
                        ),
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Code obligatoire';
                        }
                        if (!_mockEtablissements.containsKey(value)) {
                          return 'Code d\'établissement non valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: isSmallScreen ? 45 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(
                                  'Annuler',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: Container(
                          height: isSmallScreen ? 45 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 0, 140, 150).withOpacity(0.9),
                                const Color.fromARGB(255, 0, 134, 212).withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 70, 150).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChefSubscriptionScreen(
                                        codeEtablissement: controller.text,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Continuer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------
/// PAGE DE CONNEXION (Design original conservé)
/// --------------------
class TemplateChefLogin extends StatefulWidget {
  const TemplateChefLogin({super.key});

  @override
  State<TemplateChefLogin> createState() => _TemplateChefLoginState();
}

class _TemplateChefLoginState extends State<TemplateChefLogin> {
  bool _obscurePassword = true;
  final _ineController = TextEditingController();
  final _passwordController = TextEditingController();
void _login() {
  String email = _ineController.text.trim();
  String password = _passwordController.text.trim();

  // Exemple de comptes fictifs
  Map<String, Map<String, dynamic>> utilisateurs = {
    "chef@gmail.com": {
      "password": "1234",
      "role": "chef",
    },
    "censeur@gmail.com": {
      "password": "1234",
      "role": "censeur",
    },
    "enseignant@gmail.com": {
      "password": "1234",
      "role": "enseignant",
    },
    "caissier@gmail.com": {
      "password": "1234",
      "role": "caissier",
    },
  };

  if (utilisateurs.containsKey(email) &&
      utilisateurs[email]!["password"] == password) {
    String role = utilisateurs[email]!["role"];

    Widget destination;

    switch (role) {
      case "chef":
        destination = const ChefEtablissementbashboardTemplate();
        break;
      case "censeur":
        destination = const CenseurWorkspaceScreen();
        break;
      case "enseignant":
        destination = const TeacherWorkspaceScreen();
        break;
      case "caissier":
        destination = const FinancierWorkspaceScreen();
        break;
      default:
        destination = const Scaffold(
          body: Center(child: Text("Rôle non reconnu")),
        );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Identifiants incorrects")),
    );
     _ineController.clear();
  _passwordController.clear();
  }
}

  // Fonction pour gérer le retour
 void _goBack() {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const PublicHomeScreen()),
    (Route<dynamic> route) => false, // supprime toutes les anciennes routes
  );
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
                        "Connexion - Administration",
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
                              color: Color.fromARGB(255, 107, 196, 255),
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
  obscureText: _obscurePassword,
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
        color: Color.fromARGB(255, 107, 201, 255),
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    // 👇 Ajout du bouton pour afficher/masquer
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey[700],
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
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
import 'package:flutter/material.dart';
import 'student_subscription_screen.dart';
import 'package:school_flutter/administration/eleve/consulter_demande_screen.dart';
import 'package:school_flutter/administration/eleve/demande.dart';
import 'package:school_flutter/screens/student/auth/student_login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? _accessToken;
  static String? _refreshToken;
  static Map<String, dynamic>? _userInfo;

  // Getters
  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static Map<String, dynamic>? get userInfo => _userInfo;

  // Sauvegarder les tokens après connexion
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    Map<String, dynamic>? userInfo,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userInfo = userInfo;

    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    if (userInfo != null) {
      await prefs.setString('user_info', jsonEncode(userInfo));
    }
  }

  // Charger les tokens au démarrage de l'app
  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');

    final userInfoString = prefs.getString('user_info');
    if (userInfoString != null) {
      _userInfo = jsonDecode(userInfoString);
    }
  }

  // Supprimer les tokens (déconnexion)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = null;
    _refreshToken = null;
    _userInfo = null;

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_info');
  }

  // Vérifier si l'utilisateur est connecté
  static bool get isLoggedIn => _accessToken != null;

  // Headers avec authentification
  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  // Headers pour multipart avec authentification
  static Map<String, String> get authHeadersMultipart => {
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };
}

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = Uri.parse("http://127.0.0.1:8000/api/utilisateurs/login/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["access"] != null) {
        await AuthService.saveTokens(
          accessToken: data["access"],
          refreshToken: data["refresh"],
          userInfo: data["user"], // Si votre API retourne les infos utilisateur
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentWorkspaceScreen(),
            ),
          );
        }
      } else {
        final errorMsg = data["detail"] ?? "Identifiants incorrects";
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Impossible de se connecter au serveur"),
            backgroundColor: Colors.red[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentSubscriptionScreen(),
      ),
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
            colors: [Color(0xFFE8E8F5), Color(0xFFF5F5F5)],
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
                      const Text(
                        "Connexion - Élève",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Identifiant (eleve)",
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer votre email";
                                }
                                if (!value.contains('@')) {
                                  return "Email invalide";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: "Mot de passe",
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer votre mot de passe";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    107,
                                    171,
                                    255,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:
                                    _isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          "Se connecter",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: _goToRegister,
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF2D3748),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.person_add_alt_1_rounded,
                                    size: 20,
                                    color: Color(0xFF2D3748),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Pas de compte ? Créez-en un",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

class StudentWorkspaceScreen extends StatefulWidget {
  const StudentWorkspaceScreen({super.key});

  @override
  State<StudentWorkspaceScreen> createState() => _StudentWorkspaceScreenState();
}

class _StudentWorkspaceScreenState extends State<StudentWorkspaceScreen> {
  String currentPage = "Accueil";

  // Méthode pour changer de page via le drawer
  void _navigateTo(String page) {
    setState(() {
      currentPage = page;
    });
    Navigator.pop(context); // Ferme le drawer
  }

  // Déconnexion
  void _logout() {
    Navigator.pop(context); // Ferme le drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
    );
  }

  // Contenu selon la page sélectionnée
  Widget _getPageContent() {
    switch (currentPage) {
      case "Accueil":
        return _buildHomeContent();
      case "Consulter Demandes":
        return _buildConsultContent();
      case "Notifications":
        return _buildNotificationContent();
      case "Localiser Établissement":
        return _buildLocationContent();
      default:
        return _buildHomeContent();
    }
  }

  // ---------------- Contenus des pages ----------------
  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.home,
            size: 80,
            color: Color.fromARGB(255, 107, 147, 255),
          ),
          const SizedBox(height: 20),
          const Text(
            "Bienvenue dans ton espace élève 🎓",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Utilise le menu pour naviguer dans tes services",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 80, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            "Consulter tes Demandes",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Liste des demandes à venir...", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNotificationContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            "Notifications",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Aucune nouvelle notification", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, size: 80, color: Colors.red),
          SizedBox(height: 20),
          Text(
            "Localiser l'Établissement",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Carte et informations à venir...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Scaffold ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Élève - $currentPage"),
        backgroundColor: const Color.fromARGB(255, 107, 117, 255),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 107, 208, 255),
                    Color.fromARGB(255, 80, 199, 220),
                  ],
                ),
              ),
              accountName: const Text(
                "Élève Connecté",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("eleve@education.bf"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.school,
                  color: Color.fromARGB(255, 107, 208, 255),
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Accueil
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color:
                          currentPage == "Accueil"
                              ? const Color.fromARGB(255, 107, 225, 255)
                              : Colors.grey[600],
                    ),
                    title: Text(
                      "Accueil",
                      style: TextStyle(
                        fontWeight:
                            currentPage == "Accueil"
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            currentPage == "Accueil"
                                ? const Color.fromARGB(255, 107, 208, 255)
                                : Colors.black87,
                      ),
                    ),
                    onTap: () => _navigateTo("Accueil"),
                  ),
                  const Divider(height: 1),

                  // Label SERVICES
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "SERVICES",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  // Faire une demande
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text(
                      "Faire une Demande",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DemandeFormScreen(),
                        ),
                      );
                    },
                  ),
                  // Consulter demandes
                  ListTile(
                    leading: Icon(
                      Icons.list_alt,
                      color:
                          currentPage == "Consulter Demandes"
                              ? Colors.purple
                              : Colors.grey[600],
                    ),
                    title: Text(
                      "Consulter Demandes",
                      style: TextStyle(
                        fontWeight:
                            currentPage == "Consulter Demandes"
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            currentPage == "Consulter Demandes"
                                ? Colors.purple
                                : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsulterDemandesScreen(),
                        ),
                      );
                    },
                  ),

                  // Notifications
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color:
                          currentPage == "Notifications"
                              ? Colors.orange
                              : Colors.grey[600],
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(
                        fontWeight:
                            currentPage == "Notifications"
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            currentPage == "Notifications"
                                ? Colors.orange
                                : Colors.black87,
                      ),
                    ),
                    onTap: () => _navigateTo("Notifications"),
                  ),

                  // Localiser établissement
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color:
                          currentPage == "Localiser Établissement"
                              ? Colors.red
                              : Colors.grey[600],
                    ),
                    title: Text(
                      "Localiser Établissement",
                      style: TextStyle(
                        fontWeight:
                            currentPage == "Localiser Établissement"
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            currentPage == "Localiser Établissement"
                                ? Colors.red
                                : Colors.black87,
                      ),
                    ),
                    onTap: () => _navigateTo("Localiser Établissement"),
                  ),

                  const Divider(),

                  // COMPTE label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "COMPTE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  // Profil élève
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.grey[600],
                    ),
                    title: const Text(
                      "Profil Élève",
                      style: TextStyle(color: Colors.black87),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentLogin(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Déconnexion
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Déconnexion",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: _logout,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),

      // Contenu principal
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getPageContent(),
      ),
    );
  }
}

// --------------------------------------
// Profil élève (exemple simplifié)
// --------------------------------------
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Élève"),
        backgroundColor: const Color.fromARGB(255, 107, 117, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
            SizedBox(height: 20),
            Text(
              "Nom Prénom",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("eleve@education.bf", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

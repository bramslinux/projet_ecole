import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/chef_etablissement_bashboard.dart';

class ChefSubscriptionScreen extends StatefulWidget {
  final String codeEtablissement;
  const ChefSubscriptionScreen({super.key, required this.codeEtablissement});

  @override
  State<ChefSubscriptionScreen> createState() => _ChefSubscriptionScreenState();
}

class _ChefSubscriptionScreenState extends State<ChefSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController(); 
bool _obscurePassword = true;
bool _obscureConfirmPassword = true;
  Map<String, dynamic>? _etablissementData;

  // Données fictives pour la démonstration
  final Map<String, Map<String, dynamic>> _mockEtablissements = {
    'CODE123': {'nom': 'Lycée Moderne', 'adresse': 'Abidjan'},
    'CODE456': {'nom': 'Collège International', 'adresse': 'Yamoussoukro'},
  };

  @override
  void initState() {
    super.initState();
    _etablissementData = _mockEtablissements[widget.codeEtablissement];
  }

  void _navigateTochefEtablissementSubscription() {
    if (_formKey.currentState!.validate()) {
      // TODO: Enregistrer dans le backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte chef d\'établissement créé avec succès')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChefLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 247, 246),
      appBar: AppBar(
        title: const Text("Souscription"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 🔙 Retourne à la page précédente
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Souscription d\'établissement',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Informations établissement
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Établissement: ${_etablissementData?['nom'] ?? 'Inconnu'}\n'
                    'Adresse: ${_etablissementData?['adresse'] ?? 'Inconnue'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                      height: 1.4,
                    ),
                  ),
                ),

                // Champ Identifiant
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Nom d\'utilisateur',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Nom d\'utilisateur requis' : null,
                  ),
                ),

                // Champ Mot de passe
                // Champ Mot de passe
// Champ Mot de passe
Container(
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
      hintText: 'Mot de passe',
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    ),
    validator: (value) =>
        value!.length < 6 ? 'Mot de passe trop court' : null,
  ),
),

// Champ Confirmation du mot de passe
Container(
  margin: const EdgeInsets.only(bottom: 32),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: TextFormField(
    controller: _confirmPasswordController,
    obscureText: _obscureConfirmPassword,
    decoration: InputDecoration(
      hintText: 'Confirmer le mot de passe',
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Confirmez le mot de passe';
      }
      if (value != _passwordController.text) {
        return 'Les mots de passe ne correspondent pas';
      }
      return null;
    },
  ),
),



                // Bouton Se connecter
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 46, 159, 204),
                        Color.fromARGB(255, 39, 93, 174)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _navigateTochefEtablissementSubscription();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Souscrire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

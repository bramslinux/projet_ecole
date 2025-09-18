import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_flutter/administration/parent/parent_bashbord.dart';
import 'package:school_flutter/administration/parent/cadr.dart';
import 'mobile.dart';

class ParentSubscriptionScreen extends StatefulWidget {
  const ParentSubscriptionScreen({super.key});

  @override
  State<ParentSubscriptionScreen> createState() => _ParentSubscriptionScreenState();
}

class _ParentSubscriptionScreenState extends State<ParentSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  
  bool _isMatriculeValid = false;
  bool _isVerifyingMatricule = false;
  Map<String, dynamic>? _studentData;

  final Map<String, Map<String, dynamic>> _mockDatabase = {
    'MAT123': {
      'nom': 'Jean Dupont', 
      'classe': '3ème', 
      'ecole': 'Lycée Moderne',
      'dateNaissance': '2008-05-15'
    },
    'MAT456': {
      'nom': 'Marie Koffi', 
      'classe': 'Terminale', 
      'ecole': 'Collège International',
      'dateNaissance': '2005-09-20'
    },
    'MAT789': {
      'nom': 'Pierre Martin', 
      'classe': '1ère', 
      'ecole': 'Lycée Technique',
      'dateNaissance': '2006-12-03'
    },
  };

  @override
  void dispose() {
    _matriculeController.dispose();
    super.dispose();
  }

  Future<void> _verifyMatricule() async {
    final matricule = _matriculeController.text.trim().toUpperCase();
    
    if (matricule.isEmpty) {
      _showSnackBar('Veuillez saisir un matricule', isError: true);
      return;
    }

    setState(() {
      _isVerifyingMatricule = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simule l'appel API

    if (_mockDatabase.containsKey(matricule)) {
      setState(() {
        _isMatriculeValid = true;
        _studentData = _mockDatabase[matricule];
        _isVerifyingMatricule = false;
      });
      _showSnackBar('Matricule vérifié avec succès', isError: false);
    } else {
      setState(() {
        _isMatriculeValid = false;
        _studentData = null;
        _isVerifyingMatricule = false;
      });
      _showSnackBar('Matricule non trouvé. Vérifiez et réessayez.', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _isMatriculeValid = false;
      _studentData = null;
      _matriculeController.clear();
    });
  }
// Exemple de fonction pour gérer la sélection d'un mode de paiement
void _selectPaymentMethod(String paymentMethod) async {
  // 1️⃣ Optionnel : Appel API pour créer la transaction côté serveur
  // await ApiService.createPayment({
  //   'eleve_id': studentId,
  //   'parent_id': parentId,
  //   'method': paymentMethod,
  //   'amount': montant,
  // });

  // 2️⃣ Redirection vers la page de paiement correspondante
  if (paymentMethod == 'Mobile Money') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MobileMoneyPaymentScreen()),
    );
  } else if (paymentMethod == 'Carte Bancaire') {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardPaymentScreen()),
    );
  
    // Redirection vers le dashboard parent ou confirmation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ParentDashboard()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Souscription Parent'),
        backgroundColor: const Color.fromARGB(255, 56, 118, 142),
        foregroundColor: Colors.white,
        actions: [
          if (_isMatriculeValid)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetForm,
              tooltip: 'Réinitialiser',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.family_restroom, size: 48, color: const Color.fromARGB(255, 56, 125, 142)),
                            const SizedBox(height: 8),
                            Text('Souscription parent',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: const Color.fromARGB(255, 56, 110, 142),
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 8),
                            Text('Saisissez le matricule de votre enfant pour commencer',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Champ matricule
                    TextFormField(
                      controller: _matriculeController,
                      decoration: InputDecoration(
                        labelText: 'Matricule de l\'élève *',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.tag_rounded),
                        suffixIcon: _isVerifyingMatricule
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : _isMatriculeValid
                                ? Icon(Icons.check_circle, color: const Color.fromARGB(255, 67, 115, 160))
                                : null,
                        helperText: 'Ex: MAT123, MAT456',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onFieldSubmitted: (_) => _verifyMatricule(),
                      onChanged: (_) {
                        if (_isMatriculeValid) {
                          setState(() {
                            _isMatriculeValid = false;
                            _studentData = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _isVerifyingMatricule ? null : _verifyMatricule,
                      icon: _isVerifyingMatricule
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.search),
                      label: Text(_isVerifyingMatricule ? 'Vérification...' : 'Vérifier Matricule'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color.fromARGB(255, 67, 141, 160),
                        foregroundColor: Colors.white,
                      ),
                    ),

                    // Informations de l'élève et modes de paiement
                    if (_isMatriculeValid && _studentData != null) ...[
                      const SizedBox(height: 24),
                      Card(
                        elevation: 3,
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: const Color.fromARGB(255, 56, 132, 142)),
                                  const SizedBox(width: 8),
                                  Text('Informations de l\'élève',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(255, 56, 100, 142),
                                          )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow('Nom', _studentData!['nom']),
                              _buildInfoRow('Classe', _studentData!['classe']),
                              _buildInfoRow('École', _studentData!['ecole']),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Modes de paiement
                     Text('Choisissez un mode de paiement',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: () => _selectPaymentMethod('Mobile Money'),
          icon: const Icon(Icons.mobile_friendly),
          label: const Text('Mobile Money'),
        ),
        const SizedBox(height: 8),

        ElevatedButton.icon(
          onPressed: () => _selectPaymentMethod('Carte Bancaire'),
          icon: const Icon(Icons.credit_card),
          label: const Text('Carte Bancaire'),
        ),
               const SizedBox(height: 8),
                              
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}

// Formatter pour convertir automatiquement en majuscules
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

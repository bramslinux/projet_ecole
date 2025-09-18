import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? _accessToken;
  static String? _refreshToken;
  static Map<String, dynamic>? _userInfo;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static Map<String, dynamic>? get userInfo => _userInfo;

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

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    final userInfoString = prefs.getString('user_info');
    if (userInfoString != null) {
      _userInfo = jsonDecode(userInfoString);
    }
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = null;
    _refreshToken = null;
    _userInfo = null;
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_info');
  }

  static bool get isLoggedIn => _accessToken != null;

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };
}

class ParentRegistrationScreen extends StatefulWidget {
  const ParentRegistrationScreen({super.key});

  @override
  State<ParentRegistrationScreen> createState() =>
      _ParentRegistrationScreenState();
}

class _ParentRegistrationScreenState extends State<ParentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  String? _error;
  String? _selectedGenre;
  String? _selectedLienParent;
  DateTime? _dateNaissance;

  final String apiUrl = "http://127.0.0.1:8000/api/utilisateurs/parents/";
  final String loginUrl = "http://127.0.0.1:8000/api/utilisateurs/login/";
  final List<String> _genreOptions = ['M', 'F'];
  final List<String> _lienParentOptions = ['pere', 'mere', 'tuteur'];

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  Future<void> _loadTokens() async {
    await AuthService.loadTokens();
    if (mounted) setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateNaissance = picked;
        _dateNaissanceController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _registerParent() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Formulaire invalide');
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showError('Les mots de passe ne correspondent pas');
      return;
    }

    if (_selectedLienParent == null) {
      _showError('Veuillez sélectionner un lien de parenté');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': _lastNameController.text.trim(),
          'prenom': _firstNameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'telephone': _phoneController.text.trim(),
          'date_naissance':
              _dateNaissanceController.text.trim().isEmpty
                  ? null
                  : _dateNaissanceController.text.trim(),
          'genre': _selectedGenre ?? '',
          'role': 'parent',
          'lien_parent': _selectedLienParent!,
        }),
      );

      if (response.statusCode == 201) {
        // Inscription réussie, procéder à la connexion automatique
        await _autoLoginAfterRegistration(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compte parent créé avec succès !'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Naviguer vers l'interface parent (à implémenter)
          Navigator.pushReplacementNamed(context, '/parent_interface');
        }
      } else {
        final errorBody = jsonDecode(response.body);
        String errorMessage =
            errorBody['detail'] ??
            errorBody['email']?.toString() ??
            'Erreur API: ${response.statusCode}';
        if (errorBody['email'] != null &&
            errorBody['email'].contains('already exists')) {
          errorMessage = 'Cet email est déjà utilisé';
        } else if (errorBody['non_field_errors'] != null) {
          errorMessage = errorBody['non_field_errors'][0].toString();
        }
        setState(() {
          _error = errorMessage;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur de connexion: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _autoLoginAfterRegistration(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await AuthService.saveTokens(
          accessToken: data['access'],
          refreshToken: data['refresh'],
          userInfo: data['user'],
        );
      } else {
        _showError('Erreur lors de la connexion automatique');
      }
    } catch (e) {
      _showError('Erreur lors de la connexion automatique: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function()? onTap,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
    required String Function(String) displayText,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      value: value,
      items:
          items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(displayText(item)),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un Compte Parent'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTokens,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child:
                  _isLoading
                      ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Création du compte...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _registerParent,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Réessayer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_add,
                                  size: 28,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Créer un Compte Parent',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Prénom
                            _buildTextField(
                              controller: _firstNameController,
                              label: 'Prénom *',
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Veuillez entrer votre prénom'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Nom
                            _buildTextField(
                              controller: _lastNameController,
                              label: 'Nom *',
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Veuillez entrer votre nom'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email *',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Veuillez entrer un email valide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Mot de passe
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Mot de passe *',
                              obscure: !_showPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un mot de passe';
                                }
                                if (value.length < 6) {
                                  return 'Le mot de passe doit contenir au moins 6 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirmation mot de passe
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirmer le mot de passe *',
                              obscure: !_showConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPassword =
                                        !_showConfirmPassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez confirmer le mot de passe';
                                }
                                if (value != _passwordController.text.trim()) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Téléphone
                            _buildTextField(
                              controller: _phoneController,
                              label: 'Téléphone',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (!RegExp(
                                    r'^\+?\d{8,15}$',
                                  ).hasMatch(value)) {
                                    return 'Veuillez entrer un numéro valide';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Date de naissance
                            _buildTextField(
                              controller: _dateNaissanceController,
                              label: 'Date de naissance',
                              readOnly: true,
                              onTap: _selectDate,
                              validator: (value) => null, // Facultatif
                            ),
                            const SizedBox(height: 16),

                            // Genre
                            _buildDropdownField(
                              label: 'Genre',
                              value: _selectedGenre,
                              items: _genreOptions,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGenre = value;
                                });
                              },
                              validator: (value) => null, // Facultatif
                              displayText:
                                  (value) =>
                                      value == 'M' ? 'Masculin' : 'Féminin',
                            ),
                            const SizedBox(height: 16),

                            // Lien parent
                            _buildDropdownField(
                              label: 'Lien de parenté *',
                              value: _selectedLienParent,
                              items: _lienParentOptions,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLienParent = value;
                                });
                              },
                              validator:
                                  (value) =>
                                      value == null
                                          ? 'Veuillez sélectionner un lien'
                                          : null,
                              displayText: (value) {
                                switch (value) {
                                  case 'pere':
                                    return 'Père';
                                  case 'mere':
                                    return 'Mère';
                                  case 'tuteur':
                                    return 'Tuteur';
                                  default:
                                    return value;
                                }
                              },
                            ),
                            const SizedBox(height: 32),

                            // Bouton de soumission
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _registerParent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Créer le compte',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            // Lien vers la connexion
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/parent_login');
                                },
                                child: const Text(
                                  'Déjà un compte ? Se connecter',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
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
    );
  }
}

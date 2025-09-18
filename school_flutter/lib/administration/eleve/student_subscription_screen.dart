import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Pour MediaType
import 'package:mime/mime.dart'; // Pour détecter automatiquement le type MIME

class StudentSubscriptionScreen extends StatefulWidget {
  const StudentSubscriptionScreen({super.key});
  @override
  State<StudentSubscriptionScreen> createState() =>
      _StudentSubscriptionScreenState();
}

class _StudentSubscriptionScreenState extends State<StudentSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  String? _selectedGenre;
  DateTime? _dateNaissance;
  Uint8List? _photoBytes;
  String? _photoName;

  final ImagePicker _imagePicker = ImagePicker();
  final List<String> _genreOptions = ['M', 'F'];

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _photoBytes = bytes;
        _photoName = image.name;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      firstDate: DateTime(1990),
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

  Future<void> _submitSubscription() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulaire invalide')),
      );
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/utilisateurs/eleves/');

    try {
      var request = http.MultipartRequest('POST', uri);

      // Champs du formulaire
      request.fields.addAll({
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'email': _emailController.text.trim(),
        'telephone': _telephoneController.text.trim(),
        'date_naissance': _dateNaissanceController.text.trim(),
        'genre': _selectedGenre ?? '',
        'password': _passwordController.text.trim(),
      });

      // Ajout de la photo si elle existe
      if (_photoBytes != null && _photoName != null) {
        final mimeType = lookupMimeType(_photoName!) ?? 'image/jpeg';
        final split = mimeType.split('/');
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            _photoBytes!,
            filename: _photoName!,
            contentType: MediaType(split[0], split[1]),
          ),
        );
      }

      // Envoi de la requête
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Élève créé avec succès !')),
        );
        // Optionnel : revenir à la page précédente ou écran de connexion
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur API: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    Widget? suffixIcon,
    void Function()? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: suffixIcon,
        ),
        readOnly: onTap != null,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription Élève'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: const Color(0xFFF5F5F7),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                    child: _photoBytes == null
                        ? const Icon(Icons.add_a_photo, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nomController,
                  label: 'Nom *',
                  validator: (v) => v == null || v.isEmpty ? 'Nom requis' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _prenomController,
                  label: 'Prénom *',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Prénom requis' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email *',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email requis';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(v)) return 'Email invalide';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Mot de passe *',
                  obscure: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Mot de passe requis' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmer mot de passe *',
                  obscure: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Confirmation requise' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _telephoneController,
                  label: 'Téléphone *',
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Téléphone requis' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _dateNaissanceController,
                  label: 'Date de naissance *',
                  onTap: _selectDate,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Date requise' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  decoration: const InputDecoration(
                    labelText: 'Genre *',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: _genreOptions
                      .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g == 'M' ? 'Masculin' : 'Féminin'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGenre = v),
                  validator: (v) => v == null ? 'Genre requis' : null,
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _submitSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Créer le compte',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

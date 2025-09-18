import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
  }

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  static Map<String, String> get authHeadersMultipart => {
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };
}

class DemandeFormScreen extends StatefulWidget {
  const DemandeFormScreen({super.key});

  @override
  State<DemandeFormScreen> createState() => _DemandeFormScreenState();
}

class _DemandeFormScreenState extends State<DemandeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Champs élève
  String? _nom;
  String? _prenom;
  String? _email;
  String? _password;
  // Dropdown dynamiques
  List<dynamic> _etablissements = [];
  List<dynamic> _niveaux = [];
  List<dynamic> _salles = [];
  // Variables pour les dropdowns
  String? _selectedEtablissementId;
  String? _selectedNiveauId;
  String? _selectedSalleId;
  // Fichiers
  PlatformFile? _bulletinFile;
  PlatformFile? _diplomeFile;
  Uint8List? _photoBytes;
  String? _photoName;
  // État de chargement et erreur
  bool _isLoading = true;
  String? _error;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchData();
  }

  Future<void> _loadTokenAndFetchData() async {
    await AuthService.loadTokens();
    await _fetchEtablissements();
  }

  Future<void> _fetchEtablissements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/administration/etablissements/"),
        headers: AuthService.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            _etablissements = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Données des établissements invalides";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error =
              "Impossible de charger les établissements (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur réseau lors du chargement des établissements";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNiveaux(int etablissementId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse(
          "http://127.0.0.1:8000/api/administration/classes/?etablissement=$etablissementId",
        ),
        headers: AuthService.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            _niveaux = data;
            _selectedNiveauId = null;
            _selectedSalleId = null;
            _salles = [];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Données des niveaux invalides";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = "Impossible de charger les niveaux (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur réseau lors du chargement des niveaux";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSalles(int niveauId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse(
          "http://127.0.0.1:8000/api/administration/salles/?classe=$niveauId",
        ),
        headers: AuthService.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            _salles = data;
            _selectedSalleId = null;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Données des salles invalides";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = "Impossible de charger les salles (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur réseau lors du chargement des salles";
        _isLoading = false;
      });
    }
  }

  Future<void> _pickPhoto() async {
    try {
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
    } catch (e) {
      _showError('Erreur lors de la sélection de la photo.');
    }
  }

  Future<void> _pickFile(String type) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          if (type == 'bulletin') _bulletinFile = result.files.first;
          if (type == 'diplome') _diplomeFile = result.files.first;
        });
      }
    } catch (e) {
      _showError('Erreur lors de la sélection du fichier.');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red[600]),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_selectedEtablissementId == null || _selectedNiveauId == null) {
      _showError("Veuillez remplir tous les champs obligatoires");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://127.0.0.1:8000/api/scolarite/demandes/"),
      );
      request.headers.addAll(AuthService.authHeadersMultipart);

      request.fields['eleve'] = "5"; // Remplacer par l'ID de l'élève connecté
      request.fields['etablissement'] = _selectedEtablissementId!;
      request.fields['niveau'] = _selectedNiveauId!;
      if (_selectedSalleId != null) {
        request.fields['salle'] = _selectedSalleId!;
      }

      if (_bulletinFile != null && _bulletinFile!.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath('bulletin', _bulletinFile!.path!),
        );
      }
      if (_diplomeFile != null && _diplomeFile!.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'dernier_diplome',
            _diplomeFile!.path!,
          ),
        );
      }
      if (_photoBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            _photoBytes!,
            filename: _photoName ?? "photo.jpg",
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Demande envoyée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Retour à la page précédente
        }
      } else {
        setState(() {
          _error =
              "Erreur lors de l'envoi (${response.statusCode}): $responseBody";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur réseau lors de l'envoi: $e";
        _isLoading = false;
      });
    }
  }

  Widget _buildFilePickerButton(String label, String type, PlatformFile? file) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _pickFile(type),
        icon: const Icon(Icons.upload_file, size: 20),
        label: Text(
          file?.name ?? label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          backgroundColor: Colors.blue.withOpacity(0.1),
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.blue.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<dynamic> items,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
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
              value: item['id']?.toString(),
              child: Text(
                item['nom']?.toString() ?? 'Nom non disponible',
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Demande'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTokenAndFetchData,
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
                              'Chargement des données...',
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
                              onPressed: _loadTokenAndFetchData,
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
                                  Icons.assignment,
                                  size: 28,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Nouvelle Demande',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Dropdown Établissement
                            _buildDropdownField(
                              label: 'Établissement *',
                              value: _selectedEtablissementId,
                              items: _etablissements,
                              onChanged: (String? val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedEtablissementId = val;
                                    _selectedNiveauId = null;
                                    _niveaux = [];
                                    _selectedSalleId = null;
                                    _salles = [];
                                  });
                                  final etablissementId = int.tryParse(val);
                                  if (etablissementId != null) {
                                    _fetchNiveaux(etablissementId);
                                  }
                                }
                              },
                              validator:
                                  (v) =>
                                      v == null
                                          ? 'Sélectionnez un établissement'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Dropdown Niveau
                            _buildDropdownField(
                              label: 'Niveau *',
                              value: _selectedNiveauId,
                              items: _niveaux,
                              onChanged: (String? val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedNiveauId = val;
                                    _selectedSalleId = null;
                                    _salles = [];
                                  });
                                  final niveauId = int.tryParse(val);
                                  if (niveauId != null) {
                                    _fetchSalles(niveauId);
                                  }
                                }
                              },
                              validator:
                                  (v) =>
                                      v == null
                                          ? 'Sélectionnez un niveau'
                                          : null,
                            ),
                            const SizedBox(height: 16),

                            // Dropdown Salle
                            _buildDropdownField(
                              label: 'Salle',
                              value: _selectedSalleId,
                              items: _salles,
                              onChanged: (String? val) {
                                setState(() {
                                  _selectedSalleId = val;
                                });
                              },
                              validator: (v) => null, // Salle est optionnelle
                            ),
                            const SizedBox(height: 24),

                            // Section fichiers
                            const Text(
                              'Documents à télécharger',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildFilePickerButton(
                              'Télécharger Bulletin',
                              'bulletin',
                              _bulletinFile,
                            ),
                            const SizedBox(height: 12),
                            _buildFilePickerButton(
                              'Télécharger Dernier Diplôme',
                              'diplome',
                              _diplomeFile,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _pickPhoto,
                                icon: const Icon(Icons.photo, size: 20),
                                label: Text(
                                  _photoName ?? 'Télécharger Photo',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  foregroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Aperçu de la photo
                            if (_photoBytes != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    _photoBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 32),

                            // Bouton de soumission
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submitForm,
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
                                  'Envoyer la demande',
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
    );
  }
}

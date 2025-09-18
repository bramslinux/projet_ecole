import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class DemandeFormScreen extends StatefulWidget {
  const DemandeFormScreen({super.key});

  @override
  State<DemandeFormScreen> createState() => _DemandeFormScreenState();
}

class _DemandeFormScreenState extends State<DemandeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedEtablissement;
  String? _selectedSalle;
  Uint8List? _photoBytes;
  String? _photoName;
  PlatformFile? _bulletinFile;
  PlatformFile? _diplomeFile;

  final List<String> _etablissements = ['Lycée Moderne', 'Collège International'];
  final Map<String, List<String>> _sallesParEtablissement = {
    'Lycée Moderne': ['Salle 101', 'Salle 102', 'Salle 103'],
    'Collège International': ['Salle A', 'Salle B', 'Salle C'],
  };

  final ImagePicker _imagePicker = ImagePicker();

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    print('Établissement: $_selectedEtablissement');
    print('Salle: $_selectedSalle');
    print('Photo: $_photoName');
    print('Bulletin: ${_bulletinFile?.name}');
    print('Diplome: ${_diplomeFile?.name}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demande envoyée !')),
    );
  }

  Widget _buildFilePickerButton(String label, String type, PlatformFile? file) {
    return ElevatedButton.icon(
      onPressed: () => _pickFile(type),
      icon: const Icon(Icons.upload_file),
      label: Text(file?.name ?? label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[900],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Demande'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
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
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Nouvelle Demande',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dropdown Établissement
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Établissement *',
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _selectedEtablissement,
                        items: _etablissements
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedEtablissement = val;
                            _selectedSalle = null;
                          });
                        },
                        validator: (v) => v == null ? 'Sélectionnez un établissement' : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Salle
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Salle *',
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _selectedSalle,
                        items: _selectedEtablissement == null
                            ? []
                            : _sallesParEtablissement[_selectedEtablissement]!
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                        onChanged: (val) => setState(() => _selectedSalle = val),
                        validator: (v) => v == null ? 'Sélectionnez une salle' : null,
                      ),
                      const SizedBox(height: 16),

                      // Fichiers
                      _buildFilePickerButton('Télécharger Bulletin', 'bulletin', _bulletinFile),
                      const SizedBox(height: 8),
                      _buildFilePickerButton('Télécharger Dernier Diplôme', 'diplome', _diplomeFile),
                      const SizedBox(height: 8),

                      // Photo
                      ElevatedButton.icon(
                        onPressed: _pickPhoto,
                        icon: const Icon(Icons.photo),
                        label: Text(_photoName ?? 'Télécharger Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[900],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                      if (_photoBytes != null) ...[
                        const SizedBox(height: 8),
                        Image.memory(_photoBytes!, height: 150),
                      ],
                      const SizedBox(height: 24),

                      // Bouton envoyer
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 107, 171, 255),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Envoyer la demande',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

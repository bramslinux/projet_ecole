import 'package:flutter/material.dart';

class SaisieNotesPage extends StatefulWidget {
  const SaisieNotesPage({super.key});

  @override
  State<SaisieNotesPage> createState() => _SaisieNotesPageState();
}

class _SaisieNotesPageState extends State<SaisieNotesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClasse;
  String? _selectedMatiere;
  String? _selectedEleve;

  final List<String> _classes = ['6ème A', '6ème B', '5ème A']; // Example data
  final List<String> _matieres = ['Mathématiques', 'Français', 'Histoire']; // Example data
  final List<String> _eleves = ['Élève 1', 'Élève 2', 'Élève 3']; // Example data
  
  final _noteController = TextEditingController();
  final _observationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saisie des Notes'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Classe selection
              DropdownButtonFormField<String>(
                value: _selectedClasse,
                decoration: const InputDecoration(
                  labelText: 'Sélectionner une classe',
                  border: OutlineInputBorder(),
                ),
                items: _classes.map((classe) {
                  return DropdownMenuItem(
                    value: classe,
                    child: Text(classe),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClasse = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une classe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Matière selection
              DropdownButtonFormField<String>(
                value: _selectedMatiere,
                decoration: const InputDecoration(
                  labelText: 'Sélectionner une matière',
                  border: OutlineInputBorder(),
                ),
                items: _matieres.map((matiere) {
                  return DropdownMenuItem(
                    value: matiere,
                    child: Text(matiere),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMatiere = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une matière';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Élève selection
              DropdownButtonFormField<String>(
                value: _selectedEleve,
                decoration: const InputDecoration(
                  labelText: 'Sélectionner un élève',
                  border: OutlineInputBorder(),
                ),
                items: _eleves.map((eleve) {
                  return DropdownMenuItem(
                    value: eleve,
                    child: Text(eleve),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEleve = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un élève';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Note input
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une note';
                  }
                  final note = double.tryParse(value);
                  if (note == null || note < 0 || note > 20) {
                    return 'La note doit être comprise entre 0 et 20';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Observation input
              TextFormField(
                controller: _observationController,
                decoration: const InputDecoration(
                  labelText: 'Observation',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save note to backend
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Note enregistrée avec succès'),
                        ),
                      );
                    }
                  },
                  child: const Text('Enregistrer la note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _observationController.dispose();
    super.dispose();
  }
}

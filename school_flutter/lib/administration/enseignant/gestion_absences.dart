import 'package:flutter/material.dart';

class GestionAbsencesPage extends StatefulWidget {
  const GestionAbsencesPage({super.key});

  @override
  State<GestionAbsencesPage> createState() => _GestionAbsencesPageState();
}

class _GestionAbsencesPageState extends State<GestionAbsencesPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClasse;
  String? _selectedEleve;
  DateTime? _selectedDate;

  final List<String> _classes = ['6ème A', '6ème B', '5ème A']; // Example data
  final List<String> _eleves = ['Élève 1', 'Élève 2', 'Élève 3']; // Example data
  
  final _motifController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Absences'),
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

              // Date selection
              ListTile(
                title: Text(_selectedDate == null 
                  ? 'Sélectionner une date'
                  : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              // Motif input
              TextFormField(
                controller: _motifController,
                decoration: const InputDecoration(
                  labelText: 'Motif de l\'absence',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un motif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedDate != null) {
                      // TODO: Save absence to backend
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Absence enregistrée avec succès'),
                        ),
                      );
                    } else if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez sélectionner une date'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Enregistrer l\'absence'),
                ),
              ),

              // List of recent absences
              const SizedBox(height: 32),
              const Text(
                'Absences récentes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5, // Example data
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Élève ${index + 1}'),
                      subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).day}/'
                          '${DateTime.now().subtract(Duration(days: index)).month}/'
                          '${DateTime.now().subtract(Duration(days: index)).year}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Implement absence deletion
                        },
                      ),
                    );
                  },
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
    _motifController.dispose();
    super.dispose();
  }
}

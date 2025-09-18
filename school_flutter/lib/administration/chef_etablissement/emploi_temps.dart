import 'package:flutter/material.dart';

class EmploiTempsPage extends StatefulWidget {
  const EmploiTempsPage({super.key});

  @override
  State<EmploiTempsPage> createState() => _EmploiTempsPageState();
}

class _EmploiTempsPageState extends State<EmploiTempsPage> {
  String? _selectedClasse;
  final List<String> _classes = ['6ème A', '6ème B', '5ème A']; // Example data
  final List<String> _jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
  final List<String> _heures = ['8h-9h', '9h-10h', '10h-11h', '11h-12h', '14h-15h', '15h-16h'];

  // Example data structure for schedule
  final Map<String, Map<String, String>> _emploiTemps = {
    'Lundi': {
      '8h-9h': 'Mathématiques',
      '9h-10h': 'Français',
      '10h-11h': 'Histoire',
      '11h-12h': 'Géographie',
      '14h-15h': 'Sciences',
      '15h-16h': 'Sport',
    },
    // Add more days...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emploi du Temps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Export schedule
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Class selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
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
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add new schedule entry
                    _showAddScheduleDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
          ),

          // Schedule table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey[200],
                  ),
                  columns: [
                    const DataColumn(label: Text('Heures')),
                    ..._jours.map((jour) => DataColumn(label: Text(jour))),
                  ],
                  rows: _heures.map((heure) {
                    return DataRow(
                      cells: [
                        DataCell(Text(heure)),
                        ..._jours.map((jour) {
                          final cours = _emploiTemps[jour]?[heure] ?? '';
                          return DataCell(
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                color: cours.isNotEmpty ? Colors.blue[50] : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(cours),
                                  if (cours.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 16),
                                      onPressed: () => _showEditScheduleDialog(jour, heure, cours),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            onTap: () => _showAddScheduleDialog(jour: jour, heure: heure),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog({String? jour, String? heure}) {
    final _matiereController = TextEditingController();
    final _enseignantController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(jour != null && heure != null 
          ? 'Ajouter un cours pour $jour à $heure' 
          : 'Ajouter un cours'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (jour == null || heure == null) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Jour',
                    border: OutlineInputBorder(),
                  ),
                  items: _jours.map((j) => DropdownMenuItem(
                    value: j,
                    child: Text(j),
                  )).toList(),
                  onChanged: (value) {
                    // TODO: Handle day selection
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Heure',
                    border: OutlineInputBorder(),
                  ),
                  items: _heures.map((h) => DropdownMenuItem(
                    value: h,
                    child: Text(h),
                  )).toList(),
                  onChanged: (value) {
                    // TODO: Handle time selection
                  },
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _matiereController,
                decoration: const InputDecoration(
                  labelText: 'Matière',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _enseignantController,
                decoration: const InputDecoration(
                  labelText: 'Enseignant',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save schedule entry
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleDialog(String jour, String heure, String cours) {
    final _matiereController = TextEditingController(text: cours);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le cours de $jour à $heure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _matiereController,
              decoration: const InputDecoration(
                labelText: 'Matière',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Delete schedule entry
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Update schedule entry
              Navigator.pop(context);
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';



void main() {
  runApp(const BulletinPage ());
}

class BulletinPage extends StatefulWidget {
  const BulletinPage({super.key});

  @override
  State<BulletinPage> createState() => _BulletinPageState();
}

class _BulletinPageState extends State<BulletinPage> {
  String? _selectedClasse;
  String? _selectedPeriode;
  String? _selectedEleve;

  final List<String> _classes = ['6ème A', '6ème B', '5ème A']; // Example data
  final List<String> _periodes = [
    '1er Trimestre 2024-2025',
    '2ème Trimestre 2024-2025',
    '3ème Trimestre 2024-2025'
  ];
  final List<String> _eleves = ['Élève 1', 'Élève 2', 'Élève 3']; // Example data

  // Example bulletin data
  final Map<String, List<Map<String, dynamic>>> _matieres = {
    'Matières principales': [
      {
        'nom': 'Mathématiques',
        'coef': 4,
        'note1': 15,
        'note2': 14,
        'moyenne': 14.5,
        'appreciation': 'Bon travail, continuez ainsi',
      },
      {
        'nom': 'Français',
        'coef': 4,
        'note1': 13,
        'note2': 12,
        'moyenne': 12.5,
        'appreciation': 'Des progrès à faire en expression écrite',
      },
    ],
    'Sciences': [
      {
        'nom': 'Physique-Chimie',
        'coef': 3,
        'note1': 16,
        'note2': 15,
        'moyenne': 15.5,
        'appreciation': 'Excellent niveau',
      },
      {
        'nom': 'SVT',
        'coef': 3,
        'note1': 14,
        'note2': 13,
        'moyenne': 13.5,
        'appreciation': 'Bon trimestre',
      },
    ],
    'Sciences Humaines': [
      {
        'nom': 'Histoire-Géographie',
        'coef': 2,
        'note1': 12,
        'note2': 13,
        'moyenne': 12.5,
        'appreciation': 'Participation active en classe',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Génération des Bulletins'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Print bulletin
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // TODO: Export as PDF
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left panel - Selection and filters
            SizedBox(
              width: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sélection',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedClasse,
                        decoration: const InputDecoration(
                          labelText: 'Classe',
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedPeriode,
                        decoration: const InputDecoration(
                          labelText: 'Période',
                          border: OutlineInputBorder(),
                        ),
                        items: _periodes.map((periode) {
                          return DropdownMenuItem(
                            value: periode,
                            child: Text(periode),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedEleve,
                        decoration: const InputDecoration(
                          labelText: 'Élève',
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
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Generate bulletin
                          },
                          child: const Text('Générer le bulletin'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Right panel - Bulletin preview
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ÉTABLISSEMENT SCOLAIRE',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedPeriode ?? 'Sélectionnez une période',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _selectedEleve ?? 'Sélectionnez un élève',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedClasse ?? 'Sélectionnez une classe',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Grades table
                      for (var category in _matieres.keys) ...[
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Table(
                          border: TableBorder.all(
                            color: Colors.grey[300]!,
                          ),
                          columnWidths: const {
                            0: FlexColumnWidth(3), // Matière
                            1: FlexColumnWidth(1), // Coef
                            2: FlexColumnWidth(1), // Note 1
                            3: FlexColumnWidth(1), // Note 2
                            4: FlexColumnWidth(1), // Moyenne
                            5: FlexColumnWidth(4), // Appréciation
                          },
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Matière',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Coef',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Note 1',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Note 2',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Moyenne',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Appréciation',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var matiere in _matieres[category]!)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(matiere['nom']),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(matiere['coef'].toString()),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(matiere['note1'].toString()),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(matiere['note2'].toString()),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        matiere['moyenne'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(matiere['appreciation']),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Summary
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'RÉSULTATS DU TRIMESTRE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryItem('Moyenne générale', '13.8/20'),
                                _buildSummaryItem('Rang', '5/32'),
                                _buildSummaryItem('Mention', 'Assez bien'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Appréciation générale : Bon trimestre dans l\'ensemble. Continuez vos efforts pour progresser davantage.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

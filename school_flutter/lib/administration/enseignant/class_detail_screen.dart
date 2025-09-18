import 'package:flutter/material.dart';

class ClassDetailScreen extends StatefulWidget {
  final String className;
  final String subject;

  const ClassDetailScreen({
    super.key,
    required this.className,
    required this.subject,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ClassHomePage(),
      StudentListPage(className: widget.className),
      const AbsenceReportPage(),
      const GradesEntryPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.className} - ${widget.subject}'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.class_,
                      size: 40,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.className,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.subject,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Liste des élèves'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_busy),
              title: const Text('Signaler absences'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Saisir les notes'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class ClassHomePage extends StatelessWidget {
  const ClassHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> classStats = {
      'totalStudents': 25,
      'averageGrade': 14.5,
      'lastEvaluation': '15 Sept - Contrôle continu',
      'nextEvaluation': '22 Sept - Devoir surveillé',
      'absenceRate': '4%',
      'recentActivities': [
        {
          'type': 'Note',
          'date': '11 Sept',
          'description': 'Notes du dernier contrôle saisies'
        },
        {
          'type': 'Absence',
          'date': '10 Sept',
          'description': '2 absences signalées'
        },
        {
          'type': 'Evaluation',
          'date': '8 Sept',
          'description': 'Nouvelle évaluation programmée'
        },
      ],
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques rapides
          Row(
            children: [
              _buildStatCard(
                'Élèves',
                classStats['totalStudents'].toString(),
                Icons.people,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Moyenne',
                '${classStats['averageGrade']}/20',
                Icons.analytics,
                Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Absences',
                classStats['absenceRate'],
                Icons.event_busy,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Prochaines évaluations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Évaluations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dernière évaluation',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classStats['lastEvaluation'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Prochaine évaluation',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                classStats['nextEvaluation'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Activités récentes
          const Text(
            'Activités récentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...classStats['recentActivities'].map<Widget>((activity) {
            IconData icon;
            Color color;
            switch (activity['type']) {
              case 'Note':
                icon = Icons.grade;
                color = Colors.blue;
                break;
              case 'Absence':
                icon = Icons.event_busy;
                color = Colors.red;
                break;
              case 'Evaluation':
                icon = Icons.event_note;
                color = Colors.green;
                break;
              default:
                icon = Icons.info;
                color = Colors.grey;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                title: Text(activity['description']),
                subtitle: Text(activity['date']),
              ),
            );
          }).toList(),

          const SizedBox(height: 16),
          // Boutons d'action rapide
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigation vers la saisie des notes
                    final state = context.findAncestorStateOfType<_ClassDetailScreenState>();
                    if (state != null) {
                      state.setState(() {
                        state._selectedIndex = 3; // Index de la page de notes
                      });
                    }
                  },
                  icon: const Icon(Icons.add_chart),
                  label: const Text('Saisir des notes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF4A90E2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigation vers le signalement d'absence
                    final state = context.findAncestorStateOfType<_ClassDetailScreenState>();
                    if (state != null) {
                      state.setState(() {
                        state._selectedIndex = 2; // Index de la page d'absences
                      });
                    }
                  },
                  icon: const Icon(Icons.person_off),
                  label: const Text('Signaler absence'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentListPage extends StatelessWidget {
  final String className;

  const StudentListPage({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    // Liste fictive d'élèves
    final students = [
      {'nom': 'Jean Dupont', 'matricule': 'STD001'},
      {'nom': 'Marie Martin', 'matricule': 'STD002'},
      {'nom': 'Pierre Durant', 'matricule': 'STD003'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liste des élèves - $className',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(student['nom'] as String),
                    subtitle: Text(student['matricule'] as String),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AbsenceReportPage extends StatefulWidget {
  const AbsenceReportPage({super.key});

  @override
  State<AbsenceReportPage> createState() => _AbsenceReportPageState();
}

class _AbsenceReportPageState extends State<AbsenceReportPage> {
  final List<Map<String, dynamic>> _students = [
    {
      'nom': 'Jean Dupont',
      'matricule': 'STD001',
      'isAbsent': false,
      'date': DateTime.now(),
      'justification': '',
    },
    {
      'nom': 'Marie Martin',
      'matricule': 'STD002',
      'isAbsent': false,
      'date': DateTime.now(),
      'justification': '',
    },
    {
      'nom': 'Pierre Durant',
      'matricule': 'STD003',
      'isAbsent': false,
      'date': DateTime.now(),
      'justification': '',
    },
  ];

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showJustificationDialog(int index) {
    final controller = TextEditingController(text: _students[index]['justification']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une justification'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Entrez la justification',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _students[index]['justification'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec date
          Row(
            children: [
              const Text(
                'Signalement des absences',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Liste des élèves
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(student['nom'].substring(0, 1)),
                    ),
                    title: Text(student['nom']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['matricule']),
                        if (student['justification'].isNotEmpty)
                          Text(
                            'Justification: ${student['justification']}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.note_add),
                          onPressed: () => _showJustificationDialog(index),
                        ),
                        Switch(
                          value: student['isAbsent'],
                          onChanged: (bool value) {
                            setState(() {
                              student['isAbsent'] = value;
                              student['date'] = _selectedDate;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bouton de validation
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Logique pour enregistrer les absences
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Absences enregistrées avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF4A90E2),
              ),
              child: const Text('Enregistrer les absences'),
            ),
          ),
        ],
      ),
    );
  }
}

class GradesEntryPage extends StatefulWidget {
  const GradesEntryPage({super.key});

  @override
  State<GradesEntryPage> createState() => _GradesEntryPageState();
}

class _GradesEntryPageState extends State<GradesEntryPage> {
  final List<Map<String, dynamic>> _students = [
    {
      'nom': 'Jean Dupont',
      'matricule': 'STD001',
      'note': null,
      'appreciation': '',
    },
    {
      'nom': 'Marie Martin',
      'matricule': 'STD002',
      'note': null,
      'appreciation': '',
    },
    {
      'nom': 'Pierre Durant',
      'matricule': 'STD003',
      'note': null,
      'appreciation': '',
    },
  ];

  String _evaluationType = 'Devoir';
  final List<String> _evaluationTypes = [
    'Devoir',
    'Contrôle continu',
    'Examen',
    'TP',
  ];

  void _showAppreciationDialog(int index) {
    final controller = TextEditingController(text: _students[index]['appreciation']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une appréciation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Entrez l\'appréciation',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _students[index]['appreciation'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec type d'évaluation
          Row(
            children: [
              const Text(
                'Saisie des notes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _evaluationType,
                items: _evaluationTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _evaluationType = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Liste des élèves avec notes
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(student['nom'].substring(0, 1)),
                    ),
                    title: Text(student['nom']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student['matricule']),
                        if (student['appreciation'].isNotEmpty)
                          Text(
                            'Appréciation: ${student['appreciation']}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 60,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Note',
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onChanged: (value) {
                              final note = double.tryParse(value);
                              if (note != null && note >= 0 && note <= 20) {
                                setState(() {
                                  student['note'] = note;
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () => _showAppreciationDialog(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Boutons d'action
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logique pour exporter en PDF
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Exporter en PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logique pour enregistrer les notes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notes enregistrées avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF4A90E2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

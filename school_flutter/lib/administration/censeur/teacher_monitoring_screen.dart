import 'package:flutter/material.dart';

class TeacherMonitoringPage extends StatefulWidget {
  final List<dynamic> activities;

  const TeacherMonitoringPage({super.key, required this.activities});

  @override
  State<TeacherMonitoringPage> createState() => _TeacherMonitoringPageState();
}

class _TeacherMonitoringPageState extends State<TeacherMonitoringPage> {
  String _selectedTeacher = 'Tous';
  String _selectedClass = 'Toutes';
  String _selectedSubject = 'Toutes';

  final List<String> _teachers = [
    'Tous', 'M. Dupont', 'Mme Martin', 'M. Durant'
  ];

  final List<String> _classes = [
    'Toutes', '3ème A', '3ème B', '4ème A', '4ème B'
  ];

  final List<String> _subjects = [
    'Toutes', 'Mathématiques', 'Physique', 'Français'
  ];

  List<dynamic> get _filteredActivities {
    return widget.activities.where((activity) {
      bool teacherMatch = _selectedTeacher == 'Tous' || 
                         activity['teacher'] == _selectedTeacher;
      bool classMatch = _selectedClass == 'Toutes' || 
                       activity['class'] == _selectedClass;
      bool subjectMatch = _selectedSubject == 'Toutes' || 
                         activity['subject'] == _selectedSubject;
      return teacherMatch && classMatch && subjectMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suivi des enseignants',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 16),

          // Filtres
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedTeacher,
                          decoration: const InputDecoration(
                            labelText: 'Enseignant',
                            border: OutlineInputBorder(),
                          ),
                          items: _teachers.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedTeacher = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedClass,
                          decoration: const InputDecoration(
                            labelText: 'Classe',
                            border: OutlineInputBorder(),
                          ),
                          items: _classes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedClass = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Matière',
                      border: OutlineInputBorder(),
                    ),
                    items: _subjects.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Liste des activités filtrées
          Expanded(
            child: ListView.builder(
              itemCount: _filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = _filteredActivities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getActivityColor(activity['type']).withOpacity(0.2),
                      child: Icon(
                        _getActivityIcon(activity['type']),
                        color: _getActivityColor(activity['type']),
                      ),
                    ),
                    title: Text(activity['teacher']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${activity['class']} - ${activity['subject']}'),
                        Text(
                          activity['date'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showActivityDetails(activity),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'Note':
        return Colors.blue;
      case 'Devoir':
        return Colors.green;
      case 'Absence':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'Note':
        return Icons.grade;
      case 'Devoir':
        return Icons.assignment;
      case 'Absence':
        return Icons.person_off;
      default:
        return Icons.info;
    }
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity['teacher']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${activity['type']}'),
            const SizedBox(height: 8),
            Text('Classe: ${activity['class']}'),
            const SizedBox(height: 8),
            Text('Matière: ${activity['subject']}'),
            const SizedBox(height: 8),
            Text('Date: ${activity['date']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter l'action de contact
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message envoyé à l\'enseignant'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Contacter l\'enseignant'),
          ),
        ],
      ),
    );
  }
}

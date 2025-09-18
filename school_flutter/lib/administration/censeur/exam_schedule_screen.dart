import 'package:flutter/material.dart';

class ExamSchedulePage extends StatefulWidget {
  final List<dynamic> upcomingExams;

  const ExamSchedulePage({super.key, required this.upcomingExams});

  @override
  State<ExamSchedulePage> createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedClass;
  String? _selectedSubject;

  final List<String> _classes = [
    '3ème A', '3ème B', '4ème A', '4ème B', '5ème A', '5ème B'
  ];

  final List<String> _subjects = [
    'Mathématiques', 'Physique', 'Français', 'Histoire', 'Anglais'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showAddExamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programmer un devoir'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sélection de la classe
              DropdownButtonFormField<String>(
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
                  setState(() {
                    _selectedClass = newValue;
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

              // Sélection de la matière
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
                  setState(() {
                    _selectedSubject = newValue;
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

              // Sélection de la date
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sélection de l'heure
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Heure',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une heure';
                  }
                  return null;
                },
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
              if (_formKey.currentState!.validate()) {
                // TODO: Sauvegarder le devoir
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Devoir programmé avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Programmer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Programmation des devoirs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddExamDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nouveau devoir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Liste des devoirs programmés
            Expanded(
              child: ListView.builder(
                itemCount: widget.upcomingExams.length,
                itemBuilder: (context, index) {
                  final exam = widget.upcomingExams[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF4A90E2),
                        child: Icon(Icons.assignment, color: Colors.white),
                      ),
                      title: Text('${exam['class']} - ${exam['subject']}'),
                      subtitle: Text('${exam['date']} à ${exam['time']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Implémenter la suppression
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Devoir supprimé'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

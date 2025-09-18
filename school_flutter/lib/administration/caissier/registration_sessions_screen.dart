import 'package:flutter/material.dart';

class RegistrationSessionsScreen extends StatefulWidget {
  const RegistrationSessionsScreen({super.key});

  @override
  State<RegistrationSessionsScreen> createState() =>
      _RegistrationSessionsScreenState();
}

class _RegistrationSessionsScreenState extends State<RegistrationSessionsScreen> {
  bool _isNewSessionDialogOpen = false;

  // Exemple de données (à remplacer par les vraies données)
  final List<Map<String, dynamic>> _sessions = [
    {
      'id': '1',
      'type': 'Inscription',
      'startDate': '2025-09-01',
      'endDate': '2025-09-30',
      'status': 'En cours',
      'levels': ['1ère année', '2ème année'],
    },
    {
      'id': '2',
      'type': 'Réinscription',
      'startDate': '2025-08-15',
      'endDate': '2025-09-15',
      'status': 'Terminée',
      'levels': ['2ème année', '3ème année', '4ème année'],
    },
    // Ajoutez plus de sessions ici
  ];

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
                  'Sessions d\'inscription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showNewSessionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste des sessions
            Expanded(
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: _getStatusColor(session['status']).withOpacity(0.2),
                        child: Icon(
                          session['type'] == 'Inscription'
                              ? Icons.how_to_reg
                              : Icons.refresh,
                          color: _getStatusColor(session['status']),
                        ),
                      ),
                      title: Text(
                        '${session['type']} ${_getSessionYear(session['startDate'])}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Du ${session['startDate']} au ${session['endDate']}',
                          ),
                          Text(
                            'Status: ${session['status']}',
                            style: TextStyle(
                              color: _getStatusColor(session['status']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Niveaux concernés:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: (session['levels'] as List<String>)
                                    .map((level) => Chip(
                                          label: Text(level),
                                          backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (session['status'] != 'Terminée') ...[
                                    TextButton.icon(
                                      onPressed: () => _editSession(session),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Modifier'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () => _endSession(session),
                                      icon: const Icon(Icons.stop_circle),
                                      label: const Text('Terminer'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En cours':
        return Colors.green;
      case 'À venir':
        return Colors.blue;
      case 'Terminée':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getSessionYear(String startDate) {
    return startDate.substring(0, 4);
  }

  void _showNewSessionDialog() {
    if (_isNewSessionDialogOpen) return;
    _isNewSessionDialogOpen = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle session'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Inscription',
                    child: Text('Inscription'),
                  ),
                  DropdownMenuItem(
                    value: 'Réinscription',
                    child: Text('Réinscription'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Date de début',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Date de fin',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Niveaux concernés:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('1ère année'),
                    selected: true,
                    onSelected: (bool value) {},
                  ),
                  FilterChip(
                    label: const Text('2ème année'),
                    selected: false,
                    onSelected: (bool value) {},
                  ),
                  FilterChip(
                    label: const Text('3ème année'),
                    selected: false,
                    onSelected: (bool value) {},
                  ),
                  FilterChip(
                    label: const Text('4ème année'),
                    selected: false,
                    onSelected: (bool value) {},
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _isNewSessionDialogOpen = false;
            },
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la création de session
              Navigator.pop(context);
              _isNewSessionDialogOpen = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session créée avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    ).then((_) => _isNewSessionDialogOpen = false);
  }

  void _editSession(Map<String, dynamic> session) {
    // TODO: Implémenter la modification de session
  }

  void _endSession(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la session'),
        content: Text(
          'Voulez-vous vraiment terminer la session de ${session['type']} ${_getSessionYear(session['startDate'])} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la fin de session
              Navigator.pop(context);
              setState(() {
                session['status'] = 'Terminée';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session terminée'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }
}

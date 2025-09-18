import 'package:flutter/material.dart';

class RegistrationRequestsScreen extends StatefulWidget {
  const RegistrationRequestsScreen({super.key});

  @override
  State<RegistrationRequestsScreen> createState() =>
      _RegistrationRequestsScreenState();
}

class _RegistrationRequestsScreenState extends State<RegistrationRequestsScreen> {
  String _selectedStatus = 'Tous';
  String _selectedLevel = 'Tous';

  final List<String> _statusFilters = [
    'Tous',
    'En attente',
    'Validé',
    'Rejeté'
  ];

  final List<String> _levelFilters = [
    'Tous',
    '1ère année',
    '2ème année',
    '3ème année',
    '4ème année'
  ];

  // Exemple de données (à remplacer par les vraies données)
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'studentName': 'Jean Dupont',
      'level': '1ère année',
      'status': 'En attente',
      'date': '2025-09-10',
      'paymentProof': 'reçu_123.pdf',
    },
    {
      'id': '2',
      'studentName': 'Marie Martin',
      'level': '2ème année',
      'status': 'Validé',
      'date': '2025-09-11',
      'paymentProof': 'reçu_124.pdf',
    },
    // Ajoutez plus de données ici
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    return _requests.where((request) {
      bool statusMatch = _selectedStatus == 'Tous' ||
          request['status'] == _selectedStatus;
      bool levelMatch =
          _selectedLevel == 'Tous' || request['level'] == _selectedLevel;
      return statusMatch && levelMatch;
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
            'Demandes d\'inscription',
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
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        border: OutlineInputBorder(),
                      ),
                      items: _statusFilters.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedLevel,
                      decoration: const InputDecoration(
                        labelText: 'Niveau',
                        border: OutlineInputBorder(),
                      ),
                      items: _levelFilters.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLevel = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Liste des demandes
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                final request = _filteredRequests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(request['status']).withOpacity(0.2),
                      child: Icon(
                        _getStatusIcon(request['status']),
                        color: _getStatusColor(request['status']),
                      ),
                    ),
                    title: Text(request['studentName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Niveau: ${request['level']}'),
                        Text(
                          'Date: ${request['date']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: request['status'] == 'En attente'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () => _validateRequest(request),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () => _rejectRequest(request),
                              ),
                            ],
                          )
                        : Text(
                            request['status'],
                            style: TextStyle(
                              color: _getStatusColor(request['status']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    onTap: () => _showRequestDetails(request),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En attente':
        return Colors.orange;
      case 'Validé':
        return Colors.green;
      case 'Rejeté':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'En attente':
        return Icons.pending;
      case 'Validé':
        return Icons.check_circle;
      case 'Rejeté':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demande de ${request['studentName']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${request['id']}'),
            const SizedBox(height: 8),
            Text('Niveau: ${request['level']}'),
            const SizedBox(height: 8),
            Text('Date: ${request['date']}'),
            const SizedBox(height: 8),
            Text('Statut: ${request['status']}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implémenter la visualisation du reçu
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Voir le reçu de paiement'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _validateRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider la demande'),
        content: Text('Voulez-vous vraiment valider la demande de ${request['studentName']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la validation
              Navigator.pop(context);
              setState(() {
                request['status'] = 'Validé';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demande validée avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter la demande'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Voulez-vous vraiment rejeter la demande de ${request['studentName']} ?'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Motif du rejet',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter le rejet
              Navigator.pop(context);
              setState(() {
                request['status'] = 'Rejeté';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demande rejetée'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );
  }
}

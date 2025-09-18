import 'package:flutter/material.dart';

class SystemeNotificationsPage extends StatefulWidget {
  const SystemeNotificationsPage({super.key});

  @override
  State<SystemeNotificationsPage> createState() => _SystemeNotificationsPageState();
}

class _SystemeNotificationsPageState extends State<SystemeNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String? _selectedDestinataire;
  final _titreController = TextEditingController();
  final _messageController = TextEditingController();

  final List<String> _typesNotification = [
    'Information générale',
    'Urgence',
    'Événement',
    'Rappel',
    'Note',
    'Absence',
    'Paiement',
  ];

  final List<String> _destinataires = [
    'Tous les utilisateurs',
    'Parents',
    'Enseignants',
    'Élèves',
    'Personnel administratif',
    'Classe spécifique',
  ];

  // Example notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'titre': 'Réunion parents-professeurs',
      'message': 'Réunion prévue le 15 septembre à 14h',
      'type': 'Événement',
      'destinataires': 'Parents',
      'date': '2024-09-01 10:00',
      'status': 'Envoyé',
    },
    {
      'id': '2',
      'titre': 'Rappel paiement frais scolaires',
      'message': 'Date limite le 30 septembre',
      'type': 'Paiement',
      'destinataires': 'Parents',
      'date': '2024-09-02 09:00',
      'status': 'Programmé',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Système de Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Notification Form
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nouvelle Notification',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Type selection
                        DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Type de notification',
                            border: OutlineInputBorder(),
                          ),
                          items: _typesNotification.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner un type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Recipient selection
                        DropdownButtonFormField<String>(
                          value: _selectedDestinataire,
                          decoration: const InputDecoration(
                            labelText: 'Destinataires',
                            border: OutlineInputBorder(),
                          ),
                          items: _destinataires.map((dest) {
                            return DropdownMenuItem(
                              value: dest,
                              child: Text(dest),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDestinataire = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner les destinataires';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Title input
                        TextFormField(
                          controller: _titreController,
                          decoration: const InputDecoration(
                            labelText: 'Titre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un titre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Message input
                        TextFormField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un message';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Send buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // TODO: Save as draft
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Enregistrer comme brouillon'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _showScheduleDialog();
                                }
                              },
                              icon: const Icon(Icons.schedule),
                              label: const Text('Programmer'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // TODO: Send notification
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Notification envoyée'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.send),
                              label: const Text('Envoyer maintenant'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Right side - Notifications List
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Notifications récentes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              // TODO: Show filter options
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            final notification = _notifications[index];
                            return Card(
                              child: ListTile(
                                leading: _getNotificationIcon(notification['type']),
                                title: Text(notification['titre']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notification['message']),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.group,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          notification['destinataires'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      notification['date'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Chip(
                                      label: Text(
                                        notification['status'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: notification['status'] == 'Envoyé'
                                          ? Colors.green[100]
                                          : Colors.orange[100],
                                    ),
                                  ],
                                ),
                                onTap: () => _showNotificationDetails(notification),
                              ),
                            );
                          },
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

  Widget _getNotificationIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'Information générale':
        iconData = Icons.info;
        color = Colors.blue;
        break;
      case 'Urgence':
        iconData = Icons.warning;
        color = Colors.red;
        break;
      case 'Événement':
        iconData = Icons.event;
        color = Colors.green;
        break;
      case 'Rappel':
        iconData = Icons.alarm;
        color = Colors.orange;
        break;
      case 'Note':
        iconData = Icons.grade;
        color = Colors.purple;
        break;
      case 'Absence':
        iconData = Icons.person_off;
        color = Colors.brown;
        break;
      case 'Paiement':
        iconData = Icons.payment;
        color = Colors.indigo;
        break;
      default:
        iconData = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(iconData, color: color),
    );
  }

  void _showScheduleDialog() {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programmer la notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                'Heure: ${selectedTime.format(context)}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
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
              // TODO: Schedule notification
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification programmée'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Programmer'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['titre']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${notification['type']}'),
            const SizedBox(height: 8),
            Text('Destinataires: ${notification['destinataires']}'),
            const SizedBox(height: 8),
            Text('Date: ${notification['date']}'),
            const SizedBox(height: 8),
            Text('Statut: ${notification['status']}'),
            const SizedBox(height: 16),
            const Text('Message:'),
            const SizedBox(height: 8),
            Text(notification['message']),
          ],
        ),
        actions: [
          if (notification['status'] == 'Programmé')
            TextButton(
              onPressed: () {
                // TODO: Cancel scheduled notification
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Annuler la programmation'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

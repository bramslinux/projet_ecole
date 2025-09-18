import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/controllers/notification_controller.dart';
import 'package:school_flutter/administration/chef_etablissement/models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "Réunion des parents",
      message: "Réunion des parents d'élèves prévue le 15 septembre à 14h",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.event,
    ),
    NotificationItem(
      title: "Bulletin trimestriel",
      message: "Les bulletins du premier trimestre sont disponibles",
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.academic,
    ),
    NotificationItem(
      title: "Maintenance système",
      message: "Une maintenance du système est prévue ce weekend",
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.system,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddNotificationDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher une notification...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<NotificationType>(
                  hint: const Text('Filtrer par type'),
                  items: NotificationType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // TODO: Implement filter
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notification.type.color.withOpacity(0.2),
                      child: Icon(
                        notification.type.icon,
                        color: notification.type.color,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notification.message),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Modifier'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Supprimer'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditNotificationDialog(notification);
                        } else if (value == 'delete') {
                          _showDeleteConfirmationDialog(notification);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNotificationDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Il y a ${difference.inMinutes} minutes';
      }
      return 'Il y a ${difference.inHours} heures';
    } else if (difference.inDays == 1) {
      return 'Hier';
    }
    return 'Il y a ${difference.inDays} jours';
  }

  void _showAddNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<NotificationType>(
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: NotificationType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                // TODO: Handle type selection
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
              // TODO: Implement notification creation
              Navigator.pop(context);
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditNotificationDialog(NotificationItem notification) {
    // TODO: Implement edit dialog
  }

  void _showDeleteConfirmationDialog(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer la notification "${notification.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.remove(notification);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.type,
  });
}

enum NotificationType {
  event,
  academic,
  system,
  alert,
}

extension NotificationTypeExtension on NotificationType {
  Color get color {
    switch (this) {
      case NotificationType.event:
        return Colors.blue;
      case NotificationType.academic:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
      case NotificationType.alert:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.academic:
        return Icons.school;
      case NotificationType.system:
        return Icons.computer;
      case NotificationType.alert:
        return Icons.warning;
    }
  }
}
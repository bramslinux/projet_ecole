import 'package:flutter/material.dart';

class ImportationPage extends StatefulWidget {
  const ImportationPage({super.key});

  @override
  State<ImportationPage> createState() => _ImportationPageState();
}

class _ImportationPageState extends State<ImportationPage> {
  final List<ImportFile> _importedFiles = [];
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importation de fichiers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showImportHistory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Instructions Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instructions d\'importation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Formats supportés : Excel (.xlsx, .xls), CSV (.csv)',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Taille maximale : 10 MB',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Import Options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildImportOption(
                    title: 'Élèves',
                    icon: Icons.people,
                    onTap: () => _importFile('students'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImportOption(
                    title: 'Notes',
                    icon: Icons.grade,
                    onTap: () => _importFile('grades'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImportOption(
                    title: 'Enseignants',
                    icon: Icons.school,
                    onTap: () => _importFile('teachers'),
                  ),
                ),
              ],
            ),
          ),

          // Recent Imports
          Expanded(
            child: _importedFiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun fichier importé',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _importedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _importedFiles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Icon(
                            file.type.icon,
                            color: file.status.color,
                          ),
                          title: Text(file.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Type: ${file.type.name}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Importé le ${_formatDate(file.date)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                file.status.message,
                                style: TextStyle(
                                  color: file.status.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  _showFileOptions(file);
                                },
                              ),
                            ],
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

  Widget _buildImportOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _importFile(String type) async {
    setState(() {
      _isImporting = true;
    });

    try {
      // TODO: Implement actual file import
      await Future.delayed(const Duration(seconds: 2)); // Simulate import

      setState(() {
        _importedFiles.insert(
          0,
          ImportFile(
            name: 'import_${DateTime.now().millisecondsSinceEpoch}.xlsx',
            type: ImportType.values.firstWhere(
              (t) => t.name == type,
            ),
            date: DateTime.now(),
            status: ImportStatus.success,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'importation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

  void _showImportHistory() {
    // TODO: Implement import history dialog
  }

  void _showFileOptions(ImportFile file) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Voir les détails'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Show file details
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Supprimer'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              Navigator.pop(context);
              _deleteFile(file);
            },
          ),
        ],
      ),
    );
  }

  void _deleteFile(ImportFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer le fichier ${file.name} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _importedFiles.remove(file);
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}';
  }
}

class ImportFile {
  final String name;
  final ImportType type;
  final DateTime date;
  final ImportStatus status;

  ImportFile({
    required this.name,
    required this.type,
    required this.date,
    required this.status,
  });
}

enum ImportType {
  students,
  grades,
  teachers,
}

extension ImportTypeExtension on ImportType {
  String get name {
    switch (this) {
      case ImportType.students:
        return 'Élèves';
      case ImportType.grades:
        return 'Notes';
      case ImportType.teachers:
        return 'Enseignants';
    }
  }

  IconData get icon {
    switch (this) {
      case ImportType.students:
        return Icons.people;
      case ImportType.grades:
        return Icons.grade;
      case ImportType.teachers:
        return Icons.school;
    }
  }
}

enum ImportStatus {
  success,
  error,
  pending,
}

extension ImportStatusExtension on ImportStatus {
  String get message {
    switch (this) {
      case ImportStatus.success:
        return 'Succès';
      case ImportStatus.error:
        return 'Erreur';
      case ImportStatus.pending:
        return 'En cours';
    }
  }

  Color get color {
    switch (this) {
      case ImportStatus.success:
        return Colors.green;
      case ImportStatus.error:
        return Colors.red;
      case ImportStatus.pending:
        return Colors.orange;
    }
  }
}
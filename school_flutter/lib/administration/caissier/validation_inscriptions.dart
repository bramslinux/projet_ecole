import 'package:flutter/material.dart';

class ValidationInscriptionsPage extends StatefulWidget {
  const ValidationInscriptionsPage({super.key});

  @override
  State<ValidationInscriptionsPage> createState() => _ValidationInscriptionsPageState();
}

class _ValidationInscriptionsPageState extends State<ValidationInscriptionsPage> {
  List<Map<String, dynamic>> _inscriptionsEnAttente = [
    {
      'id': '1',
      'nom': 'Jean Dupont',
      'classe': '6ème A',
      'dateInscription': '2024-09-01',
      'montant': 150000,
    },
    {
      'id': '2',
      'nom': 'Marie Martin',
      'classe': '5ème B',
      'dateInscription': '2024-09-02',
      'montant': 150000,
    },
    // Add more example data
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation des Inscriptions'),
      ),
      body: Column(
        children: [
          // Statistics Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('En attente', _inscriptionsEnAttente.length.toString(), Colors.orange),
                  _buildStatItem('Validées aujourd\'hui', '5', Colors.green),
                  _buildStatItem('Montant total', '750,000 FCFA', Colors.blue),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un élève...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // TODO: Implement search functionality
              },
            ),
          ),

          // List of pending inscriptions
          Expanded(
            child: ListView.builder(
              itemCount: _inscriptionsEnAttente.length,
              itemBuilder: (context, index) {
                final inscription = _inscriptionsEnAttente[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(inscription['nom']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Classe: ${inscription['classe']}'),
                        Text('Date: ${inscription['dateInscription']}'),
                        Text('Montant: ${inscription['montant']} FCFA'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline),
                          color: Colors.green,
                          onPressed: () => _showValidationDialog(inscription),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          color: Colors.red,
                          onPressed: () => _showRejectionDialog(inscription),
                        ),
                      ],
                    ),
                    onTap: () => _showInscriptionDetails(inscription),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Generate report or export data
        },
        child: const Icon(Icons.file_download),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _showValidationDialog(Map<String, dynamic> inscription) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider l\'inscription'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Confirmer la validation de l\'inscription de ${inscription['nom']} ?'),
              const SizedBox(height: 16),
              Text('Montant reçu: ${inscription['montant']} FCFA'),
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
              // TODO: Implement validation logic
              setState(() {
                _inscriptionsEnAttente.remove(inscription);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Inscription de ${inscription['nom']} validée'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRejectionDialog(Map<String, dynamic> inscription) async {
    final _motifController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rejeter l\'inscription'),
        content: TextField(
          controller: _motifController,
          decoration: const InputDecoration(
            labelText: 'Motif du rejet',
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
              if (_motifController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez entrer un motif'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              // TODO: Implement rejection logic
              setState(() {
                _inscriptionsEnAttente.remove(inscription);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Inscription de ${inscription['nom']} rejetée'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Rejeter'),
          ),
        ],
      ),
    );
  }

  void _showInscriptionDetails(Map<String, dynamic> inscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(inscription['nom']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${inscription['id']}'),
            const SizedBox(height: 8),
            Text('Classe: ${inscription['classe']}'),
            const SizedBox(height: 8),
            Text('Date d\'inscription: ${inscription['dateInscription']}'),
            const SizedBox(height: 8),
            Text('Montant: ${inscription['montant']} FCFA'),
            const SizedBox(height: 16),
            const Text('Documents fournis:'),
            const SizedBox(height: 8),
            _buildDocumentList(),
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

  Widget _buildDocumentList() {
    final documents = [
      'Extrait de naissance',
      'Photo d\'identité',
      'Certificat médical',
      'Derniers bulletins',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.map((doc) => Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(doc),
        ],
      )).toList(),
    );
  }
}

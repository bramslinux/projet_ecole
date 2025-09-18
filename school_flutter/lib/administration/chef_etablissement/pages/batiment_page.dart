import 'package:flutter/material.dart';

class BatimentPage extends StatefulWidget {
  const BatimentPage({super.key});

  @override
  State<BatimentPage> createState() => _BatimentPageState();
}

class _BatimentPageState extends State<BatimentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Map<String, String>> batiments = [
    {'nom': 'Bâtiment A', 'description': 'Bloc administratif'},
    {'nom': 'Bâtiment B', 'description': 'Salles de cours'},
    {'nom': 'Bâtiment C', 'description': 'Laboratoires'},
  ];

  void _ajouterBatiment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        batiments.add({
          'nom': _nomController.text,
          'description': _descriptionController.text,
        });
      });
      _nomController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  void _supprimerBatiment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer le bâtiment ${batiments[index]['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                batiments.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bâtiment supprimé avec succès'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _modifierBatiment(int index) {
    _nomController.text = batiments[index]['nom']!;
    _descriptionController.text = batiments[index]['description']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le bâtiment'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom du bâtiment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
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
                setState(() {
                  batiments[index] = {
                    'nom': _nomController.text,
                    'description': _descriptionController.text,
                  };
                });
                _nomController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Bâtiments'),
        backgroundColor: const Color.fromARGB(255, 46, 103, 125),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nomController.clear();
          _descriptionController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter un bâtiment'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom du bâtiment'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
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
                  onPressed: _ajouterBatiment,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 67, 96, 160),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: batiments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.business, color: Color.fromARGB(255, 76, 155, 175)),
              title: Text(batiments[index]['nom']!),
              subtitle: Text(batiments[index]['description']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 76, 135, 175)),
                    onPressed: () => _modifierBatiment(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerBatiment(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

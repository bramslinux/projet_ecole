import 'package:flutter/material.dart';

class ClassePage extends StatefulWidget {
  const ClassePage({super.key});

  @override
  State<ClassePage> createState() => _ClassePageState();
}

class _ClassePageState extends State<ClassePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _effectifController = TextEditingController();
  String? _niveauSelectionne;

  final List<String> niveaux = ['6ème', '5ème', '4ème', '3ème', '2nde', '1ère', 'Terminale'];

  List<Map<String, dynamic>> classes = [
    {'nom': '6ème A', 'niveau': '6ème', 'effectif': '30'},
    {'nom': '6ème B', 'niveau': '6ème', 'effectif': '28'},
    {'nom': '5ème A', 'niveau': '5ème', 'effectif': '32'},
  ];

  void _ajouterClasse() {
    if (_formKey.currentState!.validate() && _niveauSelectionne != null) {
      setState(() {
        classes.add({
          'nom': _nomController.text,
          'niveau': _niveauSelectionne,
          'effectif': _effectifController.text,
        });
      });
      _nomController.clear();
      _effectifController.clear();
      _niveauSelectionne = null;
      Navigator.pop(context);
    }
  }

  void _supprimerClasse(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer la classe ${classes[index]['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                classes.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Classe supprimée avec succès'),
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

  void _modifierClasse(int index) {
    _nomController.text = classes[index]['nom'];
    _effectifController.text = classes[index]['effectif'];
    _niveauSelectionne = classes[index]['niveau'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la classe'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom de la classe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _niveauSelectionne,
                decoration: const InputDecoration(labelText: 'Niveau'),
                items: niveaux.map((niveau) {
                  return DropdownMenuItem(
                    value: niveau,
                    child: Text(niveau),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _niveauSelectionne = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un niveau';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _effectifController,
                decoration: const InputDecoration(labelText: 'Effectif maximum'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un effectif';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
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
                  classes[index] = {
                    'nom': _nomController.text,
                    'niveau': _niveauSelectionne,
                    'effectif': _effectifController.text,
                  };
                });
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
        title: const Text('Gestion des Classes'),
        backgroundColor: const Color.fromARGB(255, 46, 93, 125),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nomController.clear();
          _effectifController.clear();
          _niveauSelectionne = null;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter une classe'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom de la classe'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _niveauSelectionne,
                      decoration: const InputDecoration(labelText: 'Niveau'),
                      items: niveaux.map((niveau) {
                        return DropdownMenuItem(
                          value: niveau,
                          child: Text(niveau),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _niveauSelectionne = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un niveau';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _effectifController,
                      decoration: const InputDecoration(labelText: 'Effectif maximum'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un effectif';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
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
                  onPressed: _ajouterClasse,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 67, 115, 160),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.class_, color: Color.fromARGB(255, 76, 155, 175)),
              title: Text(classes[index]['nom']),
              subtitle: Text('Niveau: ${classes[index]['niveau']} - Effectif max: ${classes[index]['effectif']} élèves'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 76, 139, 175)),
                    onPressed: () => _modifierClasse(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerClasse(index),
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

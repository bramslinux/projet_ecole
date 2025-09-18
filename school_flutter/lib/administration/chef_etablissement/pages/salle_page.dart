import 'package:flutter/material.dart';

class SallePage extends StatefulWidget {
  const SallePage({super.key});

  @override
  State<SallePage> createState() => _SallePageState();
}

class _SallePageState extends State<SallePage> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  final _capaciteController = TextEditingController();
  String? _batimentSelectionne;
  String? _typeSelectionne;

  final List<String> batiments = ['Bâtiment A', 'Bâtiment B', 'Bâtiment C'];
  final List<String> typeSalles = ['Salle de cours', 'Laboratoire', 'Amphithéâtre', 'Salle de réunion'];

  List<Map<String, dynamic>> salles = [
    {'numero': '101', 'batiment': 'Bâtiment A', 'type': 'Salle de cours', 'capacite': '30'},
    {'numero': '102', 'batiment': 'Bâtiment A', 'type': 'Laboratoire', 'capacite': '20'},
    {'numero': '201', 'batiment': 'Bâtiment B', 'type': 'Amphithéâtre', 'capacite': '100'},
  ];

  void _ajouterSalle() {
    if (_formKey.currentState!.validate() && _batimentSelectionne != null && _typeSelectionne != null) {
      setState(() {
        salles.add({
          'numero': _numeroController.text,
          'batiment': _batimentSelectionne,
          'type': _typeSelectionne,
          'capacite': _capaciteController.text,
        });
      });
      _numeroController.clear();
      _capaciteController.clear();
      _batimentSelectionne = null;
      _typeSelectionne = null;
      Navigator.pop(context);
    }
  }

  void _supprimerSalle(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer la salle ${salles[index]['numero']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                salles.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Salle supprimée avec succès'),
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

  void _modifierSalle(int index) {
    _numeroController.text = salles[index]['numero'];
    _capaciteController.text = salles[index]['capacite'];
    _batimentSelectionne = salles[index]['batiment'];
    _typeSelectionne = salles[index]['type'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la salle'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Numéro de salle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _batimentSelectionne,
                decoration: const InputDecoration(labelText: 'Bâtiment'),
                items: batiments.map((batiment) {
                  return DropdownMenuItem(
                    value: batiment,
                    child: Text(batiment),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _batimentSelectionne = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un bâtiment';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _typeSelectionne,
                decoration: const InputDecoration(labelText: 'Type de salle'),
                items: typeSalles.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _typeSelectionne = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _capaciteController,
                decoration: const InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une capacité';
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
                  salles[index] = {
                    'numero': _numeroController.text,
                    'batiment': _batimentSelectionne,
                    'type': _typeSelectionne,
                    'capacite': _capaciteController.text,
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
        title: const Text('Gestion des Salles'),
        backgroundColor: const Color.fromARGB(255, 46, 93, 125),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _numeroController.clear();
          _capaciteController.clear();
          _batimentSelectionne = null;
          _typeSelectionne = null;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter une salle'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _numeroController,
                      decoration: const InputDecoration(labelText: 'Numéro de salle'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un numéro';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _batimentSelectionne,
                      decoration: const InputDecoration(labelText: 'Bâtiment'),
                      items: batiments.map((batiment) {
                        return DropdownMenuItem(
                          value: batiment,
                          child: Text(batiment),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _batimentSelectionne = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un bâtiment';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _typeSelectionne,
                      decoration: const InputDecoration(labelText: 'Type de salle'),
                      items: typeSalles.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeSelectionne = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un type';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _capaciteController,
                      decoration: const InputDecoration(labelText: 'Capacité'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une capacité';
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
                  onPressed: _ajouterSalle,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 67, 130, 160),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: salles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.meeting_room, color: Color.fromARGB(255, 76, 152, 175)),
              title: Text('${salles[index]['numero']} - ${salles[index]['batiment']}'),
              subtitle: Text('${salles[index]['type']} - Capacité: ${salles[index]['capacite']} places'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 76, 139, 175)),
                    onPressed: () => _modifierSalle(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerSalle(index),
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

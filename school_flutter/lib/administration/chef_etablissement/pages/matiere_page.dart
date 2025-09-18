import 'package:flutter/material.dart';
import 'package:school_flutter/services/matiere_service.dart';

class MatierePage extends StatefulWidget {
  const MatierePage({super.key});

  @override
  State<MatierePage> createState() => _MatierePageState();
}

class _MatierePageState extends State<MatierePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _coefficientController = TextEditingController();
  String? _niveauSelectionne;

  final List<String> niveaux = ['6ème', '5ème', '4ème', '3ème', '2nde', '1ère', 'Terminale'];

  List<Map<String, dynamic>> matieres = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerMatieres();
  }

  Future<void> _chargerMatieres() async {
    try {
      setState(() => _isLoading = true);
      final List<Map<String, dynamic>> result = await MatiereService.getAllMatieres();
      setState(() {
        matieres = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des matières: $e')),
      );
    }
  }

  Future<void> _ajouterMatiere() async {
    if (_formKey.currentState!.validate() && _niveauSelectionne != null) {
      try {
        final nouvelleMatiere = {
          'nom': _nomController.text,
          'niveau': _niveauSelectionne,
          'coefficient': int.parse(_coefficientController.text),
        };

        await MatiereService.createMatiere(nouvelleMatiere);
        _chargerMatieres(); // Recharger la liste
        _nomController.clear();
        _coefficientController.clear();
        _niveauSelectionne = null;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Matière ajoutée avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout: $e')),
        );
      }
    }
  }

  Future<void> _supprimerMatiere(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer la matière ${matieres[index]['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await MatiereService.deleteMatiere(matieres[index]['id']);
                Navigator.pop(context);
                _chargerMatieres(); // Recharger la liste
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Matière supprimée avec succès'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la suppression: $e')),
                );
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _modifierMatiere(int index) async {
    _nomController.text = matieres[index]['nom'];
    _coefficientController.text = matieres[index]['coefficient'].toString();
    _niveauSelectionne = matieres[index]['niveau'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la matière'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom de la matière'),
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
                controller: _coefficientController,
                decoration: const InputDecoration(labelText: 'Coefficient'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un coefficient';
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
                  matieres[index] = {
                    'nom': _nomController.text,
                    'niveau': _niveauSelectionne,
                    'coefficient': _coefficientController.text,
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
        title: const Text('Gestion des Matières'),
        backgroundColor: const Color.fromARGB(255, 46, 103, 125),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nomController.clear();
          _coefficientController.clear();
          _niveauSelectionne = null;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter une matière'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom de la matière'),
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
                      controller: _coefficientController,
                      decoration: const InputDecoration(labelText: 'Coefficient'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un coefficient';
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
                  onPressed: _ajouterMatiere,
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 67, 138, 160),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: matieres.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.subject, color: Color.fromARGB(255, 76, 139, 175)),
              title: Text(matieres[index]['nom']),
              subtitle: Text('Niveau: ${matieres[index]['niveau']} - Coefficient: ${matieres[index]['coefficient']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 76, 160, 175)),
                    onPressed: () => _modifierMatiere(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerMatiere(index),
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

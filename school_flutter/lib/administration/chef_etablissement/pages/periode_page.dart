import 'package:flutter/material.dart';

class PeriodePage extends StatefulWidget {
  const PeriodePage({super.key});

  @override
  State<PeriodePage> createState() => _PeriodePageState();
}

class _PeriodePageState extends State<PeriodePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _dateDebutController = TextEditingController();
  final _dateFinController = TextEditingController();

  List<Map<String, String>> periodes = [
    {
      'nom': 'Premier Trimestre',
      'debut': '01/09/2025',
      'fin': '30/11/2025'
    },
    {
      'nom': 'Deuxième Trimestre',
      'debut': '01/12/2025',
      'fin': '28/02/2026'
    },
    {
      'nom': 'Troisième Trimestre',
      'debut': '01/03/2026',
      'fin': '30/06/2026'
    },
  ];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _ajouterPeriode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        periodes.add({
          'nom': _nomController.text,
          'debut': _dateDebutController.text,
          'fin': _dateFinController.text,
        });
      });
      _nomController.clear();
      _dateDebutController.clear();
      _dateFinController.clear();
      Navigator.pop(context);
    }
  }

  void _supprimerPeriode(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer la période ${periodes[index]['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                periodes.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Période supprimée avec succès'),
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

  void _modifierPeriode(int index) {
    _nomController.text = periodes[index]['nom']!;
    _dateDebutController.text = periodes[index]['debut']!;
    _dateFinController.text = periodes[index]['fin']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la période'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom de la période'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateDebutController,
                decoration: const InputDecoration(
                  labelText: 'Date de début',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _dateDebutController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date de début';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateFinController,
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _dateFinController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une date de fin';
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
                  periodes[index] = {
                    'nom': _nomController.text,
                    'debut': _dateDebutController.text,
                    'fin': _dateFinController.text,
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
        title: const Text('Gestion des Périodes'),
        backgroundColor: const Color.fromARGB(255, 46, 96, 125),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nomController.clear();
          _dateDebutController.clear();
          _dateFinController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ajouter une période'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom de la période'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dateDebutController,
                      decoration: const InputDecoration(
                        labelText: 'Date de début',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _dateDebutController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une date de début';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dateFinController,
                      decoration: const InputDecoration(
                        labelText: 'Date de fin',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _dateFinController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez sélectionner une date de fin';
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
                  onPressed: _ajouterPeriode,
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
        itemCount: periodes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 76, 139, 175)),
              title: Text(periodes[index]['nom']!),
              subtitle: Text('Du ${periodes[index]['debut']} au ${periodes[index]['fin']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 76, 119, 175)),
                    onPressed: () => _modifierPeriode(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerPeriode(index),
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

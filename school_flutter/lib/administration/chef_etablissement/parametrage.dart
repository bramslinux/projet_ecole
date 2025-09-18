import 'package:flutter/material.dart';

class ParametragesPage extends StatefulWidget {
  const ParametragesPage({super.key});

  @override
  State<ParametragesPage> createState() => _ParametragesPageState();
}

class _ParametragesPageState extends State<ParametragesPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  final _periodeController = TextEditingController();
  final _classeController = TextEditingController();
  final _matiereController = TextEditingController();
  final _patrimoineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres de l\'établissement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patrimoine section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patrimoine',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _patrimoineController,
                        decoration: const InputDecoration(
                          labelText: 'Ajouter un élément au patrimoine',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement patrimoine addition
                        },
                        child: const Text('Ajouter au patrimoine'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Périodes scolaires section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Périodes scolaires',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _periodeController,
                        decoration: const InputDecoration(
                          labelText: 'Configurer une période scolaire',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer une période';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement period configuration
                        },
                        child: const Text('Ajouter une période'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Classes et matières section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Classes et Matières',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _classeController,
                        decoration: const InputDecoration(
                          labelText: 'Ajouter une classe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _matiereController,
                        decoration: const InputDecoration(
                          labelText: 'Ajouter une matière',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement class addition
                            },
                            child: const Text('Ajouter une classe'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement subject addition
                            },
                            child: const Text('Ajouter une matière'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _periodeController.dispose();
    _classeController.dispose();
    _matiereController.dispose();
    _patrimoineController.dispose();
    super.dispose();
  }
}
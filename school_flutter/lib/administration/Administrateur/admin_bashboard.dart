import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AdministrateurDashboard extends StatefulWidget {
  const AdministrateurDashboard({super.key});

  @override
  State<AdministrateurDashboard> createState() => _AdministrateurDashboardState();
}

class _AdministrateurDashboardState extends State<AdministrateurDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _villeController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _logoImage;

  final List<String> _tabs = ["Accueil", "Enregistrer", "Liste", "Statistiques"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_tabController.index]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Center(
                child: Text(
                  "Dashboard Administrateur",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            for (int i = 0; i < _tabs.length; i++)
              ListTile(
                leading: _getIconForTab(i),
                title: Text(_tabs[i]),
                selected: _tabController.index == i,
                onTap: () {
                  Navigator.pop(context); // fermer le Drawer
                  setState(() {
                    _tabController.index = i;
                  });
                },
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // pour éviter swipe
        children: [
          _buildAccueil(),
          _buildEnregistrer(),
          _buildListe(),
          _buildStatistiques(),
        ],
      ),
    );
  }

  Icon _getIconForTab(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.add_box);
      case 2:
        return const Icon(Icons.list);
      case 3:
        return const Icon(Icons.bar_chart);
      default:
        return const Icon(Icons.dashboard);
    }
  }

  // --- Widgets des onglets (inchangés sauf le nécessaire) ---
  Widget _buildAccueil() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.dashboard, size: 100, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'Bienvenue sur le Dashboard Administrateur',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Gérez les établissements scolaires efficacement.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnregistrer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Enregistrer un nouvel établissement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'établissement',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _villeController,
                decoration: const InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Ce champ est obligatoire';
                  if (!value.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Logo de l\'établissement',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _logoImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Sélectionner un logo'),
                            ],
                          ),
                        )
                      : Image.file(_logoImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _enregistrer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListe() {
    final List<Map<String, String>> establishments = [
      {'nom': 'École A', 'ville': 'Ouagadougou', 'code': '123456'},
      {'nom': 'École B', 'ville': 'Bobo-Dioulasso', 'code': '654321'},
      {'nom': 'École C', 'ville': 'Koudougou', 'code': '112233'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: establishments.length,
      itemBuilder: (context, index) {
        final etab = establishments[index];
        return Card(
          child: ListTile(
            title: Text(etab['nom']!),
            subtitle: Text('Ville: ${etab['ville']}\nCode: ${etab['code']}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Édition de ${etab['nom']}')),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistiques() {
    return const Center(
      child: Text("Ici s'afficheront les statistiques"),
    );
  }

  void _enregistrer() {
    bool isValid = _formKey.currentState!.validate();
    if (_logoImage == null) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un logo')),
      );
    }
    if (isValid) {
      final random = Random();
      final code = (random.nextInt(900000) + 100000).toString();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succès'),
          content: Text('Établissement enregistré avec succès.\nCode: $code'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nomController.clear();
                _adresseController.clear();
                _villeController.clear();
                _telephoneController.clear();
                _emailController.clear();
                setState(() => _logoImage = null);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';

class PedagogiePage extends StatefulWidget {
  const PedagogiePage({super.key});

  @override
  State<PedagogiePage> createState() => _PedagogiePageState();
}

class _PedagogiePageState extends State<PedagogiePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion Pédagogique'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Programmes'),
            Tab(text: 'Évaluations'),
            Tab(text: 'Emplois du temps'),
            Tab(text: 'Ressources'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProgrammesTab(),
          _buildEvaluationsTab(),
          _buildEmploisTempsTab(),
          _buildRessourcesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgrammesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un programme...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // TODO: Replace with actual data
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.book),
                  ),
                  title: Text('Programme ${index + 1}'),
                  subtitle: Text('Classe ${index + 1}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Objectifs pédagogiques :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Description des objectifs du programme ${index + 1}',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('Modifier'),
                                onPressed: () {
                                  // TODO: Implement edit
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Supprimer'),
                                onPressed: () {
                                  // TODO: Implement delete
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to evaluation details
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getEvaluationIcon(index),
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getEvaluationType(index),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmploisTempsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Classe',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Classe 1', 'Classe 2', 'Classe 3']
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // TODO: Handle class selection
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Semaine',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Semaine 1', 'Semaine 2', 'Semaine 3']
                      .map((w) => DropdownMenuItem(
                            value: w,
                            child: Text(w),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // TODO: Handle week selection
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Horaire')),
                DataColumn(label: Text('Lundi')),
                DataColumn(label: Text('Mardi')),
                DataColumn(label: Text('Mercredi')),
                DataColumn(label: Text('Jeudi')),
                DataColumn(label: Text('Vendredi')),
              ],
              rows: List.generate(
                8,
                (index) => DataRow(
                  cells: [
                    DataCell(Text('${8 + index}:00')),
                    ...List.generate(
                      5,
                      (dayIndex) => DataCell(
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blue[50],
                          child: Text('Cours ${index + 1}'),
                        ),
                        onTap: () {
                          // TODO: Show course details
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRessourcesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(
              _getResourceIcon(index),
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Ressource ${index + 1}'),
            subtitle: Text(_getResourceType(index)),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // TODO: Implement download
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter ${_getDialogTitle()}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: const OutlineInputBorder(),
                  hintText: 'Entrez le titre ${_getDialogTitle().toLowerCase()}',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                  hintText:
                      'Entrez la description ${_getDialogTitle().toLowerCase()}',
                ),
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
              // TODO: Implement add item
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  String _getDialogTitle() {
    switch (_tabController.index) {
      case 0:
        return 'Programme';
      case 1:
        return 'Évaluation';
      case 2:
        return 'Cours';
      case 3:
        return 'Ressource';
      default:
        return '';
    }
  }

  IconData _getEvaluationIcon(int index) {
    switch (index) {
      case 0:
        return Icons.assignment;
      case 1:
        return Icons.quiz;
      case 2:
        return Icons.fact_check;
      case 3:
        return Icons.rate_review;
      case 4:
        return Icons.psychology;
      default:
        return Icons.assessment;
    }
  }

  String _getEvaluationType(int index) {
    switch (index) {
      case 0:
        return 'Examens';
      case 1:
        return 'Quiz';
      case 2:
        return 'Contrôles continus';
      case 3:
        return 'Évaluations pratiques';
      case 4:
        return 'Tests de compétences';
      default:
        return 'Autres évaluations';
    }
  }

  IconData _getResourceIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.picture_as_pdf;
      case 1:
        return Icons.video_library;
      case 2:
        return Icons.library_books;
      default:
        return Icons.link;
    }
  }

  String _getResourceType(int index) {
    switch (index % 4) {
      case 0:
        return 'Document PDF';
      case 1:
        return 'Vidéo pédagogique';
      case 2:
        return 'Support de cours';
      default:
        return 'Lien externe';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
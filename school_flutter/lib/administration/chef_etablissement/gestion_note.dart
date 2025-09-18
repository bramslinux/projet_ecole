import 'package:flutter/material.dart';

// Modèle de données pour une note
class Note {
  final String id;
  final String studentId;
  final String studentName;
  final String subject;
  final String teacherId;
  final String teacherName;
  final double value;
  final double maxValue;
  final String type; // "Devoir", "Contrôle", "Examen", etc.
  final DateTime date;
  final String? comment;
  final String className;
  Note({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.value,
    required this.maxValue,
    required this.type,
    required this.date,
    this.comment,
    required this.className,
  });
  double get percentage => (value / maxValue) * 100;
}

// Modèle pour les statistiques
class SubjectStatistics {
  final String subject;
  final double average;
  final int totalNotes;
  final double minNote;
  final double maxNote;
  SubjectStatistics({
    required this.subject,
    required this.average,
    required this.totalNotes,
    required this.minNote,
    required this.maxNote,
  });
}

/// ----------------------
/// 6. Gestion des Notes - Chef d'Établissement
/// ----------------------
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  int _selectedDrawerIndex = 0;
  String _selectedClass = 'Toutes les classes';
  String _selectedSubject = 'Toutes les matières';

  // Données fictives pour la démonstration
  final List<String> _classes = [
    'Toutes les classes',
    '6ème A',
    '6ème B',
    '5ème A',
    '5ème B',
    '4ème A',
    '4ème B',
    '3ème A',
    '3ème B'
  ];
  final List<String> _subjects = [
    'Toutes les matières',
    'Mathématiques',
    'Français',
    'Anglais',
    'Histoire-Géographie',
    'Sciences Physiques',
    'SVT',
    'Technologie',
    'Arts Plastiques',
    'Éducation Musicale',
    'EPS'
  ];

  // Notes fictives étendues
  final List<Note> _allNotes = [
    Note(
      id: '1',
      studentId: 'STU001',
      studentName: 'Martin Dubois',
      subject: 'Mathématiques',
      teacherId: 'TCH001',
      teacherName: 'Mme Lambert',
      value: 15.5,
      maxValue: 20,
      type: 'Contrôle',
      date: DateTime.now().subtract(const Duration(days: 5)),
      comment: 'Bon travail, continue ainsi',
      className: '6ème A',
    ),
    Note(
      id: '2',
      studentId: 'STU002',
      studentName: 'Sophie Martin',
      subject: 'Français',
      teacherId: 'TCH002',
      teacherName: 'M. Durand',
      value: 12,
      maxValue: 20,
      type: 'Devoir',
      date: DateTime.now().subtract(const Duration(days: 3)),
      className: '6ème A',
    ),
    Note(
      id: '3',
      studentId: 'STU003',
      studentName: 'Lucas Bernard',
      subject: 'Anglais',
      teacherId: 'TCH003',
      teacherName: 'Miss Johnson',
      value: 16,
      maxValue: 20,
      type: 'Oral',
      date: DateTime.now().subtract(const Duration(days: 7)),
      comment: 'Excellente participation',
      className: '5ème A',
    ),
    Note(
      id: '4',
      studentId: 'STU004',
      studentName: 'Emma Petit',
      subject: 'Histoire-Géographie',
      teacherId: 'TCH004',
      teacherName: 'M. Lefebvre',
      value: 13.5,
      maxValue: 20,
      type: 'Examen',
      date: DateTime.now().subtract(const Duration(days: 2)),
      className: '4ème A',
    ),
    Note(
      id: '5',
      studentId: 'STU005',
      studentName: 'Thomas Moreau',
      subject: 'Sciences Physiques',
      teacherId: 'TCH005',
      teacherName: 'Dr. Rousseau',
      value: 18,
      maxValue: 20,
      type: 'TP',
      date: DateTime.now().subtract(const Duration(days: 1)),
      comment: 'Manipulation excellente',
      className: '3ème A',
    ),
    Note(
      id: '6',
      studentId: 'STU006',
      studentName: 'Léa Bonnet',
      subject: 'SVT',
      teacherId: 'TCH006',
      teacherName: 'Mme Blanc',
      value: 14,
      maxValue: 20,
      type: 'Contrôle',
      date: DateTime.now().subtract(const Duration(days: 4)),
      className: '5ème B',
    ),
  ];
  List<Note> get _filteredNotes {
    return _allNotes.where((note) {
      bool classMatch = _selectedClass == 'Toutes les classes' ||
          note.className == _selectedClass;
      bool subjectMatch = _selectedSubject == 'Toutes les matières' ||
          note.subject == _selectedSubject;
      return classMatch && subjectMatch;
    }).toList();
  }
  List<Map<String, dynamic>> get _studentsWithNotes {
    Map<String, Map<String, dynamic>> map = {};
    for (var note in _filteredNotes) {
      map.putIfAbsent(note.studentId, () => {
            'name': note.studentName,
            'notes': <Note>[],
          });
      map[note.studentId]!['notes'].add(note);
    }
    var students = map.entries.map((e) {
      var notes = e.value['notes'] as List<Note>;
      var normalized = notes.map((n) => n.value / n.maxValue * 20).toList();
      double average = notes.isEmpty
          ? 0
          : normalized.reduce((a, b) => a + b) / notes.length;
      return {
        'id': e.key,
        'name': e.value['name'],
        'notes': notes,
        'average': average,
      };
    }).toList();
    students.sort((a, b) => a['name'].compareTo(b['name']));
    return students;
  }
  List<SubjectStatistics> get _subjectStatistics {
    Map<String, List<Note>> notesBySubject = {};
    for (var note in _filteredNotes) {
      notesBySubject.putIfAbsent(note.subject, () => []).add(note);
    }
    return notesBySubject.entries.map((entry) {
      var notes = entry.value;
      var normalized = notes.map((n) => n.value / n.maxValue * 20).toList();
      return SubjectStatistics(
        subject: entry.key,
        average: normalized.isNotEmpty
            ? normalized.reduce((a, b) => a + b) / normalized.length
            : 0,
        totalNotes: notes.length,
        minNote: normalized.isNotEmpty ? normalized.reduce((a, b) => a < b ? a : b) : 0,
        maxNote: normalized.isNotEmpty ? normalized.reduce((a, b) => a > b ? a : b) : 0,
      );
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 800;
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: isWide
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Builder(
                builder: (BuildContext innerContext) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(innerContext).openDrawer(),
                  );
                },
              ),
        actions: [
          if (!isWide)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Données actualisées'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      drawer: isWide ? null : Drawer(child: _buildNavigation(true)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isWide) {
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: _buildNavigation(false),
                ),
                Expanded(
                  child: Column(
                    children: [
                      if (_selectedDrawerIndex != 2) buildFilters(context),
                      Expanded(child: SingleChildScrollView(child: _buildCurrentPage())),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                if (_selectedDrawerIndex != 2) buildFilters(context),
                Expanded(child: SingleChildScrollView(child: _buildCurrentPage())),
              ],
            );
          }
        },
      ),
      floatingActionButton: _selectedDrawerIndex == 3
          ? FloatingActionButton.extended(
              onPressed: () => _showExportDialog(),
              icon: const Icon(Icons.file_download),
              label: const Text('Exporter'),
              backgroundColor: Colors.indigo.shade700,
            )
          : null,
    );
  }
  String _getPageTitle() {
    switch (_selectedDrawerIndex) {
      case 0:
        return 'Tableau de Bord';
      case 1:
        return 'Notes par Classe';
      case 2:
        return 'Statistiques';
      case 3:
        return 'Rapports';
      case 4:
        return 'Alertes';
      default:
        return 'Gestion des Notes';
    }
  }
  Widget _buildNavigation(bool isTemporary) {
    return Column(
      children: [
        // Header du Drawer
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo.shade800,
                Colors.indigo.shade600,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chef d\'Établissement',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Lycée Jean Moulin',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Année 2024-2025',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Menu Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerItem(
                index: 0,
                icon: Icons.dashboard,
                title: 'Tableau de Bord',
                subtitle: 'Vue d\'ensemble',
                isTemporary: isTemporary,
              ),
              _buildDrawerItem(
                index: 1,
                icon: Icons.class_,
                title: 'Notes par Classe',
                subtitle: 'Détail par classe',
                isTemporary: isTemporary,
              ),
              _buildDrawerItem(
                index: 2,
                icon: Icons.analytics,
                title: 'Statistiques',
                subtitle: 'Analyses détaillées',
                isTemporary: isTemporary,
              ),
              _buildDrawerItem(
                index: 3,
                icon: Icons.assessment,
                title: 'Rapports',
                subtitle: 'Documents officiels',
                isTemporary: isTemporary,
              ),
              _buildDrawerItem(
                index: 4,
                icon: Icons.warning,
                title: 'Alertes',
                subtitle: 'Situations à surveiller',
                isTemporary: isTemporary,
              ),
              const Divider(height: 20),
              // Actions secondaires
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.grey.shade600),
                title: const Text('Aide'),
                onTap: () {
                  if (isTemporary) {
                    Navigator.pop(context);
                  }
                  _showHelpDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.grey.shade600),
                title: const Text('À propos'),
                onTap: () {
                  if (isTemporary) {
                    Navigator.pop(context);
                  }
                  _showAboutDialog();
                },
              ),
            ],
          ),
        ),
        // Footer du Drawer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Dernière MAJ: ${_formatDate(DateTime.now())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildDrawerItem({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isTemporary,
  }) {
    bool isSelected = _selectedDrawerIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.indigo.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.indigo.shade200)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.indigo.shade700 : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.indigo.shade800 : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected ? Colors.indigo.shade600 : Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.indigo.shade700)
            : null,
        onTap: () {
          setState(() {
            _selectedDrawerIndex = index;
          });
          if (isTemporary) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
  Widget buildFilters(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    if (isSmallScreen) {
      // 📱 Petit écran → affichage vertical (chaque dropdown prend toute la largeur)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Classe"),
            value: _selectedClass,
            items: _classes.map((classe) => DropdownMenuItem(
              value: classe,
              child: Text(classe),
            )).toList(),
            onChanged: (val) => setState(() => _selectedClass = val!),
          ),
          const SizedBox(height: 12), // espace entre les champs
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Matière"),
            value: _selectedSubject,
            items: _subjects.map((subject) => DropdownMenuItem(
              value: subject,
              child: Text(subject),
            )).toList(),
            onChanged: (val) => setState(() => _selectedSubject = val!),
          ),
        ],
      );
    }
    // 🖥️ Grand écran → affichage horizontal
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Classe"),
            value: _selectedClass,
            items: _classes.map((classe) => DropdownMenuItem(
              value: classe,
              child: Text(classe),
            )).toList(),
            onChanged: (val) => setState(() => _selectedClass = val!),
          ),
        ),
        const SizedBox(width: 16), // espace entre les dropdowns
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Matière"),
            value: _selectedSubject,
            items: _subjects.map((subject) => DropdownMenuItem(
              value: subject,
              child: Text(subject),
            )).toList(),
            onChanged: (val) => setState(() => _selectedSubject = val!),
          ),
        ),
      ],
    );
  }
  Widget _buildCurrentPage() {
    switch (_selectedDrawerIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildClassView();
      case 2:
        return _buildStatisticsView();
      case 3:
        return _buildReportsView();
      case 4:
        return _buildAlertsView();
      default:
        return _buildDashboard();
    }
  }
  Widget _buildDashboard() {
    var stats = _subjectStatistics;
    double globalAverage = stats.isEmpty
        ? 0
        : stats.map((s) => s.average).reduce((a, b) => a + b) / stats.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        double barWidth = constraints.maxWidth / (stats.length + 1);
        barWidth = barWidth.clamp(80.0, 120.0);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateurs clés
              LayoutBuilder(
                builder: (context, rowConstraints) {
                  bool isWide = rowConstraints.maxWidth > 600;
                  return isWide
                      ? Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Moyenne Générale',
                                '${globalAverage.toStringAsFixed(1)}/20',
                                Icons.trending_up,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Total Notes',
                                '${_filteredNotes.length}',
                                Icons.assignment,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Classes Actives',
                                '${_classes.length - 1}',
                                Icons.school,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                'Matières',
                                '${_subjects.length - 1}',
                                Icons.book,
                                Colors.purple,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Moyenne Générale',
                                    '${globalAverage.toStringAsFixed(1)}/20',
                                    Icons.trending_up,
                                    Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Total Notes',
                                    '${_filteredNotes.length}',
                                    Icons.assignment,
                                    Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Classes Actives',
                                    '${_classes.length - 1}',
                                    Icons.school,
                                    Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Matières',
                                    '${_subjects.length - 1}',
                                    Icons.book,
                                    Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(height: 24),
              // Graphique des performances (simulé)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bar_chart, color: Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Performances par Matière',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: stats.length,
                          itemBuilder: (context, index) {
                            var stat = stats[index];
                            return Container(
                              width: barWidth,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.bottomCenter,
                                        heightFactor: stat.average / 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.indigo.shade600,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${stat.average.toStringAsFixed(1)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    stat.subject,
                                    style: const TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Dernières notes
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history, color: Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Dernières Notes Saisies',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._filteredNotes.take(5).map((note) => _buildNoteCard(note)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildClassView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.class_, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Notes de $_selectedClass',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_filteredNotes.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune note trouvée pour les filtres sélectionnés',
                              style: TextStyle(color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_selectedClass == 'Toutes les classes')
                    ..._filteredNotes.map((note) => _buildDetailedNoteCard(note))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _studentsWithNotes.length,
                      itemBuilder: (context, index) {
                        var student = _studentsWithNotes[index];
                        return ExpansionTile(
                          title: Text(
                            student['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Moyenne: ${student['average'].toStringAsFixed(1)}/20 | Notes: ${student['notes'].length}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          children: (student['notes'] as List<Note>)
                              .map((note) => _buildDetailedNoteCard(note))
                              .toList(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatisticsView() {
    var stats = _subjectStatistics;
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Statistiques Détaillées',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (stats.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Aucune donnée disponible pour les filtres sélectionnés',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ...stats.map((stat) => _buildStatisticCard(stat)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReportsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assessment, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Rapports et Analyses',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReportButton(
                    'Bulletin de Notes par Classe',
                    Icons.description,
                    'Génère un bulletin détaillé pour chaque classe',
                  ),
                  _buildReportButton(
                    'Analyse des Performances',
                    Icons.analytics,
                    'Analyse comparative des résultats scolaires',
                  ),
                  _buildReportButton(
                    'Comparaison Inter-Classes',
                    Icons.compare,
                    'Compare les performances entre les différentes classes',
                  ),
                  _buildReportButton(
                    'Évolution Trimestrielle',
                    Icons.trending_up,
                    'Suivi de l\'évolution des notes sur l\'année',
                  ),
                  _buildReportButton(
                    'Rapport de Synthèse',
                    Icons.summarize,
                    'Vue d\'ensemble complète de l\'établissement',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAlertsView() {
    List<Map<String, dynamic>> alerts = [
      {
        'type': 'warning',
        'title': 'Notes en baisse',
        'message': 'Martin Dubois - Mathématiques: baisse de 3 points',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'type': 'info',
        'title': 'Nouvelle note excellente',
        'message': 'Thomas Moreau - Sciences: 18/20',
        'date': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'type': 'error',
        'title': 'Note préoccupante',
        'message': 'Classe 4ème B - Français: moyenne inférieure à 10',
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Alertes et Notifications',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...alerts.map((alert) => _buildAlertCard(alert)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade600,
          child: Icon(Icons.notification_important, color: Colors.white),
        ),
        title: Text(
          alert['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert['message']),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(alert['date']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showAlertActions(alert),
        ),
        isThreeLine: true,
      ),
    );
  }
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.5),
              color,
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNoteCard(Note note) {
    Color noteColor = _getNoteColor(note.percentage);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: noteColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: noteColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${note.value}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          note.studentName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${note.subject} - ${note.type}'),
            Text(
              note.className,
              style: TextStyle(
                fontSize: 12,
                color: Colors.indigo.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${note.value}/${note.maxValue}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              _formatDate(note.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
  Widget _buildDetailedNoteCard(Note note) {
    Color noteColor = _getNoteColor(note.percentage);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 300;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.studentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    note.className,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.indigo.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: noteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: noteColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${note.value}/${note.maxValue}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.studentName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  note.className,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: noteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: noteColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${note.value}/${note.maxValue}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 16),
            // Informations détaillées
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.subject, 'Matière', '${note.subject} - ${note.type}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, 'Enseignant', note.teacherName),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.calendar_today, 'Date', _formatDate(note.date)),
                  if (note.comment != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.comment, 'Commentaire', note.comment!),
                  ],
                ],
              ),
            ),
            // Pourcentage et appréciation
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: note.percentage / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(noteColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${note.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: noteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
  Widget _buildStatisticCard(SubjectStatistics stat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat.subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;
                return isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: _buildStatisticItem(
                              'Moyenne',
                              '${stat.average.toStringAsFixed(1)}/20',
                              Icons.trending_up,
                              Colors.blue,
                            ),
                          ),
                          Flexible(
                            child: _buildStatisticItem(
                              'Notes',
                              '${stat.totalNotes}',
                              Icons.assignment,
                              Colors.green,
                            ),
                          ),
                          Flexible(
                            child: _buildStatisticItem(
                              'Min',
                              '${stat.minNote.toStringAsFixed(1)}/20',
                              Icons.trending_down,
                              Colors.red,
                            ),
                          ),
                          Flexible(
                            child: _buildStatisticItem(
                              'Max',
                              '${stat.maxNote.toStringAsFixed(1)}/20',
                              Icons.trending_up,
                              Colors.orange,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: _buildStatisticItem(
                                  'Moyenne',
                                  '${stat.average.toStringAsFixed(1)}/20',
                                  Icons.trending_up,
                                  Colors.blue,
                                ),
                              ),
                              Flexible(
                                child: _buildStatisticItem(
                                  'Notes',
                                  '${stat.totalNotes}',
                                  Icons.assignment,
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: _buildStatisticItem(
                                  'Min',
                                  '${stat.minNote.toStringAsFixed(1)}/20',
                                  Icons.trending_down,
                                  Colors.red,
                                ),
                              ),
                              Flexible(
                                child: _buildStatisticItem(
                                  'Max',
                                  '${stat.maxNote.toStringAsFixed(1)}/20',
                                  Icons.trending_up,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildStatisticItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  Widget _buildReportButton(String title, IconData icon, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showReportDialog(title),
      ),
    );
  }
  // Méthodes d'aide et dialogs
  void _showReportDialog(String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reportType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Générer le rapport: $reportType'),
            const SizedBox(height: 16),
            const Text('Options disponibles :'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _generateReport(reportType, 'PDF');
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Générer PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _generateReport(reportType, 'Excel');
              },
              icon: const Icon(Icons.table_chart),
              label: const Text('Exporter Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _generateReport(reportType, 'Email');
              },
              icon: const Icon(Icons.email),
              label: const Text('Envoyer par Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exporter les données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF'),
              subtitle: const Text('Format pour impression'),
              onTap: () {
                Navigator.pop(context);
                _exportData('PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Excel'),
              subtitle: const Text('Format pour analyse'),
              onTap: () {
                Navigator.pop(context);
                _exportData('Excel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text('CSV'),
              subtitle: const Text('Format universel'),
              onTap: () {
                Navigator.pop(context);
                _exportData('CSV');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paramètres'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Fréquence d\'actualisation'),
              subtitle: Text('Automatique toutes les 5 minutes'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              subtitle: Text('Alertes activées'),
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Sécurité'),
              subtitle: Text('Accès restreint chef établissement'),
            ),
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
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guide d\'utilisation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Utilisez les filtres pour affiner vos recherches'),
              Text('• Consultez le tableau de bord pour une vue d\'ensemble'),
              Text('• Analysez les statistiques par matière'),
              Text('• Générez des rapports au format PDF ou Excel'),
              Text('• Surveillez les alertes importantes'),
              SizedBox(height: 16),
              Text(
                'Contact support:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Email: support@etablissement.edu'),
              Text('Tél: 01 23 45 67 89'),
            ],
          ),
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
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('À propos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, size: 64, color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              'Système de Gestion des Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Application dédiée aux chefs d\'établissement pour le suivi et l\'analyse des performances scolaires.',
              textAlign: TextAlign.center,
            ),
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
  void _showAlertActions(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(alert['message']),
            const SizedBox(height: 16),
            const Text('Actions disponibles:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Marquer comme lu'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ignorer'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voir détails'),
          ),
        ],
      ),
    );
  }
  void _generateReport(String reportType, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Génération du rapport: $reportType ($format)'),
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () {},
        ),
      ),
    );
  }
  void _exportData(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export des données en cours ($format)...'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  Color _getNoteColor(double percentage) {
    if (percentage >= 80) return Colors.green.shade600;
    if (percentage >= 70) return Colors.lightGreen.shade600;
    if (percentage >= 60) return Colors.orange.shade600;
    if (percentage >= 50) return Colors.deepOrange.shade600;
    return Colors.red.shade600;
  }
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
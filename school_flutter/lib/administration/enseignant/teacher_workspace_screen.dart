import 'package:flutter/material.dart';
import 'class_detail_screen.dart';
import 'package:school_flutter/administration/chef_etablissement/template_chef.dart';

class TeacherWorkspaceScreen extends StatefulWidget {
  const TeacherWorkspaceScreen({super.key});

  @override
  State<TeacherWorkspaceScreen> createState() => _TeacherWorkspaceScreenState();
}

class _TeacherWorkspaceScreenState extends State<TeacherWorkspaceScreen> {
  int _selectedIndex = 0;

  // Pages pour la navigation
  late final List<Widget> _pages;

  // Données fictives pour le tableau de bord
  final Map<String, dynamic> _dashboardData = {
    'totalClasses': 3,
    'totalStudents': 83,
    'nextClass': '3ème A - 10h30',
    'upcomingExams': [
      {'class': '4ème B', 'date': '15 Sept', 'type': 'Contrôle continu'},
      {'class': '3ème A', 'date': '18 Sept', 'type': 'Devoir surveillé'},
    ],
    'recentActivity': [
      {'type': 'Note', 'class': '5ème C', 'date': '11 Sept', 'description': 'Notes du devoir surveillé ajoutées'},
      {'type': 'Absence', 'class': '3ème A', 'date': '10 Sept', 'description': '2 absences signalées'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(data: _dashboardData),
      const ClassListPage(),
      NotificationsPage(activities: _dashboardData['recentActivity']),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deconnexion(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TemplateChefLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Enseignant'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      size: 40,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enseignant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Voir classes'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () => _deconnexion(context),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class ClassListPage extends StatelessWidget {
  const ClassListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste fictive des classes avec types spécifiés
    final List<Map<String, String>> classes = [
      {'nom': '3ème A', 'matiere': 'Mathématiques', 'nombreEleves': '25'},
      {'nom': '4ème B', 'matiere': 'Mathématiques', 'nombreEleves': '28'},
      {'nom': '5ème C', 'matiere': 'Physique', 'nombreEleves': '30'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes Classes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final classe = classes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      classe['nom']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Matière: ${classe['matiere']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Nombre d\'élèves: ${classe['nombreEleves']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassDetailScreen(
                              className: classe['nom']!,
                              subject: classe['matiere']!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accéder'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DashboardPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec statistiques
          Row(
            children: [
              _buildStatCard(
                'Classes',
                data['totalClasses'].toString(),
                Icons.class_,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Élèves',
                data['totalStudents'].toString(),
                Icons.people,
                Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Prochain cours
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prochain cours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        data['nextClass'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Examens à venir
          _buildUpcomingExams(data['upcomingExams'] as List),
          const SizedBox(height: 24),

          // Activités récentes
          _buildRecentActivities(data['recentActivity'] as List),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingExams(List exams) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Examens à venir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...exams.map((exam) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam['class'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${exam['type']} - ${exam['date']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(List activities) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activités récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...activities.map((activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        activity['type'] == 'Note' ? Icons.grade : Icons.event_busy,
                        color: activity['type'] == 'Note' ? Colors.blue : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['class'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              activity['description'] as String,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              activity['date'] as String,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final List activities;

  const NotificationsPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: activity['type'] == 'Note' 
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      child: Icon(
                        activity['type'] == 'Note' ? Icons.grade : Icons.event_busy,
                        color: activity['type'] == 'Note' ? Colors.blue : Colors.red,
                      ),
                    ),
                    title: Text(activity['class'] as String),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity['description'] as String),
                        Text(
                          activity['date'] as String,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

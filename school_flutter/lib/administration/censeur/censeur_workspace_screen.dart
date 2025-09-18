import 'package:flutter/material.dart';
import 'exam_schedule_screen.dart';
import 'teacher_monitoring_screen.dart';
import 'package:school_flutter/administration/chef_etablissement/template_chef.dart';

class CenseurWorkspaceScreen extends StatefulWidget {
  const CenseurWorkspaceScreen({super.key});

  @override
  State<CenseurWorkspaceScreen> createState() => _CenseurWorkspaceScreenState();
}

class _CenseurWorkspaceScreenState extends State<CenseurWorkspaceScreen> {
  int _selectedIndex = 0;

  // Données fictives pour le tableau de bord
  final Map<String, dynamic> _dashboardData = {
    'totalTeachers': 25,
    'totalExams': 12,
    'upcomingExams': [
      {'class': '3ème A', 'subject': 'Mathématiques', 'date': '15 Sept 2025', 'time': '10:00'},
      {'class': '4ème B', 'subject': 'Physique', 'date': '16 Sept 2025', 'time': '14:00'},
      {'class': '5ème C', 'subject': 'Français', 'date': '17 Sept 2025', 'time': '08:00'},
    ],
    'recentActivities': [
      {'type': 'Note', 'teacher': 'M. Dupont', 'class': '3ème A', 'subject': 'Mathématiques', 'date': '11 Sept'},
      {'type': 'Devoir', 'teacher': 'Mme Martin', 'class': '4ème B', 'subject': 'Français', 'date': '10 Sept'},
      {'type': 'Absence', 'teacher': 'M. Durant', 'class': '5ème C', 'subject': 'Histoire', 'date': '09 Sept'},
    ],
  };

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(data: _dashboardData),
      ExamSchedulePage(upcomingExams: _dashboardData['upcomingExams']),
      TeacherMonitoringPage(activities: _dashboardData['recentActivities']),
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
        title: const Text('Espace Censeur'),
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
                    'Censeur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Tableau de bord'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Programmation des devoirs'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor),
              title: const Text('Suivi des enseignants'),
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
          // Statistiques
          Row(
            children: [
              _buildStatCard(
                'Enseignants',
                data['totalTeachers'].toString(),
                Icons.people,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Devoirs programmés',
                data['totalExams'].toString(),
                Icons.assignment,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Prochains devoirs
          const Text(
            'Prochains devoirs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...data['upcomingExams'].map<Widget>((exam) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF4A90E2),
                    child: Icon(Icons.assignment, color: Colors.white),
                  ),
                  title: Text('${exam['class']} - ${exam['subject']}'),
                  subtitle: Text('${exam['date']} à ${exam['time']}'),
                ),
              )),

          const SizedBox(height: 24),

          // Activités récentes
          const Text(
            'Activités récentes des enseignants',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...data['recentActivities'].map<Widget>((activity) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getActivityColor(activity['type']).withOpacity(0.2),
                    child: Icon(
                      _getActivityIcon(activity['type']),
                      color: _getActivityColor(activity['type']),
                    ),
                  ),
                  title: Text(activity['teacher']),
                  subtitle: Text(
                    '${activity['class']} - ${activity['subject']}\n${activity['date']}',
                  ),
                  isThreeLine: true,
                ),
              )),
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

  Color _getActivityColor(String type) {
    switch (type) {
      case 'Note':
        return Colors.blue;
      case 'Devoir':
        return Colors.green;
      case 'Absence':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'Note':
        return Icons.grade;
      case 'Devoir':
        return Icons.assignment;
      case 'Absence':
        return Icons.person_off;
      default:
        return Icons.info;
    }
  }
}

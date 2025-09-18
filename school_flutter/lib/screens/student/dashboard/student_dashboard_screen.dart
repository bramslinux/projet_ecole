import 'package:flutter/material.dart';
import '../grades/grades_screen.dart';
import '../schedule/schedule_screen.dart';
import '../absences/absences_screen.dart';
import '../../registration/registration_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(
            Icons.school,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 12),
          const Text(
            'Espace Élève',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // TODO: Implémenter la vue des notifications
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 56, 100, 142),
              const Color.fromARGB(255, 76, 168, 175),
              const Color.fromARGB(255, 129, 167, 199),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 90, 94),
              ),
              accountName: const Text('John Doe'),
              accountEmail: const Text('Classe: 3ème A'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'JD',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 56, 122, 142),
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Accueil',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.grade,
              title: 'Notes',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.calendar_today,
              title: 'Emploi du temps',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.warning,
              title: 'Absences',
              index: 3,
            ),
            _buildDrawerItem(
              icon: Icons.app_registration,
              title: 'Inscription',
              index: 4,
            ),
            const Divider(color: Colors.white70),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      selected: _selectedIndex == index,
      selectedColor: Colors.white,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildGradesContent();
      case 2:
        return _buildScheduleContent();
      case 3:
        return _buildAbsencesContent();
      case 4:
        return _buildRegistrationContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue dans votre espace élève',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildQuickAccessCard(),
          const SizedBox(height: 24),
          _buildUpcomingEventsCard(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accès rapide',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildQuickAccessButton(
                  icon: Icons.grade,
                  label: 'Notes',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _buildQuickAccessButton(
                  icon: Icons.calendar_today,
                  label: 'Emploi du temps',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _buildQuickAccessButton(
                  icon: Icons.warning,
                  label: 'Absences',
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 120,
          child: Column(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 56, 129, 142)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: const Color.fromARGB(255, 56, 103, 142)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Événements à venir',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Implémenter la liste des événements
            const Text('Aucun événement à venir'),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesContent() {
    return const GradesScreen();
  }

  Widget _buildScheduleContent() {
    return const ScheduleScreen();
  }

  Widget _buildAbsencesContent() {
    return const AbsencesScreen();
  }

  Widget _buildRegistrationContent() {
    return const RegistrationScreen();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme la boîte de dialogue
              Navigator.pushReplacementNamed(context, '/'); // Retour à l'accueil
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

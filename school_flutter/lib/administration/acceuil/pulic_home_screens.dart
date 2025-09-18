import 'package:flutter/material.dart';
import 'package:school_flutter/administration/chef_etablissement/chef_subscription_screen.dart';
import 'package:school_flutter/administration/eleve/student_subscription_screen.dart';
import 'package:school_flutter/administration/eleve/student_workspace_screen.dart';
import 'package:school_flutter/administration/chef_etablissement/template_chef.dart';
import 'package:school_flutter/administration/parent/parent_registration_screen.dart';
import 'package:school_flutter/administration/parent/dasboard_basique_parent.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    

 
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 76, 175, 170).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
              Image.network(
                'https://flagcdn.com/w40/bf.png', // Drapeau du Burkina (40px de largeur)
                width: isSmallScreen ? 24 : 32,
                height: isSmallScreen ? 16 : 20,
                fit: BoxFit.cover,
              ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          const Text(
            'ShoolMap',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 56, 103, 142),
              const Color.fromARGB(255, 76, 122, 175),
              const Color.fromARGB(255, 38, 107, 255),
            ],
          ),
        ),
      ),
      actions: [
        if (!isSmallScreen) // Only show on larger screens
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 16, 
              vertical: isSmallScreen ? 6 : 8
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 16, 
              vertical: isSmallScreen ? 6 : 8
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 77, 148, 255).withOpacity(0.9),
                  const Color.fromARGB(255, 38, 139, 255).withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.campaign_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'ESPACE PUB - Faites-vous voir ici !',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 12 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.grade,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDrawer() {
  final isSmallScreen = MediaQuery.of(context).size.width < 600;

  return Drawer(
    width: isSmallScreen ? null : 320,
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 56, 122, 142),
            const Color.fromARGB(255, 76, 152, 175),
            const Color.fromARGB(255, 38, 157, 255),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),

            // Le contenu principal du drawer
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Accueil',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                   _buildDrawerItem(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Parent',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                     MaterialPageRoute(
                      builder: (context) => const ParentLoginScreen(),
      ),
    );
                    },
                  ),
                  const SizedBox(height: 10),
               /*   _buildExpandableDrawerItem(
                    icon: Icons.people_rounded,
                    title: 'Parents',
                    children: [
                      _buildSubDrawerItem(
                        title: 'Creation de compte',
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToParentSubscription();
                        },
                      ),
                      _buildSubDrawerItem(
                        title: 'Connexion',
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToParentWorkspace();
                        },
                      ),
                    ],
                  ),*/
                  _buildDrawerItem(
                    icon: Icons.person_rounded,
                    title: 'Administration',
                    onTap: () {
                      Navigator.pop(context);
                       Navigator.push(
                        context,
                     MaterialPageRoute(
                      builder: (context) => const TemplateChefLogin(),
      ),
    );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.supervisor_account,
                    title: 'Élève',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                     MaterialPageRoute(
                      builder: (context) => const StudentLoginScreen(),
      ),
    );
                    },
                  ),
                /*  _buildExpandableDrawerItem(
                    icon: Icons.child_care_rounded,
                    title: 'Élève',
                    children: [
                      _buildSubDrawerItem(
                        title: 'Creation de compte',
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToStudentSubscription();
                        },
                      ),
                      _buildSubDrawerItem(
                        title: 'se connecter ou Creer un compte',
                        onTap: () {
                          Navigator.pop(context);
                          _navigateToStudentWorkspace();
                        },
                      ),
                    ],
                  ),*/
                  const SizedBox(height: 10),
                  _buildDrawerItem(
                    icon: Icons.new_releases_rounded,
                    title: 'Actualités',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                     MaterialPageRoute(
                      builder: (context) => const PublicHomeScreen(),
      ),
    );
                    },
                  ),
                
                ],
              ),
            ),

            const Divider(color: Colors.white30, thickness: 1),

            // Les éléments du bas (collés en bas)
            _buildDrawerItem(
              icon: Icons.contact_support_rounded,
              title: 'Contact',
              onTap: () {
                Navigator.pop(context);
                _showContactInfo();
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_rounded,
              title: 'À propos',
              onTap: () {
                Navigator.pop(context);
                _showAboutInfo();
              },
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildDrawerHeader() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 46, 64, 125),
            const Color.fromARGB(255, 67, 141, 160),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:
            Image.network(
              'https://flagcdn.com/w40/bf.png', // Drapeau du Burkina (40px de largeur)
              width: isSmallScreen ? 24 : 32,
              height: isSmallScreen ? 16 : 20,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          const Text(
            'SchoolMap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Plateforme de gestion scolaire',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /*Widget _buildExpandableDrawerItem({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: children,
    );
  }
*/
/*
  Widget _buildSubDrawerItem({
    required String title,
    required VoidCallback onTap,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: isSmallScreen ? 56 : 72, 
        right: 16
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w400,
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
*/
  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.orange.shade50,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildFlashInfo(),
            _buildFeaturesSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
      child: Column(
        children: [
          SizedBox(height: isSmallScreen ? 20 : 40),
          Text(
            'Bienvenue sur SchoolMap',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : (isMediumScreen ? 28 : 32),
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 46, 109, 125),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Text(
            'La plateforme complète de gestion des établissements scolaires',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
              color: const Color.fromARGB(255, 67, 126, 160),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 20 : 40),
          Container(
            height: isSmallScreen ? 220 : 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 76, 175, 167).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 76, 160, 175).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: isSmallScreen ? 60 : 80,
                    color: const Color.fromARGB(255, 102, 187, 187),
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'SchoolMap disponible pour vous',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : (isMediumScreen ? 18 : 20),
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 56, 142, 142),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashInfo() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6.0 : 8.0, 
                  vertical: isSmallScreen ? 3.0 : 4.0
                ),
                child: Text(
                  'INFORMATIONS:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 10),
              Expanded(
                child: Text(
                  '''2025-2026 : La souscription des établissements à SCHOOLMAP 2025-2026 est ouverte.''',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: isSmallScreen ? 2 : 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: isSmallScreen ? 14 : 16),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: isSmallScreen ? 14 : 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    
    // Determine grid columns based on screen size
    int crossAxisCount = 1; // Default for very small screens
    if (screenWidth > 300 && screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth >= 600 && screenWidth < 900) {
      crossAxisCount = 2;
    } else if (screenWidth >= 900) {
      crossAxisCount = 3;
    }
    
    double childAspectRatio = isSmallScreen ? 1.0 : (isMediumScreen ? 1.1 : 1.2);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
      child: Column(
        children: [
          Text(
            'Nos Etablissements',
            style: TextStyle(
              fontSize: isSmallScreen ? 22 : (isMediumScreen ? 25 : 28),
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 46, 125, 118),
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 32),
          GridView.count(
             
                
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
            
          
            
            children: [
              _buildFeatureCard(
                title: 'Voir la liste des établissements',
                description: 'Inscrire facilement et rapidement',
                icon: Icons.credit_card_rounded,
                color: Colors.blue,
                onTap: _navigateToSubscription,
              ),
              _buildFeatureCard(
                title: 'Info des établissements',
                description: 'Voir les informations des établissements',
                icon: Icons.dashboard_rounded,
                color: Colors.orange,
                onTap: _navigateToMemberSpace,
              ),
             _buildFeatureCard(
                title: 'Répétiteurs',
                description: 'Trouvez des répétiteurs qualifiés',
                icon: Icons.person_search_rounded,
                color: Colors.purple,
                onTap: _navigateToTutors,
              ),
               /*
              _buildFeatureCard(
                title: 'Tableau D\'honneur',
                description: 'Consultez les meilleurs élèves',
                icon: Icons.emoji_events_rounded,
                color: Colors.amber,
                onTap: _navigateToHonorBoard,
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: isSmallScreen ? 24 : 32,
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 16),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 5 : 8),
            Text(
              description,
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 46, 54, 125),
            const Color.fromARGB(255, 56, 57, 142),
          ],
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: isSmallScreen ? 10 : 16,
            runSpacing: isSmallScreen ? 20 : 16,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
              width: 400,
              child: _buildFooterSection(
                title: 'Contact Info',
                items: [
                  'Pour une meilleure gestion de votre établissement.',
                  'Téléphone: (+226) 06 42 42 77',
                  'Téléphone: (+226) 54 22 77 12',
                ],
              ),
              ),
               SizedBox(
              width: 300,
              child:
              _buildFooterSection(
                title: 'Espace Parents Disponible',
                items: [
                  
                  'SchoolMap parent est disponible pour le suivi complete élève pour toute l\'année scolaire.',
                  
                ],
              ),
               ),
                SizedBox(
              width: 300,
              child:
              _buildFooterSection(
                title: 'Espace Établissements Disponible',
                items: [
                  
                  'Tout sur la gestion de votre établissement.',
                  
                ],
              ),
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 32),
          const Divider(color: Colors.white30),
          SizedBox(height: isSmallScreen ? 10 : 16),
          Text(
            '© SchoolMap | All Rights Reserved © 2025 - 2026',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isSmallScreen ? 12 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection({
    required String title,
    required List<String> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;
    
    // Adapter la largeur en fonction de l'écran
    double sectionWidth;
    if (isSmallScreen) {
      sectionWidth = screenWidth > 350 ? 150 : screenWidth * 0.8;
    } else if (isMediumScreen) {
      sectionWidth = 180;
    } else {
      sectionWidth = 200;
    }
    
    return SizedBox(
      width: sectionWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: isSmallScreen ? 4 : 6),
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToParentSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentRegistrationScreen()),
    );
  }

  /*void _navigateToParentWorkspace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentLoginScreen()),
    );
  }
*/


  

  void _navigateToStudentSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentSubscriptionScreen()),
    );
  }


/*

  void _navigateToStudentWorkspace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
    );
  }
*/
  void _navigateToSubscription() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Choisir le type de souscription',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Parent',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _navigateToParentSubscription();
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Text(
                'Chef d\'Établissement',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCodeEtablissementDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.child_care_rounded),
              title: Text(
                'Élève',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _navigateToStudentSubscription();
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

  void _navigateToMemberSpace() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Espace membre - En développement')),
    );
  }

 void _navigateToTutors() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Répétiteurs - En développement')),
    );
  }
 /*
  void _navigateToHonorBoard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tableau d\'honneur - En développement')),
    );
  }
*/
  void _showContactInfo() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Informations de contact',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.phone, 'Téléphone: (+226) 01 42 42 77'),
            _buildContactItem(Icons.phone, 'Téléphone: (+226) 07 09 99 55'),
            _buildContactItem(Icons.phone, 'Téléphone: (+226) 05 05 50 51'),
            _buildContactItem(Icons.email, 'Email: schoolmap@gmail.com'),
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

  void _showAboutInfo() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'À propos d\'SchoolMap',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'SchoolMap est une plateforme de gestion scolaire complète '
          'qui permet aux établissements et aux parents de gérer '
          'efficacement la scolarité des élèves.',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
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

  Widget _buildContactItem(IconData icon, String text) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: isSmallScreen ? 18 : 20, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showCodeEtablissementDialog() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    // Données fictives pour la démonstration (remplacez par votre API ou base de données)
    final Map<String, String> _mockEtablissements = {
      'CODE123': 'Lycée Moderne',
      'CODE456': 'Collège International',
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          width: isSmallScreen ? MediaQuery.of(context).size.width * 0.9 : 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isSmallScreen ? 60 : 70,
                    height: isSmallScreen ? 60 : 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 120, 150).withOpacity(0.8),
                          const Color.fromARGB(255, 0, 74, 212).withOpacity(0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 90, 150).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.business_rounded,
                      size: isSmallScreen ? 30 : 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  Text(
                    'Souscription Chef d\'Établissement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  Text(
                    'Entrez le code d\'établissement fourni par l\'administrateur',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 28),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ex: CODE123',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 16 : 18,
                        ),
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Code obligatoire';
                        }
                        if (!_mockEtablissements.containsKey(value)) {
                          return 'Code d\'établissement non valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: isSmallScreen ? 45 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(
                                  'Annuler',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: Container(
                          height: isSmallScreen ? 45 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 0, 120, 150).withOpacity(0.9),
                                const Color.fromARGB(255, 0, 145, 212).withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 132, 150).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChefSubscriptionScreen(
                                        codeEtablissement: controller.text,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Continuer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
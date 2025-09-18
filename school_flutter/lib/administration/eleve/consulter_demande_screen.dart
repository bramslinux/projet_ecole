import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// AuthService (même que précédemment)
class AuthService {
  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
  }

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };
}

class ConsulterDemandesScreen extends StatefulWidget {
  const ConsulterDemandesScreen({super.key});

  @override
  State<ConsulterDemandesScreen> createState() =>
      _ConsulterDemandesScreenState();
}

class _ConsulterDemandesScreenState extends State<ConsulterDemandesScreen> {
  List<dynamic> _demandes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchDemandes();
  }

  Future<void> _loadTokenAndFetchDemandes() async {
    await AuthService.loadTokens();
    await _fetchDemandes();
  }

  // Récupérer les demandes de l'élève
  Future<void> _fetchDemandes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/scolarite/demandes/"),
        headers: AuthService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _demandes = data is List ? data : [];
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _error = "Session expirée. Veuillez vous reconnecter.";
          _isLoading = false;
        });
      } else {
        setState(() {
          _error =
              "Impossible de charger les demandes (${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur réseau lors du chargement des demandes";
        _isLoading = false;
      });
    }
  }

  // Rafraîchir les données
  Future<void> _refreshDemandes() async {
    await _fetchDemandes();
  }

  // Couleur selon le statut
  Color _getStatusColor(String? statut) {
    switch (statut?.toLowerCase()) {
      case 'approuvee':
      case 'approuvée':
        return Colors.green;
      case 'rejetee':
      case 'rejetée':
        return Colors.red;
      case 'en_attente':
      case 'en attente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Icône selon le statut
  IconData _getStatusIcon(String? statut) {
    switch (statut?.toLowerCase()) {
      case 'approuvee':
      case 'approuvée':
        return Icons.check_circle;
      case 'rejetee':
      case 'rejetée':
        return Icons.cancel;
      case 'en_attente':
      case 'en attente':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  // Formater la date
  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Date non disponible';
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateStr;
    }
  }

  // Widget pour une demande
  Widget _buildDemandeCard(Map<String, dynamic> demande) {
    final statut = demande['statut']?.toString() ?? 'en_attente';
    final statusColor = _getStatusColor(statut);
    final statusIcon = _getStatusIcon(statut);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDemandeDetails(demande),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec statut
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(statut),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'ID: ${demande['id'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Informations principales
              _buildInfoRow(
                Icons.school,
                'Établissement',
                demande['etablissement_nom']?.toString() ??
                    demande['etablissement']?.toString() ??
                    'N/A',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.class_,
                'Niveau',
                demande['niveau_nom']?.toString() ??
                    demande['niveau']?.toString() ??
                    'N/A',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.door_front_door,
                'Salle',
                demande['salle_nom']?.toString() ??
                    demande['salle']?.toString() ??
                    'N/A',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.calendar_today,
                'Date de demande',
                _formatDate(demande['date_creation']?.toString()),
              ),

              if (demande['commentaire'] != null &&
                  demande['commentaire'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.comment,
                  'Commentaire',
                  demande['commentaire'].toString(),
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showDemandeDetails(demande),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Voir détails'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour une ligne d'information
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Texte du statut en français
  String _getStatusText(String statut) {
    switch (statut.toLowerCase()) {
      case 'approuvee':
      case 'approuvée':
        return 'Approuvée';
      case 'rejetee':
      case 'rejetée':
        return 'Rejetée';
      case 'en_attente':
      case 'en attente':
        return 'En attente';
      default:
        return statut;
    }
  }

  // Afficher les détails d'une demande
  void _showDemandeDetails(Map<String, dynamic> demande) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Demande #${demande['id']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow(
                    'Statut',
                    _getStatusText(demande['statut']?.toString() ?? ''),
                  ),
                  _buildDetailRow(
                    'Établissement',
                    demande['etablissement_nom']?.toString() ??
                        demande['etablissement']?.toString() ??
                        'N/A',
                  ),
                  _buildDetailRow(
                    'Niveau',
                    demande['niveau_nom']?.toString() ??
                        demande['niveau']?.toString() ??
                        'N/A',
                  ),
                  _buildDetailRow(
                    'Salle',
                    demande['salle_nom']?.toString() ??
                        demande['salle']?.toString() ??
                        'N/A',
                  ),
                  _buildDetailRow(
                    'Date de création',
                    _formatDate(demande['date_creation']?.toString()),
                  ),
                  if (demande['date_traitement'] != null)
                    _buildDetailRow(
                      'Date de traitement',
                      _formatDate(demande['date_traitement']?.toString()),
                    ),
                  if (demande['commentaire'] != null &&
                      demande['commentaire'].toString().isNotEmpty)
                    _buildDetailRow(
                      'Commentaire',
                      demande['commentaire'].toString(),
                    ),

                  // Fichiers
                  const SizedBox(height: 16),
                  const Text(
                    'Fichiers joints:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (demande['bulletin'] != null)
                    _buildFileRow('Bulletin', demande['bulletin'].toString()),
                  if (demande['dernier_diplome'] != null)
                    _buildFileRow(
                      'Dernier diplôme',
                      demande['dernier_diplome'].toString(),
                    ),
                  if (demande['photo'] != null)
                    _buildFileRow('Photo', demande['photo'].toString()),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildFileRow(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.attachment, size: 16),
          const SizedBox(width: 4),
          Text(label),
          const Spacer(),
          const Icon(Icons.download, size: 16, color: Colors.blue),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Demandes'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _refreshDemandes,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDemandes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête
                  Row(
                    children: [
                      const Icon(
                        Icons.assignment,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Mes Demandes',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (_demandes.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_demandes.length} demande${_demandes.length > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Contenu principal
                  if (_isLoading)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Chargement des demandes...'),
                        ],
                      ),
                    )
                  else if (_error != null)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshDemandes,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else if (_demandes.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune demande trouvée',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vous n\'avez pas encore fait de demande.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigation vers la page de nouvelle demande
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Faire une demande'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        // Statistiques rapides
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'En attente',
                                _demandes
                                    .where(
                                      (d) =>
                                          (d['statut']
                                                  ?.toString()
                                                  .toLowerCase() ??
                                              '') ==
                                          'en_attente',
                                    )
                                    .length,
                                Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Approuvées',
                                _demandes
                                    .where(
                                      (d) =>
                                          (d['statut']
                                                  ?.toString()
                                                  .toLowerCase() ??
                                              '') ==
                                          'approuvee',
                                    )
                                    .length,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Rejetées',
                                _demandes
                                    .where(
                                      (d) =>
                                          (d['statut']
                                                  ?.toString()
                                                  .toLowerCase() ??
                                              '') ==
                                          'rejetee',
                                    )
                                    .length,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Liste des demandes
                        ...(_demandes.map(
                          (demande) => _buildDemandeCard(demande),
                        )),
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

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  String _selectedPeriod = 'Septembre 2025';
  final List<String> _periods = [
    'Septembre 2025',
    'Octobre 2025',
    'Novembre 2025',
    'Décembre 2025',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Absences',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildSummaryCards(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    isExpanded: true,
                    items: _periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPeriod = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildAbsencesTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total des absences',
            '12h',
            Icons.access_time,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Absences justifiées',
            '8h',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Absences non justifiées',
            '4h',
            Icons.warning,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsencesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Matière')),
          DataColumn(label: Text('Durée')),
          DataColumn(label: Text('Motif')),
          DataColumn(label: Text('Statut')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          _buildAbsenceRow(
            '05/09/2025',
            'Mathématiques',
            '2h',
            'Maladie',
            true,
          ),
          _buildAbsenceRow(
            '07/09/2025',
            'Français',
            '1h',
            'Rendez-vous médical',
            true,
          ),
          _buildAbsenceRow(
            '12/09/2025',
            'Anglais',
            '1h',
            '-',
            false,
          ),
        ],
      ),
    );
  }

  DataRow _buildAbsenceRow(
    String date,
    String subject,
    String duration,
    String reason,
    bool isJustified,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(date)),
        DataCell(Text(subject)),
        DataCell(Text(duration)),
        DataCell(Text(reason)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isJustified ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isJustified ? 'Justifiée' : 'Non justifiée',
              style: TextStyle(
                color: isJustified ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.upload_file,
              color: isJustified ? Colors.grey : Colors.blue,
            ),
            onPressed: isJustified ? null : () => _showJustificationDialog(),
          ),
        ),
      ],
    );
  }

  void _showJustificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Justifier l\'absence'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Motif',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implémenter le téléchargement de fichier
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Télécharger un justificatif'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la soumission du justificatif
              Navigator.pop(context);
            },
            child: const Text('Soumettre'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<String> _days = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
  ];

  final List<String> _hours = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: const Text("Emploi du temps"),
        backgroundColor: Colors.teal,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emploi du temps',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Table responsive
                Card(
                  elevation: 4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth, // largeur minimale
                      ),
                      child: DataTable(
                        columnSpacing: isMobile ? 12 : 24,
                        dataRowMinHeight: isMobile ? 40 : 56,
                        dataRowMaxHeight: isMobile ? 70 : 90,
                        headingRowHeight: isMobile ? 40 : 56,
                        columns: [
                          const DataColumn(label: Text('Heures')),
                          ..._days.map((day) => DataColumn(
                                label: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                        ],
                        rows: _buildScheduleRows(isMobile),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Légende
                _buildLegend(isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _buildScheduleRows(bool isMobile) {
    return _hours.map((hour) {
      return DataRow(
        cells: [
          DataCell(Text(
            hour,
            style: TextStyle(fontSize: isMobile ? 12 : 14),
          )),
          ..._days.map((day) => _buildScheduleCell(day, hour, isMobile)),
        ],
      );
    }).toList();
  }

  DataCell _buildScheduleCell(String day, String hour, bool isMobile) {
    // Simuler des cours
    if (day == 'Lundi' && hour == '08:00') {
      return _buildClassCell('Mathématiques', 'M. Dupont', Colors.blue, isMobile);
    }
    if (day == 'Mardi' && hour == '10:00') {
      return _buildClassCell('Français', 'Mme Martin', Colors.green, isMobile);
    }
    if (day == 'Mercredi' && hour == '14:00') {
      return _buildClassCell('Anglais', 'M. Smith', Colors.orange, isMobile);
    }
    return const DataCell(Text(''));
  }

  DataCell _buildClassCell(String subject, String teacher, Color color, bool isMobile) {
    return DataCell(
      Container(
        padding: EdgeInsets.all(isMobile ? 4 : 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: isMobile ? 11 : 14,
              ),
            ),
            Text(
              teacher,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(bool isMobile) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Légende',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildLegendItem('Mathématiques', Colors.blue, isMobile),
                _buildLegendItem('Français', Colors.green, isMobile),
                _buildLegendItem('Anglais', Colors.orange, isMobile),
                _buildLegendItem('Histoire-Géo', Colors.purple, isMobile),
                _buildLegendItem('SVT', Colors.red, isMobile),
                _buildLegendItem('Physique-Chimie', Colors.teal, isMobile),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isMobile ? 14 : 16,
          height: isMobile ? 14 : 16,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: isMobile ? 12 : 14),
        ),
      ],
    );
  }
}

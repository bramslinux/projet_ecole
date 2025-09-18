import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  String _selectedPeriod = 'Trimestre 1';
  final List<String> _periods = ['Trimestre 1', 'Trimestre 2', 'Trimestre 3'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Notes',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
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
                  _buildGradesTable(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAverageCard(),
        ],
      ),
    );
  }

  Widget _buildGradesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Matière')),
          DataColumn(label: Text('Devoir 1')),
          DataColumn(label: Text('Devoir 2')),
          DataColumn(label: Text('Composition')),
          DataColumn(label: Text('Moyenne')),
          DataColumn(label: Text('Coef')),
          DataColumn(label: Text('Moy × Coef')),
        ],
        rows: [
          _buildGradeRow('Mathématiques', 15, 14, 16, 4),
          _buildGradeRow('Français', 12, 13, 14, 3),
          _buildGradeRow('Anglais', 16, 15, 17, 2),
          _buildGradeRow('Histoire-Géo', 13, 14, 15, 2),
          _buildGradeRow('SVT', 14, 15, 16, 2),
        ],
      ),
    );
  }

  DataRow _buildGradeRow(
    String subject,
    double grade1,
    double grade2,
    double exam,
    int coefficient,
  ) {
    double average = (grade1 + grade2 + (2 * exam)) / 4;
    double weightedAverage = average * coefficient;

    return DataRow(
      cells: [
        DataCell(Text(subject)),
        DataCell(Text(grade1.toString())),
        DataCell(Text(grade2.toString())),
        DataCell(Text(exam.toString())),
        DataCell(Text(average.toStringAsFixed(2))),
        DataCell(Text(coefficient.toString())),
        DataCell(Text(weightedAverage.toStringAsFixed(2))),
      ],
    );
  }

  Widget _buildAverageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Récapitulatif',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAverageItem(
                  'Moyenne Générale',
                  '14.52',
                  Colors.green,
                ),
                _buildAverageItem(
                  'Rang',
                  '5/32',
                  Colors.orange,
                ),
                _buildAverageItem(
                  'Mention',
                  'Bien',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

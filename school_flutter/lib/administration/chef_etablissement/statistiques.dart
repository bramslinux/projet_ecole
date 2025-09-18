import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatistiquesPage extends StatefulWidget {
  const StatistiquesPage({super.key});

  @override
  State<StatistiquesPage> createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
  String _selectedPeriode = 'Année scolaire 2024-2025';
  String _selectedNiveau = 'Tous les niveaux';

  // Example data
  final Map<String, double> _tauxReussite = {
    '6ème': 85,
    '5ème': 78,
    '4ème': 82,
    '3ème': 88,
  };

  final Map<String, int> _effectifsParClasse = {
    '6ème A': 35,
    '6ème B': 32,
    '5ème A': 30,
    '5ème B': 33,
    '4ème A': 28,
    '4ème B': 31,
    '3ème A': 34,
    '3ème B': 29,
  };

  final List<Map<String, dynamic>> _tendances = [
    {'mois': 'Sep', 'reussite': 75, 'presence': 95},
    {'mois': 'Oct', 'reussite': 78, 'presence': 93},
    {'mois': 'Nov', 'reussite': 80, 'presence': 94},
    {'mois': 'Dec', 'reussite': 82, 'presence': 92},
    {'mois': 'Jan', 'reussite': 79, 'presence': 91},
    {'mois': 'Fev', 'reussite': 83, 'presence': 93},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Export statistics
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriode,
                    decoration: const InputDecoration(
                      labelText: 'Période',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Année scolaire 2024-2025',
                        child: Text('Année scolaire 2024-2025'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriode = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedNiveau,
                    decoration: const InputDecoration(
                      labelText: 'Niveau',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Tous les niveaux',
                        child: Text('Tous les niveaux'),
                      ),
                      DropdownMenuItem(
                        value: '6ème',
                        child: Text('6ème'),
                      ),
                      DropdownMenuItem(
                        value: '5ème',
                        child: Text('5ème'),
                      ),
                      DropdownMenuItem(
                        value: '4ème',
                        child: Text('4ème'),
                      ),
                      DropdownMenuItem(
                        value: '3ème',
                        child: Text('3ème'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedNiveau = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics grid
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Quick stats
                    Row(
                      children: [
                        _buildStatCard(
                          'Taux de réussite global',
                          '82%',
                          Icons.school,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Effectif total',
                          '252',
                          Icons.group,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Taux de présence',
                          '93%',
                          Icons.check_circle,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Moyenne générale',
                          '13.5/20',
                          Icons.grade,
                          Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Charts row
                    Row(
                      children: [
                        // Success rate by level
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Taux de réussite par niveau',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 200,
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceAround,
                                        maxY: 100,
                                        barGroups: _tauxReussite.entries.map((e) {
                                          return BarChartGroupData(
                                            x: _tauxReussite.keys.toList().indexOf(e.key),
                                            barRods: [
                                              BarChartRodData(
                                                toY: e.value,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  _tauxReussite.keys.toList()[value.toInt()],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Class size distribution
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Effectifs par classe',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 200,
                                    child: PieChart(
                                      PieChartData(
                                        sections: _effectifsParClasse.entries.map((e) {
                                          return PieChartSectionData(
                                            value: e.value.toDouble(),
                                            title: '${e.key}\n${e.value}',
                                            radius: 50,
                                            titleStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Trends chart
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tendances',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    // Success rate line
                                    LineChartBarData(
                                      spots: _tendances.asMap().entries.map((e) {
                                        return FlSpot(
                                          e.key.toDouble(),
                                          e.value['reussite'].toDouble(),
                                        );
                                      }).toList(),
                                      isCurved: true,
                                      color: Colors.blue,
                                      dotData: FlDotData(show: false),
                                    ),
                                    // Attendance rate line
                                    LineChartBarData(
                                      spots: _tendances.asMap().entries.map((e) {
                                        return FlSpot(
                                          e.key.toDouble(),
                                          e.value['presence'].toDouble(),
                                        );
                                      }).toList(),
                                      isCurved: true,
                                      color: Colors.green,
                                      dotData: FlDotData(show: false),
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          if (value.toInt() >= 0 && 
                                              value.toInt() < _tendances.length) {
                                            return Text(
                                              _tendances[value.toInt()]['mois'],
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildLegendItem('Taux de réussite', Colors.blue),
                                const SizedBox(width: 24),
                                _buildLegendItem('Taux de présence', Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

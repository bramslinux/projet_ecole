import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationEtablissementsPage extends StatefulWidget {
  const LocalisationEtablissementsPage({super.key});

  @override
  State<LocalisationEtablissementsPage> createState() => _LocalisationEtablissementsPageState();
}

class _LocalisationEtablissementsPageState extends State<LocalisationEtablissementsPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String _selectedFiltre = 'Tous';

  // Example data
  final List<Map<String, dynamic>> _etablissements = [
    {
      'id': '1',
      'nom': 'École Primaire Saint-Jean',
      'adresse': '123 Rue des Écoles',
      'type': 'Primaire',
      'position': const LatLng(36.7528, 3.0422),
      'rating': 4.5,
      'places': 120,
      'inscriptions': 98,
    },
    {
      'id': '2',
      'nom': 'Collège Notre-Dame',
      'adresse': '456 Boulevard Principal',
      'type': 'Collège',
      'position': const LatLng(36.7538, 3.0432),
      'rating': 4.2,
      'places': 200,
      'inscriptions': 185,
    },
    // Add more example data
  ];

  final List<String> _filtres = [
    'Tous',
    'Primaire',
    'Collège',
    'Lycée',
    'Places disponibles',
    'Mieux notés',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    for (var etablissement in _etablissements) {
      _markers.add(
        Marker(
          markerId: MarkerId(etablissement['id']),
          position: etablissement['position'],
          infoWindow: InfoWindow(
            title: etablissement['nom'],
            snippet: etablissement['adresse'],
          ),
          onTap: () => _showEtablissementDetails(etablissement),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation des Établissements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // TODO: Center map on user location
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left panel - List of establishments
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Search and filter
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un établissement...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          // TODO: Filter establishments
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedFiltre,
                        decoration: const InputDecoration(
                          labelText: 'Filtrer par',
                          border: OutlineInputBorder(),
                        ),
                        items: _filtres.map((filtre) {
                          return DropdownMenuItem(
                            value: filtre,
                            child: Text(filtre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFiltre = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // List of establishments
                Expanded(
                  child: ListView.builder(
                    itemCount: _etablissements.length,
                    itemBuilder: (context, index) {
                      final etablissement = _etablissements[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(etablissement['type'][0]),
                          ),
                          title: Text(etablissement['nom']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(etablissement['adresse']),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: Colors.amber[600]),
                                  Text(' ${etablissement['rating']}'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.people, size: 16, color: Colors.blue[600]),
                                  Text(' ${etablissement['inscriptions']}/${etablissement['places']}'),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                etablissement['position'],
                                15,
                              ),
                            );
                            _showEtablissementDetails(etablissement);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right panel - Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.7528, 3.0422),
                zoom: 13,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new establishment
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  void _showEtablissementDetails(Map<String, dynamic> etablissement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(etablissement['nom']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${etablissement['type']}'),
            const SizedBox(height: 8),
            Text('Adresse: ${etablissement['adresse']}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[600]),
                Text(' ${etablissement['rating']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, color: Colors.blue[600]),
                Text(' Places: ${etablissement['inscriptions']}/${etablissement['places']}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Services:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildServiceChip('Cantine'),
                _buildServiceChip('Transport'),
                _buildServiceChip('Activités parascolaires'),
                _buildServiceChip('Bibliothèque'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to establishment details or registration
              Navigator.pop(context);
            },
            child: const Text('Plus de détails'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String label) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.check, size: 16),
      backgroundColor: Colors.green[100],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

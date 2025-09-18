import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class MatiereService {
  static Future<List<Map<String, dynamic>>> getAllMatieres() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/matieres/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Erreur lors de la récupération des matières: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<Map<String, dynamic>> createMatiere(Map<String, dynamic> matiere) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/matieres/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(matiere),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de la création de la matière: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<void> deleteMatiere(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/matieres/$id/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de la matière: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<Map<String, dynamic>> updateMatiere(int id, Map<String, dynamic> matiere) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/matieres/$id/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(matiere),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur lors de la mise à jour de la matière: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }
}

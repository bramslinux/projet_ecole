import 'package:flutter/material.dart';
import 'package:school_flutter/administration/parent/parent_bashbord.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Ici tu appelleras ton API de paiement
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Après paiement réussi, redirection vers le dashboard
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return 'Numéro de carte requis';
    if (value.replaceAll(' ', '').length != 16) return 'Numéro invalide';
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) return 'Date d\'expiration requise';
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return 'Format MM/AA';
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) return 'CVV requis';
    if (value.length != 3) return 'CVV invalide';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement par Carte'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Numéro de carte',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Date d\'expiration (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateExpiry,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCVV,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Payer'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

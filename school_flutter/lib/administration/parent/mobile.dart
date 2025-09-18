import 'package:flutter/material.dart';
import 'package:school_flutter/administration/parent/parent_bashbord.dart';

class MobileMoneyPaymentScreen extends StatefulWidget {
  const MobileMoneyPaymentScreen({super.key});

  @override
  State<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState extends State<MobileMoneyPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final double _fixedAmount = 1500;
  bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Numéro requis';
    if (!RegExp(r'^([0-9]{7,8}|7[0-9]{7,8})$').hasMatch(value)) {
      return 'Numéro invalide (ex: 70123456)';
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return 'Code OTP requis';
    if (value.length < 4) return 'Code OTP trop court';
    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 👉 Simulation appel API Playdia pour envoyer OTP
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _otpSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code OTP envoyé par Playdia")),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 👉 Simulation appel API Playdia pour valider OTP et paiement
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paiement réussi ")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement Mobile Money'),
        backgroundColor: const Color.fromARGB(255, 76, 127, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Numéro de téléphone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Numéro Mobile Money',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
                enabled: !_otpSent, // désactiver après envoi OTP
              ),
              const SizedBox(height: 16),

              // Montant fixe
              TextFormField(
                initialValue: "1500",
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Montant (FCFA)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Champ OTP (affiché après envoi)
              if (_otpSent)
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Code OTP',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateOtp,
                ),

              const SizedBox(height: 32),

              // Bouton d’action
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _otpSent
                        ? _processPayment
                        : _sendOtp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 76, 122, 175),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_otpSent ? 'Valider Paiement' : 'Envoyer OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

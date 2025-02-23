import 'package:flutter/material.dart';
import 'package:password_manager/biometric/biometric_auth_service.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final biometricService = BiometricAuthService();

  Future<void> _authenticateUser() async {
    final isAvaliable = await biometricService.isBiometricAvailable();
    if(!isAvaliable) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      return;
    }
    bool isAuthenticated = await biometricService.authenticate();
    if (isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: _authenticateUser,
            child: Text("Tentar novamente")),
      ),
    );
  }
}

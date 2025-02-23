import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:password_manager/credential/credential_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final syncCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _scanned = false;

  _validateForm() {
    if (!_formKey.currentState!.validate()) {
      _formKey.currentState!.activate();
      return;
    }
    connectAndSend('ws://${syncCodeController.text}:8080');
    Navigator.pop(context);
  }

  void connectAndSend(String url) async {
    if (_scanned) {
      return;
    }
    _scanned = true;
    try {
      final channel = WebSocketChannel.connect(Uri.parse(url));
      final credentialList = await CredentialStorage.getCredentials();
      final credentialJson = jsonEncode(credentialList);
      channel.sink.add(credentialJson);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Credenciais enviadas com sucesso!")));
      Navigator.pop(context);
    } catch (e) {
      print("Erro ao conectar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Informar o Código"),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: syncCodeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Informe o código";
                        }
                        return null;
                      },
                      decoration:
                          InputDecoration(labelText: "Código de sincronização"),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge),
                      child: const Text("Cancelar"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge),
                      onPressed: () => _validateForm(),
                      child: const Text("Enviar"),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.code)),
      appBar: AppBar(
          title: Text("Escanear QR Code")),
      body: Platform.isWindows
          ? Container()
          : MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  String scannedData = barcodes.first.rawValue ?? '';
                  connectAndSend(scannedData);
                }
              },
            ),
    );
  }
}

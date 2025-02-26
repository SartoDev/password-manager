import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/credential/credential_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../credential/credential.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<QrCodeScreen> {
  HttpServer? server;
  String? qrData;
  String? syncCode;
  WebSocketChannel? connectedChannel;

  @override
  void initState() {
    super.initState();
    startServer();
  }

  Future<String?> getLocalIp() async {
    String? ip;
    try {
      var interfaces = await NetworkInterface.list();

      for (var interface in interfaces) {
        if (interface.name.contains("Wi-Fi") ||
            interface.name.contains("Ethernet")) {
          for (var addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 &&
                !addr.address.startsWith('127')) {
              ip = addr.address;
              break;
            }
          }
        }
      }
    } catch (e) {
      Exception(e);
    }
    return ip ?? "IP não encontrado";
  }

  void startServer() async {
    var handler =
        webSocketHandler((WebSocketChannel channel, String? protocol) {
      connectedChannel = channel;
      channel.stream.listen((message) async {
        final credentialList = jsonDecode(message);
        final actualCredentialList = await CredentialStorage.getCredentials();
        for (final credential in credentialList) {
          final foundCredential = actualCredentialList.where(
              (element) => element.id == credential["id"]);
          if (foundCredential.isNotEmpty) {
            continue;
          }
          await CredentialStorage.addCredential(
              Credential.fromJson(credential));
        }
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text("Credenciais recebidas com sucesso!")));
        }
      });
    });

    var ip = (await NetworkInterface.list())
        .expand((interface) => interface.addresses)
        .firstWhere((addr) => addr.type == InternetAddressType.IPv4)
        .address;

    if (Platform.isWindows) {
      ip = await getLocalIp() ?? "";
    }

    server = await io.serve(handler, InternetAddress.anyIPv4, 8080);

    setState(() {
      qrData = 'ws://$ip:8080';
      syncCode = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qr code")),
      body: Center(
        child: qrData == null && syncCode == null
            ? CircularProgressIndicator()
            : Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(data: qrData!, size: 200),
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Código de sincronização: ${syncCode!}"),
                          IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: syncCode!));
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Código copiado para a área de transferência!"),
                                    backgroundColor: Colors.green));
                              })
                        ],
                      )),
                  Text(
                      "Escaneie o QR Code ou envie o código de sincronização para compartilhar suas credenciais!",
                      textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    server?.close();
    super.dispose();
  }
}

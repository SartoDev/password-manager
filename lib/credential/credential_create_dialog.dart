// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:password_manager/credential/credential.dart';
// import 'package:password_manager/credential/credential_storage.dart';
//
// class CredentialCreateDialog extends StatelessWidget {
//   final loginController = TextEditingController();
//   final passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   var credentialPlatform = CredentialPlatform.google;
//
//   CredentialCreateDialog({super.key});
//
//   String _generatePassword({int length = 12}) {
//     const chars =
//         "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()";
//     final random = Random();
//     return List.generate(length, (index) => chars[random.nextInt(chars.length)])
//         .join();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Armazene suas credenciais"),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: loginController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return "Informe o login";
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Digite o login"),
//             ),
//             SizedBox(height: 15),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Informe a senha";
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: "Digite a senha"),
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       final randomPassword = _generatePassword();
//                       passwordController.text = randomPassword;
//                     },
//                     icon: Icon(Icons.generating_tokens))
//               ],
//             ),
//             SizedBox(height: 15),
//             DropdownMenu(
//                 onSelected: (CredentialPlatform? platform) {
//                   if (platform != null) {
//                     credentialPlatform = platform;
//                   }
//                 },
//                 width: 230,
//                 initialSelection: credentialPlatform,
//                 menuHeight: 180,
//                 label: const Text("Plataforma"),
//                 dropdownMenuEntries: CredentialPlatform.entries),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           style: TextButton.styleFrom(
//               textStyle: Theme.of(context).textTheme.labelLarge),
//           child: const Text("Cancelar"),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(
//               textStyle: Theme.of(context).textTheme.labelLarge),
//           child: const Text("Guardar"),
//           onPressed: () async {
//             if (!formKey.currentState!.validate()) {
//               formKey.currentState!.activate();
//               return;
//             }
//
//             final credential = Credential(
//                 login: loginController.text,
//                 password: passwordController.text,
//                 platform: credentialPlatform);
//
//             await CredentialStorage.addCredential(credential);
//
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: Text("Credencial criada com sucesso!"),
//                 backgroundColor: Colors.green));
//
//             setState(() {
//               _futureCredentialList = CredentialStorage.getCredentials();
//               Navigator.of(context).pop();
//             });
//           },
//         ),
//       ],
//     );
//   }
// }

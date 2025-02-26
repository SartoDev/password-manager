import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:password_manager/credential/credential.dart';
import 'package:password_manager/credential/credential_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var showDeleteCredential = false;
  var deleteCredentialList = [];
  late Future<List<Credential>> _futureCredentialList;
  var showSearchField = false;

  @override
  void initState() {
    _futureCredentialList = CredentialStorage.getCredentials();
    super.initState();
  }

  _updateCredentialList() {
    setState(() {
      _futureCredentialList = CredentialStorage.getCredentials();
    });
  }

  _findByLogin(String login) {
    setState(() {
      _futureCredentialList = CredentialStorage.findByLogin(login);
    });
  }

  String generatePassword({int length = 12}) {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()";
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          overlayStyle: ExpandableFabOverlayStyle(color: Colors.black54),
          type: ExpandableFabType.up,
          distance: 70,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.menu),
            fabSize: ExpandableFabSize.regular,
          ),
          closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.regular,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.primary),
          children: [
            FloatingActionButton(
                heroTag: null,
                onPressed: () => _createDialog(context),
                child: Icon(Icons.add)),
            FloatingActionButton(
                heroTag: null,
                onPressed: () => Navigator.pushNamed(context, "/scanner"),
                child: Icon(Icons.camera_alt)),
            FloatingActionButton(
                heroTag: null,
                onPressed: () => Navigator.pushNamed(context, "/qr-code")
                    .then((value) => _updateCredentialList()),
                child: Icon(Icons.qr_code)),
          ],
        ),
        appBar: AppBar(
          title: showSearchField
              ? TextField(
                  onChanged: (value) {
                    _findByLogin(value);
                  },
                  decoration:
                      InputDecoration(hintText: "Busque por uma credencial..."),
                )
              : Text("Senhas"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => setState(() {
                      showSearchField = !showSearchField;
                    }),
                icon: Icon(showSearchField ? Icons.close : Icons.search)),
            if (showDeleteCredential)
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    showDeleteCredential = false;
                    deleteCredentialList = [];
                    _updateCredentialList();
                  }),
            if (showDeleteCredential)
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final results = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Excluir suas credenciais"),
                          content: Text(
                              "Tem certeza que deseja apagar todas essas credenciais?\nEsta ação não poderá ser desfeita!",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge),
                              child: const Text("Não"),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge),
                              child: const Text("Sim"),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        );
                      },
                    );
                    if (!results) {
                      return;
                    }
                    for (var element in deleteCredentialList) {
                      await CredentialStorage.deleteCredential(element.id!);
                    }
                    showDeleteCredential = false;
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Credenciais removidas com sucesso!"),
                        backgroundColor: Colors.green));
                    _updateCredentialList();
                  }),
          ],
        ),
        body: FutureBuilder(
            future: _futureCredentialList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final credentialList = snapshot.data as List<Credential>;

                return ListView.builder(
                  itemCount: credentialList.length,
                  itemBuilder: (context, index) {
                    final credential = credentialList[index];

                    return InkWell(
                      onLongPress: () => setState(() {
                        credential.selected = !credential.selected;
                        if (credential.selected) {
                          deleteCredentialList.add(credential);
                        } else {
                          deleteCredentialList.remove(credential);
                        }
                        showDeleteCredential = credentialList
                            .any((credential) => credential.selected == true);
                      }),
                      onTap: () => setState(() {
                        if(!showDeleteCredential) {
                          return;
                        }
                        credential.selected = !credential.selected;
                        if (credential.selected) {
                          deleteCredentialList.add(credential);
                        } else {
                          deleteCredentialList.remove(credential);
                        }
                        showDeleteCredential = credentialList
                            .any((credential) => credential.selected == true);
                      }),
                      child: ListTile(
                        title: Text(credential.login),
                        subtitle: Text(credential.showPassword
                            ? credential.password
                            : ("*") * credential.password.length),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showDeleteCredential)
                              Checkbox(
                                  value: credential.selected,
                                  onChanged: (value) => setState(() {
                                        credential.selected = value!;
                                        if (credential.selected) {
                                          deleteCredentialList.add(credential);
                                        } else {
                                          deleteCredentialList
                                              .remove(credential);
                                        }
                                        showDeleteCredential =
                                            credentialList.any((credential) =>
                                                credential.selected == true);
                                      })),
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            credential.platform.image))))
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (Platform.isWindows) ...[
                              IconButton(
                                  onPressed: () => setState(() {
                                        credential.showPassword =
                                            !credential.showPassword;
                                      }),
                                  icon: credential.showPassword
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: credential.password));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Senha copiada para a área de transferência!"),
                                            backgroundColor: Colors.green));
                                  },
                                  icon: Icon(Icons.copy)),
                              IconButton(
                                  onPressed: () =>
                                      _updateDialog(context, credential),
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await CredentialStorage.deleteCredential(
                                        credential.id!);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Credencial removida com sucesso!"),
                                            backgroundColor: Colors.green));
                                    setState(() {
                                      _futureCredentialList =
                                          CredentialStorage.getCredentials();
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red)),
                            ],
                            if (Platform.isAndroid)
                              MenuAnchor(
                                builder: (BuildContext context,
                                    MenuController controller, Widget? child) {
                                  return IconButton(
                                    onPressed: () {
                                      if (controller.isOpen) {
                                        controller.close();
                                      } else {
                                        controller.open();
                                      }
                                    },
                                    icon: const Icon(Icons.more_vert),
                                    tooltip: 'Show menu',
                                  );
                                },
                                menuChildren: [
                                  MenuItemButton(
                                    onPressed: () => setState(() {
                                      credential.showPassword =
                                          !credential.showPassword;
                                    }),
                                    child: Text(credential.showPassword ? "Esconder Senha" : "Visualizar Senha"),
                                  ),
                                  MenuItemButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: credential.password));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Senha copiada para a área de transferência!"),
                                              backgroundColor: Colors.green));
                                    },
                                    child: Text('Copiar Senha'),
                                  ),
                                  MenuItemButton(
                                    onPressed: () =>
                                        _updateDialog(context, credential),
                                    child: Text('Editar Credencial'),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Future<void> _createDialog(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var credentialPlatform = CredentialPlatform.google;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Armazene suas credenciais"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: loginController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o login";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Digite o login"),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe a senha";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Digite a senha"),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          final randomPassword = generatePassword();
                          passwordController.text = randomPassword;
                        },
                        icon: Icon(Icons.generating_tokens))
                  ],
                ),
                SizedBox(height: 15),
                DropdownMenu(
                    onSelected: (CredentialPlatform? platform) {
                      setState(() {
                        if (platform != null) {
                          credentialPlatform = platform;
                        }
                      });
                    },
                    width: 230,
                    initialSelection: credentialPlatform,
                    menuHeight: 180,
                    label: const Text("Plataforma"),
                    dropdownMenuEntries: CredentialPlatform.entries),
              ],
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
              child: const Text("Guardar"),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  formKey.currentState!.activate();
                  return;
                }

                final credential = Credential(
                    login: loginController.text,
                    password: passwordController.text,
                    platform: credentialPlatform);

                await CredentialStorage.addCredential(credential);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Credencial criada com sucesso!"),
                    backgroundColor: Colors.green));

                Navigator.of(context).pop();
                _updateCredentialList();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDialog(BuildContext context, Credential credential) {
    final loginController = TextEditingController(text: credential.login);
    final passwordController = TextEditingController(text: credential.password);
    final formKey = GlobalKey<FormState>();
    var credentialPlatform = credential.platform;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atualize suas credenciais"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: loginController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe o login";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Digite o login"),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Informe a senha";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Digite a senha"),
                ),
                SizedBox(height: 15),
                DropdownMenu(
                    onSelected: (CredentialPlatform? platform) {
                      setState(() {
                        if (platform != null) {
                          credentialPlatform = platform;
                        }
                      });
                    },
                    width: 230,
                    initialSelection: credentialPlatform,
                    menuHeight: 180,
                    label: const Text("Plataforma"),
                    dropdownMenuEntries: CredentialPlatform.entries),
              ],
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
              child: const Text("Atualizar"),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  formKey.currentState!.activate();
                  return;
                }
                final newCredential = Credential(
                    id: credential.id,
                    login: loginController.text,
                    password: passwordController.text,
                    platform: credentialPlatform);
                await CredentialStorage.updateCredential(newCredential);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Credencial atualizada com sucesso!"),
                    backgroundColor: Colors.green));

                Navigator.of(context).pop();
                _updateCredentialList();
              },
            ),
          ],
        );
      },
    );
  }
}

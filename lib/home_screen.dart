import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:password_manager/credential/credential.dart';
import 'package:password_manager/credential/credential_storage.dart';
import 'package:password_manager/tutorial/tutorial_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  final List<TargetFocus> _targets = [];
  final _keyEditCredential = GlobalKey();
  final _keyUpdateCredential = GlobalKey();
  final _keyShowPassword = GlobalKey();
  final _keySelectCredentials = GlobalKey();
  final _keyDeleteCredentials = GlobalKey();
  final _keyConfirmDeleteCredentials = GlobalKey();
  List<Credential> tutorialCredentialList = [
    Credential(
        login: "Credencial tutorial",
        password: "Senha tutorial",
        platform: CredentialPlatform.google),
    Credential(
        login: "Credencial tutorial",
        password: "Senha tutorial",
        platform: CredentialPlatform.facebook),
    Credential(
        login: "Credencial tutorial",
        password: "Senha tutorial",
        platform: CredentialPlatform.twitter),
    Credential(
        login: "Credencial tutorial",
        password: "Senha tutorial",
        platform: CredentialPlatform.instagram)
  ];
  final _listKeySelectCredentials = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  late TutorialCoachMark _tutorialCoachMark;
  var tutorial = true;

  void _showTutorial() async {
    final seenTutorial = await TutorialStorage.getSeenTutorial();
    if(seenTutorial) {
      tutorial = false;
      return;
    }
    _tutorialCoachMark = TutorialCoachMark(
        targets: _targets,
        colorShadow: Colors.black54,
        textSkip: "Pular",
        onFinish: () {
          setState(() {
            tutorial = false;
            TutorialStorage.saveSeenTutorial(true);
          });
        },
        onClickTargetWithTapPosition: (target, tapDetails) async {
          final currentWidget = target.keyTarget?.currentWidget;
          if (currentWidget.runtimeType == InkWell) {
            final inkWell = currentWidget as InkWell;
            inkWell.onTap!();
          }
          if (currentWidget.runtimeType == IconButton) {
            final iconButton = currentWidget as IconButton;
            iconButton.onPressed!();
          }
          if (currentWidget.runtimeType == TextButton) {
            final textButton = currentWidget as TextButton;
            textButton.onPressed!();
          }
          if (currentWidget.runtimeType == ListView) {
            for (var element in _listKeySelectCredentials) {
              final inkWell = element.currentWidget! as InkWell;
              inkWell.onLongPress!();
            }
          }
        },
        onClickTarget: (target) {
        },
        onSkip: () {
          return true;
        })
      ..show(context: context);
  }

  @override
  void initState() {
    _futureCredentialList = CredentialStorage.getCredentials();
    _targets.add(TargetFocus(
        identify: "Target 1",
        keyTarget: _listKeySelectCredentials[0],
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Copiar senha",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Para copiar a senha pressione em uma credencial",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
        ]));

    _targets.add(TargetFocus(
        identify: "Target 2",
        keyTarget: _keyShowPassword,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Visualizar senha",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Pressione no botão de visualização para exibir a senha",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )),
        ]));

    _targets.add(TargetFocus(
        identify: "Target 3",
        keyTarget: _keyEditCredential,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Editar credencial",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Pressione no botão de editar para editar a credencial.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ]));

    _targets.add(TargetFocus(
        identify: "Target 4",
        keyTarget: _keyUpdateCredential,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Atualizar credencial",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Confirme a atualização da credencial.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ]));

    _targets.add(TargetFocus(
        identify: "Target 5",
        keyTarget: _keySelectCredentials,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Selecionar credenciais",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Text(
                    "Para selecionar uma credencial pressione e segure em uma credencial",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ))
        ]));

    _targets.add(TargetFocus(
        identify: "Target 6",
        keyTarget: _keyDeleteCredentials,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Apagar credenciais",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Text(
                    "Para apagar todas as credenciais selecionadas, pressione no botão de exclusão",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ))
        ]));

    _targets.add(TargetFocus(
        identify: "Target 7",
        keyTarget: _keyConfirmDeleteCredentials,
        contents: [
          TargetContent(
              align: ContentAlign.left,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Confirmar exclusão",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Text(
                    "Confirme a exclusão das credenciais",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ))
        ]));
    _showTutorial();
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
            if (!showDeleteCredential)
              IconButton(
                  onPressed: () => setState(() {
                        showSearchField = !showSearchField;
                      }),
                  icon: Icon(showSearchField ? Icons.close : Icons.search)),
            if (showDeleteCredential) ...[
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    showDeleteCredential = false;
                    deleteCredentialList = [];
                    _updateCredentialList();
                  }),
              IconButton(
                  key: _keyDeleteCredentials,
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    if (tutorial) {
                      _tutorialCoachMark.next();
                    }
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
                              key: _keyConfirmDeleteCredentials,
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Credenciais removidas com sucesso!"),
                        backgroundColor: Colors.green));
                    showDeleteCredential = false;
                    if (tutorial) {
                      setState(() {
                        tutorialCredentialList = [];
                      });
                      _tutorialCoachMark.finish();
                      return;
                    }
                    for (var element in deleteCredentialList) {
                      await CredentialStorage.deleteCredential(element.id!);
                    }
                    _updateCredentialList();
                  })
            ]
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return FutureBuilder(
              future: _futureCredentialList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final credentialList = snapshot.data as List<Credential>;

                  return SizedBox(
                    height: (constraints.maxHeight * 0.11) *
                        (tutorial
                            ? tutorialCredentialList.length
                            : credentialList.length),
                    child: ListView.builder(
                      key: _keySelectCredentials,
                      itemCount: tutorial
                          ? tutorialCredentialList.length
                          : credentialList.length,
                      itemBuilder: (context, index) {
                        Credential credential;

                        if (tutorial) {
                          credential = tutorialCredentialList[index];
                        } else {
                          credential = credentialList[index];
                        }

                        return InkWell(
                          key: tutorial
                              ? _listKeySelectCredentials[index]
                              : null,
                          onLongPress: () => setState(() {
                            credential.selected = !credential.selected;
                            if (tutorial) {
                              showDeleteCredential = true;
                              return;
                            }
                            if (credential.selected) {
                              deleteCredentialList.add(credential);
                            } else {
                              deleteCredentialList.remove(credential);
                            }
                            showDeleteCredential = credentialList.any(
                                (credential) => credential.selected == true);
                          }),
                          onTap: () => setState(() {
                            if (!showDeleteCredential) {
                              Clipboard.setData(
                                  ClipboardData(text: credential.password));
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Senha copiada para a área de transferência!"),
                                  backgroundColor: Colors.green));
                              return;
                            } else if(!showDeleteCredential) {
                              return;
                            }
                            credential.selected = !credential.selected;
                            if (credential.selected) {
                              deleteCredentialList.add(credential);
                            } else {
                              deleteCredentialList.remove(credential);
                            }
                            showDeleteCredential = credentialList.any(
                                (credential) => credential.selected == true);
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
                                              deleteCredentialList
                                                  .add(credential);
                                            } else {
                                              deleteCredentialList
                                                  .remove(credential);
                                            }
                                            showDeleteCredential =
                                                credentialList.any(
                                                    (credential) =>
                                                        credential.selected ==
                                                        true);
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
                            trailing: showDeleteCredential
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: IconButton(
                                            key: index == 0
                                                ? _keyShowPassword
                                                : null,
                                            onPressed: () => setState(() {
                                              credential.showPassword =
                                              !credential
                                                  .showPassword;
                                            }),
                                            icon: credential.showPassword
                                                ? Icon(Icons.visibility_off)
                                                : Icon(Icons.visibility)),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: IconButton(
                                            key: index == 0
                                                ? _keyEditCredential
                                                : null,
                                            onPressed: () => _updateDialog(
                                                context, credential),
                                            icon: Icon(Icons.edit)),
                                      )
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              });
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
    if (tutorial) {
      _tutorialCoachMark.next();
    }

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
              key: _keyUpdateCredential,
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text("Atualizar"),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  formKey.currentState!.activate();
                  return;
                }
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Credencial atualizada com sucesso!"),
                    backgroundColor: Colors.green));
                Navigator.of(context).pop();
                if (tutorial) {
                  _tutorialCoachMark.next();
                  return;
                }
                final updatedCredencial = Credential(
                    id: credential.id,
                    login: loginController.text,
                    password: passwordController.text,
                    platform: credentialPlatform);
                await CredentialStorage.updateCredential(updatedCredencial);
                _updateCredentialList();
              },
            ),
          ],
        );
      },
    );
  }
}

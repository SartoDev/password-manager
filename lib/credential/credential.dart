import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential.g.dart';

typedef CredentialEntry = DropdownMenuEntry<CredentialPlatform>;

enum CredentialPlatform {
  google("google", "Google", "assets/images/google-logo.png"),
  github("github", "Github", "assets/images/github-logo.png"),
  twitter("twitter", "Twitter", "assets/images/x-logo.png"),
  linkedin("linkedin", "Linkedin", "assets/images/linkedin-logo.png"),
  facebook("facebook", "Facebook", "assets/images/facebook-logo.png"),
  instagram("instagram", "Instagram", "assets/images/instagram-logo.png"),
  epicGames("epic_games", "Epic games", "assets/images/epic-games-logo.png"),
  riotGames("riot_games", "Riot games", "assets/images/riot-games-logo.png"),
  steam("steam", "Steam", "assets/images/steam-logo.png"),
  other("other", "Outras", "assets/images/logo.png");

  const CredentialPlatform(this.value, this.label, this.image);

  final String value;
  final String label;
  final String image;

  static final List<CredentialEntry> entries =
      UnmodifiableListView<CredentialEntry>(
    values.map<CredentialEntry>(
      (CredentialPlatform platform) => CredentialEntry(
          value: platform,
          label: platform.label,
          leadingIcon: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(platform.image))))),
    ),
  );
}

@JsonSerializable()
class Credential {
  final String? id;
  final String login;
  final String password;
  final CredentialPlatform platform;
  var selected = false;

  Credential(
      {this.id, required this.login, required this.password, required this.platform});

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialToJson(this);
}

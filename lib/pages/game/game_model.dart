import 'package:flutter/material.dart';

class GameTabItem {
  final String? gameName;
  final String? gameType;
  List<GameItem>? listData;

  GameTabItem(this.gameName, this.gameType, {this.listData});
}

class GameItem {
  String? name;
  String? gameId;
  String? icon;
  String? url;
  String? gameType;
  bool? isHot;
  GameItem(this.name, this.gameId,this.icon, this.isHot, [this.url, this.gameType]);
}

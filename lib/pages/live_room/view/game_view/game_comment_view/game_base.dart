import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:web_socket_channel/io.dart';

//  -----------------Web Soket----------------------------
typedef CallBackWebChannel = void Function(
    IOWebSocketChannel webSocketChannel, dynamic data);
typedef CallBackWebChannelError = void Function();
typedef CallBackWebChannelDone = void Function(
    IOWebSocketChannel webSocketChannel);

//  开奖记录和投注记录
typedef GameOpen = void Function(bool openOrColose, int sized);
typedef GameRecord = void Function(bool openOrColose, int index);
typedef GameInit = void Function();
typedef GameChangeSize = void Function(bool openOrColose);

class GameBase {
  static double height = 480.pt;
}

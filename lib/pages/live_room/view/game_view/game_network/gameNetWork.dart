// ignore_for_file: argument_type_not_assignable_to_error_handler

import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

import '../game_comment_view/game_base.dart';

class GameNetWork {
  static String _baseUrl = "http://192.168.0.124:8080/api/v1/game/";

  static dynamic getGame(String api, Map<String, dynamic> parameters) async {
    var options = BaseOptions();
    options.contentType = "application/json";
    options.method = "GET";
    options.headers["token"] =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6NjgzLCJLZXkiOiJlYjJnaWlQc0xrY3lLZVF2TFdtd3VaMVQ1Q1VjekZhZiJ9.n3GY8nf5ZrAdL9aW38_5Ra0OW036nOYuD41aHn7iqKg";
    // options.headers["sign"] = "1";
    options.connectTimeout = 30000;
    var dio = new Dio(options);
    var url = _baseUrl + api;
    var response = await dio.get(url, queryParameters: parameters);
    var data = response.data;
    var datas = _getBaseData(data);
    return datas;
  }

  static dynamic _getBaseData(dynamic data) {
    var codes = data["code"];
    var msg = data["msg"];
    var value = Map();
    switch (codes) {
      case 0:
        value = data["data"];
        break;
      case 10000:
        value = msg;
        break;
      case 10001:
        value = msg;
        break;
      default:
    }
    return value;
  }

  static initWebSoket(
      String id,
      String gameID,
      String sign,
      CallBackWebChannel callback,
      CallBackWebChannelDone done,
      CallBackWebChannelError error) async {
    var id = "bk8UHgdA9qfSHMVIEoTmQyZK70FWrvMC";
    var gameID = "1";
    var sign = "495ead21272e568cc60eaf2261644480";
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6MzA0ODY1LCJLZXkiOiIwMDBGOHZlWXQ5cmxXTjA2YzgzSzlkT1JZRmhiMnI3ZiJ9.H_hsNQ6D2nJ2rOJ1I_bu08ofHAqDFdu80E2smVWCh-g";
    var urls =
        'ws://192.168.0.124:8088/ws/websocket?id=$id&game_id=$gameID&sign=$sign&token=$token';
    var channel = IOWebSocketChannel.connect(Uri.parse(urls));
    channel.stream.listen((event) async {
      callback.call(channel, event);
    }, onDone: () {
      done.call(channel);
    }, onError: (e) {
      error.call();
    }, cancelOnError: true);
  }
}

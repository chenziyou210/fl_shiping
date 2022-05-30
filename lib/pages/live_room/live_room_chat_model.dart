/*
 *  Copyright (C), 2015-2021
 *  FileName: live_room_chat_model
 *  Author: Tonight丶相拥
 *  Date: 2021/7/28
 *  Description: 
 **/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart'
    show EventBus, givingGift, verifyRoomSuccess, winPrize, enterRoom;
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/live_room/live_room_enum.dart';
import 'package:hjnzb/pages/login/user_info_operation.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart' hide MessageType;
import 'dart:async';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:uuid/uuid.dart';
import '../../generated/im_room_account.dart';
import '../../generated/sample_user_info_entity.dart';
import '../../util_tool/crypto/xxtea.dart';
import 'mute_model.dart';
import 'package:get/get.dart';

class IMModel extends EMChatManagerListener with Toast, WidgetsBindingObserver {
  IMModel() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void Function()? _scrollPopToTop;
  void Function(int)? _coins;

  void setUp(void Function()? scroll, void Function(int)? coins) {
    this._scrollPopToTop = scroll;
    this._coins = coins;
    EventBus.instance.addListener(_onVerifyRoom, name: verifyRoomSuccess);
    EMClient.getInstance.chatManager.addChatManagerListener(this);
  }

  /// 聊天室
  // late EMChatRoom _room;
  String? _roomId;
  late AppInternational intl;

  /// 禁言模型
  MuteModel? _mute;

  /// 解除禁言倒计时
  Timer? _timer;

  /// 是否禁言
  bool _isMute = false;

  bool get isMute => _isMute1;
  bool _isMute1 = false;
  bool imCheckIng = false;

  /// 禁言截止时间
  String get muteUtil =>
      _mute!.startTime.add(Duration(minutes: _mute!.time)).toIso8601String();

  /// 设置禁言
  set mute(MuteModel m) {
    _mute = m;
    if (m.startTime.add(Duration(minutes: m.time)).isAfter(DateTime.now())) {
      _isMute = true;
      var d = m.startTime
          .add(Duration(minutes: _mute!.time))
          .difference(DateTime.now());
      _timer = Timer(d, () {
        _isMute = false;
      });
    }
  }

  set mute1(bool value) {
    _isMute1 = value;
  }

  final LiveRoomChatViewModel chats = LiveRoomChatViewModel();

  final String _key = "sds1LI2OW&E&%@kI&FCuy";
  final String _messageKey = "hjnTextMessage";

  /// 发送消息
  Future<void> sendText(String message,
      {TextType type: TextType.conversation,
      int? time,
      int? number,
      String? mutingId,
      String? roomId}) async {
    var t = chats._message.value.type;
    var x = chats._message.value.ex;
    String e = "";
    if (chats._message.value.ex is Map) {
      try {
        e = jsonEncode(x);
      } catch (_) {}
    }

    String? m = xxtea.encryptToString(message, _key);
    if (m == null || _isMute) {
      return;
    }
    if (roomId != null && roomId != _roomId) {
      return;
    }
    var user = AppManager.getInstance<AppUser>();
    var result = await EMClient.getInstance.chatManager.sendMessage(
        EMMessage.createCustomSendMessage(
            username: _roomId!,
            event: type.rawValue,
            params: {
          "id": user.userId ?? "",
          "level": user.rank?.toString() ?? "0",
          "hjnName": user.name ?? "",
          "number": number?.toString() ?? "1",
          "time": time?.toString() ?? "0",
          "message": m,
          "mutingId": mutingId ?? "",
          "type": t.rawValue,
          "extension": e
        })
          ..chatType = ChatType.ChatRoom);
    if (result.status == MessageStatus.FAIL) {
      var id = _roomId;
      _checkImStatus();
      sendText(message,
          type: type,
          time: time,
          number: number,
          mutingId: mutingId,
          roomId: id);
      return;
    }

    if (type == TextType.mute || type == TextType.muteCancel) return;
    chats.addChats(user.name ?? "", message, user.userId!,
        level: user.rank, number: number, type: type, messageType: t, ex: x);
    return;
  }

  // return HttpChannel.channel.announcementList(type).then((value) {
  // return value.finalize<WrapperModel>(
  // wrapper: WrapperModel(),
  // failure: (e)=> showToast(e),
  // success: (data) {
  // List lst = data ?? [];
  // _data.value = lst.map((e) => AnnouncementEntity.fromJson(e)).toList();
  // }
  // ).isSuccess;
  // });

  /// 获取聊天室
  Future<void> getRoom(String roomId) async {
    if((_roomId?.isNotEmpty ?? false) && _roomId!=roomId ){
      try {
        await EMClient.getInstance.chatRoomManager.leaveChatRoom(_roomId!);
      } on EMError catch (e) {
        debugPrint("error code: ${e.code}, desc: ${e.description}");
      }
    }
    _roomId = roomId;
    _getRoom(roomId);
  }

  Future<void> _getRoom(String roomId) async {
    if (_roomId != roomId) {
      return;
    }
    try {
      // var result = await EMClient.getInstance.chatRoomManager.getChatRoomWithId(roomId);
      // if (result.roomId == null ||  result.owner == null)
      _checkImStatus();
      var result = await EMClient.getInstance.chatRoomManager
          .fetchChatRoomInfoFromServer(roomId);
      if (result.roomId.isEmpty || result.owner == null) _getRoom(roomId);
    } catch (e) {
      print("");
    }
  }

  Future<void> _checkImStatus() async {
    if (imCheckIng) {
      return;
    }
    imCheckIng = true;
    var user = AppManager.getInstance<AppUser>();
    if (!await EMClient.getInstance.isLoginBefore()) {
      if ((user.hxPassword?.isEmpty ?? true) ||
          (user.hxAccount?.isEmpty ?? true)) {
        var result = await chatRoomAccount();
        user.userUpdateIM(result);
      }
      await EMClient.getInstance
          .login(user.hxAccount ?? "", user.hxPassword ?? "");
    }
    if (_roomId?.isEmpty ?? true) {
      return;
    }
    try {
      await EMClient.getInstance.chatRoomManager.joinChatRoom(_roomId!);
    } on EMError catch (e) {
      debugPrint("error code: ${e.code}, desc: ${e.description}");
    }
    imCheckIng = false;
  }

  /// 获取环信账号
  Future<IMRoomAccountEntity> chatRoomAccount([bool force = false]) async {
    return HttpChannel.channel.chatRoomAccount(force).then((value) {
      WrapperModel wrapper = value.finalize(
          wrapper: WrapperModel(),
          failure: (e) => showToast(e),
          success: (data) {});
      var result = IMRoomAccountEntity.fromJson(wrapper.object);
      if (!force) {
        if ((result.chatPassword?.isEmpty ?? true) ||
            (result.chatUsername?.isEmpty ?? true)) {
          return chatRoomAccount(true);
        }
      }
      return result;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      UserInfoOperation().imLogIn().then((value) {
        if (_roomId != null) _getRoom(_roomId!);
      });
    }
  }

  @override
  void onMessagesReceived(List<EMMessage> messages) {
    // TODO: implement onMessagesReceived
    List<EMMessage> ms = messages;
    messages.forEach((element) {
      if (element.conversationId != _roomId) return;
      if (element.body is EMCustomMessageBody) {
        var body = element.body as EMCustomMessageBody?;
        String? m = body?.params?["message"].toString();
        m = xxtea.decryptToString(m, _key);
        if (m == null) {
          ms.remove(element);
          return;
        }
        String? event = body?.event;
        Map<String, String> params = body!.params!;
        if (TextType.conversation.rawValue == event) {
          String name = params["hjnName"].toString();
          String message = m; //params["message"].toString();
          String id = params["id"].toString();
          int level = int.parse(params["level"]!);
          // int? number = int.parse(params["level"]!);
          TextType type = TextType.conversation;
          // if (TextType.gift.rawValue == event) {
          //   type = TextType.gift;
          // }
          String typeValue = params["type"]!;
          dynamic ex = params["extension"];
          if (ex != null && ex is String && ex.isNotEmpty) {
            try {
              ex = jsonDecode(ex);
            } catch (_) {
              ex = null;
            }
          }
          // 判断拓展id ex["id"] == id1
          GlobalKey? key;
          if (ex is Map && ex["id"] == AppManager.getInstance<AppUser>().userId) {
            chats._addCount();
            key = GlobalKey();
          }
          chats.addChats(name, message, id,
              level: level,
              type: type,
              messageType: MessageType.$default.getMessageType(typeValue),
              ex: ex,
              key: key);
          _scrollPopToTop?.call();
        } else if ('like' == event) {
        } else if ('slider' == event) {
          String message = m;
          chats.addPopList(message);
        } else if (TextType.mute.rawValue == event ||
            TextType.muteCancel.rawValue == event) {
          // mute = MuteModel(int.parse(params["time"]!), DateTime.now());
          var id = params["mutingId"];
          if (id == AppManager.getInstance<AppUser>().userId) {
            if (TextType.mute.rawValue == event) {
              mute1 = true;
            } else {
              mute1 = false;
            }
          }
        }
      } else {
        var value = element.attributes?[_messageKey];
        if (value != null && (value is String || value is Map)) {
          Map v;
          if (value is Map) {
            v = value;
          } else {
            v = jsonDecode(value);
          }
          var json = v["message"];
          var type = v["broadcastAction"];
          if (type == TextType.enterLiveRoom.rawValue ||
              type == TextType.attention.rawValue) {
            var t = TextType.enterLiveRoom;
            var name = json["username"];
            var level = json["rank"];
            if (type == TextType.attention.rawValue) {
              t = TextType.attention;
            } else {
              chats._enterRoomNotify(
                  ChatModel(
                      id: "",
                      name: name,
                      uuid: chats._getUuid,
                      level: level,
                      messageType: MessageType.notify,
                      content: "${intl.enterLivingRoom}"),
                  json["car_url"] ?? "");
            }
            chats.addChats(name, "", "",
                level: level,
                messageType: MessageType.notify,
                number: 0,
                type: t);
          } else if (type == TextType.startGameIm.rawValue) {
            AppManager.getInstance<Game>()
                .lottery({"${json["gameName"]}": json});
            chats.addChats(json["gameName"], "", "",
                level: 0,
                messageType: MessageType.notify,
                number: 0,
                type: TextType.startGameIm);
          } else if (type == TextType.winPrize.rawValue) {
            var name = json["username"];
            var gameName = json["gameName"];
            var winGain = json["value"];
            chats.addChats(
                "",
                "${intl.congratulation}【$name】${intl.at}【$gameName】${intl.inThePlay},${intl.gain}【$winGain】",
                "",
                type: TextType.winPrize,
                messageType: MessageType.notify);
            bool scroll = json["scrollBar"] ?? false;
            if (scroll) {
              chats._winPrizeNotify(ChatModel(
                id: "",
                name: name,
                uuid: chats._getUuid,
                content: "${intl.at}$gameName${intl.gain}",
                ex: "$winGain",
                messageType: MessageType.notify,
              ));
            }
          } else if (type == TextType.bootomIm.rawValue) {
            var userId = json["userid"];
            if (AppManager.getInstance<AppUser>().userId != userId)
              chats.addChats(
                  json["gameName"],
                  "${intl.user}【${json["username"]}】${intl.at}【${json["gameName"]}】${intl.inThePlay},${intl.alreadyBet}【${json["totalBetNum"]}】",
                  "${json["periodTime"]}",
                  type: TextType.bootomIm,
                  ex: json["betList"],
                  messageType: MessageType.notify);
          } else if (type == TextType.gift.rawValue) {
            String name = json["sendname"];
            chats.addChats(name, "${intl.send}${json["giftName"]}", "",
                type: TextType.gift,
                pic: json["giftPic"],
                messageType: MessageType.notify,
                number: int.parse(json["giftNum"].toString()));
            var v = int.tryParse(json["coins"].toString());
            if (v != null) {
              _coins?.call(v);
            }
            bool scroll = json["scrollBar"] ?? false;
            if (scroll) {
              chats._sendGiftNotify(ChatModel(
                  id: "",
                  name: name,
                  uuid: chats._getUuid,
                  messageType: MessageType.notify,
                  content: "${intl.givingLiverGift}",
                  ex: "${json["giftValue"]}${intl.$of}${json["giftName"]}"));
            }
          } else if (type == TextType.globalMute.rawValue) {
            var userId = json["userid"];
            var isMute = json["ismute"].toString();
            if (AppManager.getInstance<AppUser>().userId == userId) {
              if (isMute == "0") {
                //0=添加全局禁言 1=取消全局禁言
                mute1 = true;
              } else {
                mute1 = false;
              }
            }
          }
        }
      }
    });
    super.onMessagesReceived(ms);
  }

  void dispose() {
    _timer?.cancel();
    _scrollPopToTop = null;
    EMClient.getInstance.chatRoomManager.leaveChatRoom(_roomId??"");
    EMClient.getInstance.chatManager.removeChatManagerListener(this);
    WidgetsBinding.instance?.removeObserver(this);
    EventBus.instance.removeListener(_onVerifyRoom, name: verifyRoomSuccess);
  }

  void subtractCount() {
    chats._subtractCount();
  }

  void _onVerifyRoom(arguments) {
    chats._clearChats();
    // var time = arguments["time"];
    // var startTime = arguments["banOpentime"];
    String banFlag = arguments["banFlag"].toString();
    if (banFlag == "1") //(time != null && startTime != null)
      mute1 = true; //MuteModel(time, startTime);
    else
      mute1 = false;
    getRoom(arguments["chatRoomId"]);
  }
}

class LiveRoomChatViewModel extends GetxController {
  RxList<ChatModel> _chats = <ChatModel>[].obs;

  RxList<ChatModel> get chats => _chats;

  /// 进入直播间
  RxList<ChatModel> _enterRoom = RxList();

  RxList<ChatModel> get enterRoomList => _enterRoom;

  List<String> _cars = [];

  List<String> get cars => _cars;

  /// 中奖
  RxList<ChatModel> _winP = RxList();

  RxList<ChatModel> get winP => _winP;

  /// 赠送礼物
  RxList<ChatModel> _sendGift = RxList();

  RxList<ChatModel> get sendGift => _sendGift;

  /// 滚动列表
  RxList<String> _popList = <String>[].obs;

  RxList<String> get popList => _popList;

  /// 是否聚焦
  RxBool get isOnFocus => _isOnFocus;
  RxBool _isOnFocus = false.obs;

  /// 跳转数
  RxInt _count = 0.obs;

  RxInt get count => _count;

  /// 默认消息类型
  Rx<_MessageState> _message = _MessageState().obs;

  Rx<_MessageState> get messageState => _message;

  void onFocus() {
    _isOnFocus.value = true;
  }

  void _addCount() {
    _count++;
  }

  void _subtractCount() {
    if (_count.value > 0) {
      _count--;
    } else {
      _count.refresh();
    }
  }

  void _resetMessage() {
    _message.value = _MessageState();
  }

  void unFocus() {
    _isOnFocus.value = false;
    _resetMessage();
  }

  /// 添加聊天
  void addChats(String name, String message, String id,
      {int? level,
      int? number,
      required TextType type,
      String? pic,
      dynamic ex,
      required MessageType messageType,
      GlobalKey? key}) {
    _chats.insert(
        0,
        ChatModel(
            id: id,
            name: name,
            key: key,
            level: level ?? 0,
            content: message,
            type: type,
            num: number,
            pic: pic,
            ex: ex,
            uuid: _getUuid,
            messageType: messageType));
    if (_chats.length > 1000) {
      _chats.removeLast();
    }
  }

  void onCall(String id, String name) {
    onFocus();
    _message.value.type = MessageType.call;
    _message.value.ex = {"id": id, "name": name};
    _message.refresh();
  }

  void onReply(String id, String name, String content) {
    onFocus();
    _message.value.type = MessageType.reply;
    _message.value.ex = {"id": id, "name": name, "content": content};
    _message.refresh();
  }

  void _enterRoomNotify(ChatModel chat, String url) {
    _enterRoom.add(chat);
    if (url.isNotEmpty) _cars.add(url);
    EventBus.instance.notificationListener(name: enterRoom);
  }

  void _winPrizeNotify(ChatModel chat) {
    _winP.add(chat);
    EventBus.instance.notificationListener(name: winPrize);
  }

  void _sendGiftNotify(ChatModel chat) {
    _sendGift.add(chat);
    EventBus.instance.notificationListener(name: givingGift);
  }

  /// 添加滑动列表
  void addPopList(String message) {
    _popList += [message];
  }

  void _clearChats() {
    _chats.value = [
      ChatModel(
          level: 5,
          name: "",
          type: TextType.initializeMessage,
          id: "",
          content: "",
          messageType: MessageType.$default,
          uuid: _getUuid),
    ];
    _enterRoom.value = [];
    _winP.value = [];
    _sendGift.value = [];
    _cars.clear();
  }

  String get _getUuid => Uuid().v1();
}

class ChatModel {
  ChatModel(
      {this.name,
      this.level,
      required this.id,
      required this.content,
      this.num,
      this.type: TextType.conversation,
      this.pic,
      this.ex,
      required this.uuid,
      required this.messageType,
      this.key});

  final String? name;
  final String? pic;
  final String content;
  final int? level;
  final TextType type;
  final String id;
  final int? num;
  final String uuid;
  final dynamic ex;

  /// 0: 默认  1: @  2: 回复
  final MessageType messageType;
  GlobalKey? key;
}

class _MessageState {
  MessageType type = MessageType.$default;
  dynamic ex;
}

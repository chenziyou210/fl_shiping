/*
 *  Copyright (C), 2015-2021
 *  FileName: http_channel_extension
 *  Author: Tonight丶相拥
 *  Date: 2021/3/11
 *  Description: 
 **/

part of httpplugin;

extension HttpChannelExtension on HttpChannel {
  /// 取消请求
  void cancelRequest(int token) {
    HttpMidBuffer.buffer.cancelRequestWidth(token);
  }

  /// 账号注册
  /// account: 账号
  /// password：密码
  /// repassword：确认密码
  Future<HttpResultContainer> register(
      {required String account,
      required String password,
      required String rePassword,
      required String deviceCode,
      required String code}) {
    return _onCommonRequest(
        AppRequest.registered,
        {
          HttpPluginKey.BODY: {
            "password": password,
            "rePassword": rePassword,
            "account": account,
            "code": code,
            "deviceCode": deviceCode
          }
        },
        needToken: false);
  }

  /// 登录
  /// type：0-游客登录、1-账号登录
  Future<HttpResultContainer> logIn(String account, String password,
      {String? type}) {
    return _onCommonRequest(
        AppRequest.logIn,
        {
          HttpPluginKey.BODY: {
            "password": password,
            "type": type,
            "account": account,
            "device": 1
          }
        },
        needToken: false);
  }

  /// 登录
  /// type：0-游客登录、1-账号登录
  Future<HttpResultContainer> guestlogin(String deviceCode) {
    return _onCommonRequest(
        AppRequest.guestlogIn,
        {
          HttpPluginKey.BODY: {
            "deviceCode": deviceCode,
          }
        },
        needToken: false);
  }

  /// 上传图片
  Future<HttpResultContainer> uploadImage(dynamic image,
      {void Function(int count, int amount)? process,
      void Function(int? token)? cancelToken}) async {
    // return HttpMidBuffer.buffer.uploadWithParameter(AppRequest.uploadImage, {
    //   HttpPluginKey.BODY: image,
    //   HttpPluginKey.HEADER: {
    //     "token": AppUser.user.token!
    //   }
    // });
    var value = await MultipartFile.fromFile(image);

    return HttpMidBuffer.buffer.uploadWithParameter(
        AppRequest.uploadImage,
        {
          HttpPluginKey.HEADER: {
            "content-type": "multipart/form-data",
            "token": AppManager.getInstance<AppUser>().token!
          },
          HttpPluginKey.BODY: FormData.fromMap({"file": value})
        },
        cancelToken: cancelToken,
        process: process);
    // return _onCommonRequest(AppRequest.uploadImage, {
    //   HttpPluginKey.HEADER: {
    //     "content-type": "multipart/form-data"
    //   },
    //   HttpPluginKey.BODY: FormData.fromMap({
    //     "file": value
    //   })
    // }, cancelToken: cancelToken);
  }

  /// 用户信息
  Future<HttpResultContainer> userInfo() {
    return _onCommonRequest(AppRequest.userInfo, {});
  }

  /// 编辑个人信息
  Future<HttpResultContainer> editUserInfo(
      {String? avatar,
      String? birthday,
      String? city,
      String? emotion,
      String? name,
      String? profession,
      int? sex,
      String? signature}) {
    return _onCommonRequest(AppRequest.editUserInfo, {
      HttpPluginKey.BODY: {
        "birthday": birthday,
        "city": city,
        "emotion": emotion,
        "header": avatar,
        "username": name,
        "profession": profession,
        "sex": sex ?? 0,
        "signature": signature
      }
    });
  }

  /// 设置信息
  Future<HttpResultContainer> settingInfo() {
    return _onCommonRequest(AppRequest.settingInfo, {});
  }

  /// 系统参数
  Future<HttpResultContainer> systemParameter() {
    return _onCommonRequest(AppRequest.systemParameter, {});
  }

  /// 设置更新
  /// id: 用户id: userId
  Future<HttpResultContainer> settingUpdate(
      {required String accountSecurity,
      required int appLock,
      required String id,
      required String language}) {
    return _onCommonRequest(AppRequest.settingUpdate, {
      HttpPluginKey.BODY: {
        "accountSecurity": accountSecurity,
        "appLock": appLock,
        "id": id,
        "language": language
      }
    });
  }

  /// 获取黑名单
  Future<HttpResultContainer> blackList(int page, [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.blackList, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": pageSize}
    });
  }

  /// 删除黑名单
  Future<HttpResultContainer> deleteBlackList(String id) {
    return _onCommonRequest(AppRequest.deleteBlackList, {
      HttpPluginKey.BODY: {"id": id}
    });
  }

  /// 加入黑名单
  Future<HttpResultContainer> insertBlackList(String id) {
    return _onCommonRequest(AppRequest.insertBlackList, {
      HttpPluginKey.BODY: {"blackId": id}
    });
  }

  /// 关注列表
  Future<HttpResultContainer> favoritePaging(int page,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.favoritePaging, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": pageSize}
    });
  }

  /// 添加关注
  Future<HttpResultContainer> favoriteInsert(String id) {
    return _onCommonRequest(AppRequest.favoriteInsert, {
      HttpPluginKey.BODY: {"attentionId": id}
    })
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (_) {
              AppManager.getInstance<AppUser>().addAttention();
            });
      });
  }

  /// 取消关注
  Future<HttpResultContainer> favoriteCancel(String id) {
    return _onCommonRequest(AppRequest.favoriteDelete, {
      HttpPluginKey.BODY: {"aid": id}
    })
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (_) {
              AppManager.getInstance<AppUser>().removeAttention();
            });
      });
  }

  /// 退出登录
  Future<HttpResultContainer> logOut() {
    return _onCommonRequest(AppRequest.logOut, {});
  }

  /// 主播列表
  /// type
  Future<HttpResultContainer> anchorListByType(int page, int? type,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.anchorList, {
      HttpPluginKey.BODY: {"id": type, "pageNum": page, "pageSize": pageSize}
    });
  }

  /// 关注主播列表
  /// type
  Future<HttpResultContainer> watchlistListByType(int page,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.followAnchorList, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": pageSize}
    });
  }

  /// 创建普通直播间
  /// defaultRoom: （1:普通房间 2:门票房间 3:计时房间 4:游戏房间）
  /// isopen_props:  是否开启道具(0：否1：是)
  Future<HttpResultContainer> createCommonRoom(
      {required String roomTitle,
      required String cover,
      required int level,
      required String anchorType,
      int type: 1}) {
    return _onCommonRequest(AppRequest.createCommonRoom, {
      HttpPluginKey.BODY: {
        "roomType": type,
        "roomTitle": roomTitle,
        "roomCover": cover,
        "lookLevel": level,
        "ticketAmount": "0",
        "timeDeduction": "0",
        "openProps": true,
        // "anchorType": anchorType
      }
    });
  }

  /// 创建游戏直播间
  Future<HttpResultContainer> createGameRoom(
      {required String roomTitle,
      required String cover,
      required int level,
      required String anchorType}) {
    return createCommonRoom(
        roomTitle: roomTitle,
        cover: cover,
        anchorType: anchorType,
        level: level,
        type: 4);
  }

  /// 创建门票直播间
  Future<HttpResultContainer> createTickerAmountRoom(
      {required String roomTitle,
      required String cover,
      required double ticketAmount,
      required String minute,
      required String anchorType}) {
    return _onCommonRequest(AppRequest.createCommonRoom, {
      HttpPluginKey.BODY: {
        "roomType": 2,
        "roomTitle": roomTitle,
        "roomCover": cover,
        "ticketAmount": ticketAmount,
        "timeDeduction": "0",
        "openProps": true,
        // "ticketTryseeTime": int.parse(minute),
        // "anchorType": anchorType
      }
    });
  }

  /// 创建计时直播间
  Future<HttpResultContainer> createTimeDeductionRoom(
      {required String roomTitle,
      required String cover,
      required double timeDeduction,
      required String minute,
      required String anchorType}) {
    return _onCommonRequest(AppRequest.createCommonRoom, {
      HttpPluginKey.BODY: {
        "roomType": 3,
        "roomTitle": roomTitle,
        "roomCover": cover,
        "timeDeduction": timeDeduction,
        "ticketAmount": "0",
        "openProps": true,
        // "ticketTryseeTime": int.parse(minute),
        // "anchorType": anchorType
      }
    });
  }

  // /// 主播退出直播间
  // Future<HttpResultContainer> anchorExitRoom({required String roomId}){
  //   return _onCommonRequest(AppRequest.anchorExitRoom, {
  //     HttpPluginKey.QUERYPARAMETER: {
  //       "roomID": roomId
  //     }
  //   });
  // }

  /// 关闭直播间
  Future<HttpResultContainer> destroyRoom({
    required String roomId,
    // required String groupId
  }) {
    return _onCommonRequest(AppRequest.destroyRoom, {
      HttpPluginKey.BODY: {
        "roomId": roomId,
        // "groupId": groupId
      }
    });
  }

  /// 刷礼物
  /// 刷的礼物类型: 1普通礼物,扣货币资产; 2会员背包内的礼物
  Future<HttpResultContainer> brushGift(
      {required String anchorId,
      required String giftId,
      required String giftNum,
      required int type}) {
    return _onCommonRequest(AppRequest.brushGift, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "giftId": giftId,
        "giftNum": giftNum,
        "brushGiftType": type
      }
    })
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              if (data is Map<String, dynamic>)
                AppManager.getInstance<AppUser>().updateMoney(data);
            });
      });
  }

  /// 观众退出直播间
  Future<HttpResultContainer> audienceExitRoom(
      {required String roomId, required bool follow

      ///1: 直接退出 2:观众:关注主播并退出直播间
      }) {
    return _onCommonRequest(AppRequest.audienceExitRoom, {
      HttpPluginKey.BODY: {"roomId": roomId, "follow": follow}
    });
  }

  // /// 退出并关注
  // Future<HttpResultContainer> audienceExitAndAttention({
  //   required String roomId,
  //   required String anchorId,
  //   required String userId
  // }){
  //   return _onCommonRequest(AppRequest.audienceExitAndAttention, {
  //     HttpPluginKey.QUERYPARAMETER: {
  //       "roomID": roomId,
  //       "anchorId": anchorId,
  //       "userId": userId
  //     }
  //   });
  // }

  // /// 直播间观众数量
  // Future<HttpResultContainer> audienceCount({
  //   required String roomId
  // }){
  //   return _onCommonRequest(AppRequest.audienceCount, {
  //     HttpPluginKey.QUERYPARAMETER: {
  //       "roomID": roomId
  //     }
  //   });
  // }

  /// 日排行
  Future<HttpResultContainer> dailyRank(
      {required String anchorId,
      required int pageNum,
      int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.liveRoomRank, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "pageNum": pageNum,
        "pageSize": pageSize,
        "state": 1
      }
    });
  }

  /// 月排行
  Future<HttpResultContainer> monthRank(
      {required String anchorId,
      required int pageNum,
      int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.liveRoomRank, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "pageNum": pageNum,
        "pageSize": pageSize,
        "state": 3
      }
    });
  }

  /// 周排行
  Future<HttpResultContainer> weekRank(
      {required String anchorId,
      required int pageNum,
      int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.liveRoomRank, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "pageNum": pageNum,
        "pageSize": pageSize,
        "state": 2
      }
    });
  }

  /// 获取user 信息
  /// 1:查粉丝信息 2:查主播信息
  Future<HttpResultContainer> getUserInfo(String id, int state, String userId) {
    return _onCommonRequest(AppRequest.getUserInfo, {
      HttpPluginKey.BODY: {"anchorId": id, "userid": userId, "state": state}
    });
  }

  /// 直播间礼物列表
  Future<HttpResultContainer> roomGiftList(
      {required int pageNum, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.roomGiftList, {
      HttpPluginKey.BODY: {"pageNum": pageNum, "pageSize": pageSize}
    });
  }

  // /// 进入直播间
  // Future<HttpResultContainer> addAudience({required String roomId, required String userInfo}){
  //   return _onCommonRequest(AppRequest.addAudience, {
  //     HttpPluginKey.QUERYPARAMETER: {
  //       "roomID": roomId,
  //       "userInfo": userInfo
  //     }
  //   });
  // }

  /// 附近主播
  Future<HttpResultContainer> locationAnchor(String latitude, String longitude,
      {required int pageNum, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.locationSave, {
      HttpPluginKey.BODY: {
        "data": {"latitude": latitude, "longitude": longitude},
        "pageNum": pageNum,
        "pageSize": pageSize
      }
    });
  }

  /// 上传地理位置
  Future<HttpResultContainer> locationSave(String latitude, String longitude) {
    return _onCommonRequest(AppRequest.locationSave, {
      HttpPluginKey.BODY: {"latitude": "string", "longitude": "string"}
    });
  }

  // /// 根据roomId 获取直播间信息
  // Future<HttpResultContainer> getAnchors(String id){
  //   return _onCommonRequest(AppRequest.getAnchors, {
  //     HttpPluginKey.QUERYPARAMETER: {
  //       "roomID": id
  //     }
  //   });
  // }

  /// 首页日排行
  Future<HttpResultContainer> indexDailyRank(int pageNum,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.indexRank, {
      HttpPluginKey.BODY: {
        "pageNum": pageNum,
        "pageSize": pageSize,
        "rankType": 1
      }
    });
  }

  /// 首页月排行
  Future<HttpResultContainer> indexMonthRank(int pageNum,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.indexRank, {
      HttpPluginKey.BODY: {
        "pageNum": pageNum,
        "pageSize": pageSize,
        "rankType": 3
      }
    });
  }

  /// 首页周排行
  Future<HttpResultContainer> indexWeekRank(int pageNum,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.indexRank, {
      HttpPluginKey.BODY: {
        "pageNum": pageNum,
        "pageSize": pageSize,
        "rankType": 2
      }
    });
  }

  /// 首页搜索分页查询
  Future<HttpResultContainer> recommend(String keyword, int pageNum,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.homeSearch, {
      HttpPluginKey.BODY: {
        "keyword": keyword,
        "pageNum": pageNum,
        "pageSize": pageSize
      }
    });
  }

  /// 心跳
  Future<HttpResultContainer> heartBeat(
      {required String userId,
      required String token,
      required String roomId,
      int? statusCode}) {
    return _onCommonRequest(
        AppRequest.heartBeat,
        {
          HttpPluginKey.CUSTOMURL:
              "https://liveroom.qcloud.com/weapp/live_room/anchor_heartbeat",
          HttpPluginKey.QUERYPARAMETER: {"userID": userId, "token": token},
          HttpPluginKey.HEADER: {
            "token": AppManager.getInstance<AppUser>().token!
          },
          HttpPluginKey.BODY: {
            "roomID": roomId,
            "userID": userId,
            "roomStatusCode": statusCode ?? 0
          }
        },
        needToken: false);
  }

  /// 直播间信息
  Future<HttpResultContainer> liveRoomInfo({required String roomId}) {
    return _onCommonRequest(AppRequest.liveRoomInfo, {
      HttpPluginKey.BODY: {"roomId": roomId}
    });
  }

  /// 首页banner
  /// 1:开机屏幕 2:首页弹框 3:首页广告位
  Future<HttpResultContainer> homeBanner(int type) {
    return _onCommonRequest(AppRequest.banner, {
      HttpPluginKey.BODY: {"advertiseType": type}
    });
  }

  /// 获取用户信息
  Future<HttpResultContainer> getUserById(String id) {
    return _onCommonRequest(AppRequest.getUserById, {
      HttpPluginKey.BODY: {"anchorId": id}
    });
  }

  /// 主播贡献榜
  Future<HttpResultContainer> anchorContributionList(String anchorId, int page,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.anchorContributionList, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "pageNum": page,
        "pageSize": pageSize
      }
    });
  }

  /// 砖石充值页面
  Future<HttpResultContainer> showConsPage() {
    return _onCommonRequest(AppRequest.showConsPage, {});
  }

  /// 砖石充值
  Future<HttpResultContainer> chargeDiamond(String id) {
    return _onCommonRequest(AppRequest.chargeDiamond, {
      HttpPluginKey.BODY: {"appConsMoneyId": id}
    });
  }

  /// 余额充值
  Future<HttpResultContainer> balanceRecharge(double balance) {
    return _onCommonRequest(AppRequest.balanceRecharge, {
      HttpPluginKey.BODY: {"money": balance}
    });
  }

  /// 主播标签
  Future<HttpResultContainer> anchorLabel() {
    return _onCommonRequest(AppRequest.anchorLabel, {
      HttpPluginKey.BODY: {"pageNum": 1, "pageSize": 99999}
    });
  }

  /// 直播间验证
  /// 进入门票房间状态（0:试看 1:正常）--门票房间必传
  Future<HttpResultContainer> verifyLiveRoom(
      {required String roomId, void Function(int? token)? cancelToken}) {
    return _onCommonRequest(
        AppRequest.liveRoomVerify,
        {
          HttpPluginKey.BODY: {"roomId": roomId}
        },
        cancelToken: cancelToken)
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              if (data is Map<String, dynamic>)
                AppManager.getInstance<AppUser>().updateMoney(data);
            });
      });
  }

  /// 计时收费
  Future<HttpResultContainer> timerLiveRoom(String id) {
    return _onCommonRequest(AppRequest.timerLiveRoom, {
      HttpPluginKey.BODY: {
        "anchorId": id,
      }
    })
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              if (data is Map<String, dynamic>)
                AppManager.getInstance<AppUser>().updateMoney(data);
            });
      });
  }

  /// 直播间禁言
  /// time：时长(分钟)
  Future<HttpResultContainer> banSpeak(
      String anchorId, String userId, int time) {
    return _onCommonRequest(AppRequest.banSpeak, {
      HttpPluginKey.BODY: {"anchorId": anchorId, "userId": userId, "time": time}
    });
  }

  /// 取消直播间禁言
  Future<HttpResultContainer> deleteBanSpeak(String id) {
    return _onCommonRequest(AppRequest.deleteBanSpeak, {
      HttpPluginKey.BODY: {"id": id}
    });
  }

  /// 禁言列表
  Future<HttpResultContainer> banSpeakList(String anchorId, int pageNum,
      [int pageSize = _pageSize]) {
    return _onCommonRequest(AppRequest.banSpeakList, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "pageNum": pageNum,
        "pageSize": pageSize
      }
    });
  }

  /// 提现
  Future<HttpResultContainer> withdraw(double number) {
    return _onCommonRequest(AppRequest.withdraw, {
      HttpPluginKey.BODY: {"money": number}
    });
  }

  /// 下注
  Future<HttpResultContainer> bet(Map<String, dynamic> map) {
    return _onCommonRequest(AppRequest.bet, {HttpPluginKey.BODY: map})
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (data) {
              if (data is Map<String, dynamic>)
                AppManager.getInstance<AppUser>().updateMoney(data);
            });
      });
  }

  /// 游戏配置
  Future<HttpResultContainer> gameConfig({String? gameName}) {
    return _onCommonRequest(AppRequest.gameConfig, {
      HttpPluginKey.BODY: {"gameName": gameName}
    });
  }

  /// 运行游戏
  Future<HttpResultContainer> runtimeGame({String? gameName}) {
    return _onCommonRequest(AppRequest.runtimeGame, {
      HttpPluginKey.BODY: {"gameName": gameName}
    });
  }

  /// 直播间推荐
  Future<HttpResultContainer> livingRoomRecommend(String anchorId, int page,
      {int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.livingRoomRecommend, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": _pageSize,
        // "anchorId": anchorId
      }
    });
  }

  /// 观众数量
  Future<HttpResultContainer> audienceNumber(String anchorId) {
    return _onCommonRequest(AppRequest.audienceNumber, {
      HttpPluginKey.BODY: {"anchorId": anchorId}
    });
  }

  /// 开奖记录
  Future<HttpResultContainer> lotteryLog(int page,
      {String? gameName, int pageSize: _pageSize, required int created}) {
    return _onCommonRequest(AppRequest.lotteryLog, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "gameName": gameName,
        "created": created
      }
    });
  }

  /// 下注记录
  Future<HttpResultContainer> betLog(int page,
      {String? gameName, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.betLog, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "gameName": gameName
      }
    });
  }

  /// 展示银行卡
  Future<HttpResultContainer> showBank() {
    return _onCommonRequest(AppRequest.showBank, {});
  }

  ///    bindBankDelete: ()=> DeleteBindBank(),
//     bindBankInfo: ()=> UserBindBankInfo(),
//     userBindList: ()=> BindBankList(),
//     userBindBankModify: ()=> UserBindBankModify(),
//     systemBankList: ()=> SystemBankList()

  /// 删除用户绑定列表
  Future<HttpResultContainer> deleteBindBank(String id) {
    return _onCommonRequest(AppRequest.bindBankDelete, {
      HttpPluginKey.BODY: {"id": id}
    });
  }

  /// 单个绑定银行卡信息
  Future<HttpResultContainer> bindBankInfo(String id) {
    return _onCommonRequest(AppRequest.bindBankInfo, {
      HttpPluginKey.BODY: {"id": id}
    });
  }

  /// 绑定银行卡列表
  Future<HttpResultContainer> bindBankList() {
    return _onCommonRequest(AppRequest.userBindList, {});
  }

  /// 绑定银行卡
  Future<HttpResultContainer> bindBankModify(
      {String? id,
      required String purseChannel,
      required String name,
      required String bankname,
      required String cardNumber,
      required String accountob,
      required String remark}) {
    return _onCommonRequest(AppRequest.userBindBankModify, {
      HttpPluginKey.BODY: {
        "id": id,
        "purseChannel": purseChannel,
        "name": name,
        "bankname": bankname,
        "cardNumber": cardNumber,
        "accountob": accountob,
        "remark": remark
      }
    });
  }

  /// 获取银行卡列表
  Future<HttpResultContainer> systemBankList() {
    return _onCommonRequest(AppRequest.systemBankList, {});
  }

  /// 创建订单
  Future<HttpResultContainer> createOrder(
      {int paymentType: 0,
      required double orderPrice,
      required String channelName,
      String? bizId,
      Map<String, dynamic>? arguments}) {
    return _onCommonRequest(AppRequest.createOrder, {
      HttpPluginKey.BODY: {
        "orderPrice": orderPrice,
        "paymentType": paymentType,
        "channelName": channelName,
        "bizId": bizId
      }..addAll(arguments ?? {})
    });
  }

  /// 查询支付结果
  Future<HttpResultContainer> payNotify() {
    return _onCommonRequest(AppRequest.payNotify, {});
  }

  /// 新提现接口
  Future<HttpResultContainer> withdrawNew(
      {required String bindBankId,
      required double money,
      required String withdrawPassword}) {
    return _onCommonRequest(AppRequest.withdrawNew, {
      HttpPluginKey.BODY: {
        "bindBankId": bindBankId,
        "money": money,
        "withdrawPassword": withdrawPassword
      }
    });
  }

  /// 获取验证码图片
  Future<HttpResultContainer> securityCodeImage(
      {required String account,
      required String uid,
      required String verifyCode}) {
    return _onCommonRequest(AppRequest.sendVerificationCode, {
      HttpPluginKey.BODY: {
        "account": account,
        "uuid": uid,
        "captcha": verifyCode
      }
    });
  }

  /// 忘记密码
  Future<HttpResultContainer> forgetPassword(
      {required String account,
      required String password,
      required String rePassword,
      required String code}) {
    return _onCommonRequest(AppRequest.forgetPassword, {
      HttpPluginKey.BODY: {
        "account": account,
        "code": code,
        "newPassword": password,
        "reNewPassword": rePassword
      }
    });
  }

  /// 等级
  Future<HttpResultContainer> gradeList() {
    return _onCommonRequest(AppRequest.gradeList, {});
  }

  /// 主播榜
  /// rankType： 排行类型 1=日榜 2=周榜 3=月榜
  Future<HttpResultContainer> anchorRank(
      {required int page, required int type, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.anchorRank, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "rankType": type
      }
    });
  }

  /// 富豪榜
  /// rankType：排行类型 1=日榜 2=周榜 3=月榜
  Future<HttpResultContainer> userGiftRank(
      {required int page, required int type, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.userGiftRank, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "rankType": type
      }
    });
  }

  /// 粉丝列表
  Future<HttpResultContainer> fansPage(int page, {int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.fansPage, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": _pageSize}
    });
  }

  /// 主播端观众人数
  Future<HttpResultContainer> anchorOnlineNumber(String anchorId) {
    return _onCommonRequest(AppRequest.anchorOnlineNumber, {
      HttpPluginKey.BODY: {"anchorId": anchorId}
    });
  }

  /// 添加状态
  /// (1:设为管理员 2:添加禁言)
  Future<HttpResultContainer> livingAddStatus(
      {required String anchorId, required String userId, required int state}) {
    return _onCommonRequest(AppRequest.livingAddStatus, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "userid": userId,
        "addState": state
      }
    });
  }

  /// 取消状态
  /// (1:取消管理员 2:取消禁言)
  Future<HttpResultContainer> livingCancelStatus(
      {required String anchorId, required String userId, required int state}) {
    return _onCommonRequest(AppRequest.livingCancelStatus, {
      HttpPluginKey.BODY: {
        "anchorId": anchorId,
        "userid": userId,
        "cancelState": state
      }
    });
  }

  /// 系统参数
  Future<HttpResultContainer> systemParamList() {
    return _onCommonRequest(AppRequest.systemParamList, {});
  }

  /// 提现记录
  Future<HttpResultContainer> withdrawInfo(
      {required int page, int pageSize: _pageSize, int? timeType, String? id}) {
    return _onCommonRequest(AppRequest.withdrawInfo, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType,
        "bizid": id
      }
    });
  }

  /// 账号明细
  Future<HttpResultContainer> accountDetail(
      {required int page, int pageSize: _pageSize, int? timeType, String? id}) {
    return _onCommonRequest(AppRequest.accountDetail, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType,
        "bizid": id
      }
    });
  }

  /// 下注记录
  Future<HttpResultContainer> betRecord(
      {required int page, int pageSize: _pageSize, int? timeType}) {
    return _onCommonRequest(AppRequest.betRecord, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType
      }
    });
  }

  /// 充值记录
  Future<HttpResultContainer> chargeRecord(
      {required int page, int pageSize: _pageSize, int? timeType}) {
    return _onCommonRequest(AppRequest.chargeRecord, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType
      }
    });
  }

  /// 礼物报表
  Future<HttpResultContainer> giftFormReport(
      {required int page, int pageSize: _pageSize, int? timeType}) {
    return _onCommonRequest(AppRequest.giftFormReport, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType
      }
    });
  }

  /// 直播时段
  Future<HttpResultContainer> livingTimeSlot(
      {required int page, int pageSize: _pageSize, int? timeType}) {
    return _onCommonRequest(AppRequest.livingTimeSlot, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "timeType": timeType
      }
    });
  }

  /// 修改登录密码
  Future<HttpResultContainer> modifyLogInPassword(
      {String? oldPassword,
      required String newPassword,
      required String confirmNewPassword}) {
    return _onCommonRequest(AppRequest.modifyLogInPassword, {
      HttpPluginKey.BODY: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "reNewPassword": confirmNewPassword
      }
    });
  }

  /// 修改提现密码
  Future<HttpResultContainer> modifyWithdrawPassword(
      {String? oldPassword,
      required String newPassword,
      required String confirmNewPassword}) {
    return _onCommonRequest(AppRequest.modifyWithdrawPassword, {
      HttpPluginKey.BODY: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "newPasswordConfirm": confirmNewPassword
      }
    })
      ..then((value) {
        value.finalize(
            wrapper: WrapperModel(),
            success: (_) {
              AppManager.getInstance<AppUser>().withdrawPassword = newPassword;
            });
      });
  }

  /// 主播反馈意见
  Future<HttpResultContainer> anchorFeedback(String content) {
    return _onCommonRequest(AppRequest.anchorFeedback, {
      HttpPluginKey.BODY: {"adviceContent": content}
    });
  }

  /// 直播间排行榜
  Future<HttpResultContainer> contributionListInLiving(int page,
      {int pageSize: _pageSize, required String anchorId}) {
    return _onCommonRequest(AppRequest.contributionListInLiving, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "anchorId": anchorId
      }
    });
  }

  /// 更新版本
  Future<HttpResultContainer> upgradeVersion({required String version}) {
    return _onCommonRequest(AppRequest.upgradeVersion, {
      HttpPluginKey.BODY: {
        "versionName": version,
        "platform": Platform.isIOS ? "ios" : "android"
      }
    });
  }

  /// 下载apk
  Future<HttpResultContainer> downloadApk(String url,
      {void Function(int count, int amount)? process,
      required String savePath,
      void Function(int? cancelToken)? cancelToken}) {
    return HttpMidBuffer.buffer.downloadWithParameter(
        AppRequest.appDownload, {HttpPluginKey.CUSTOMURL: url}, savePath,
        process: process, cancelToken: cancelToken);
  }

  /// firebase token 提交
  Future<HttpResultContainer> firebaseSubmit(String token) {
    return _onCommonRequest(AppRequest.firebaseSubmit, {
      HttpPluginKey.BODY: {"firebaseToken": token}
    });
  }

  /// 服务列表
  Future<HttpResultContainer> customServicesList() {
    return _onCommonRequest(
        AppRequest.customService,
        {
          HttpPluginKey.HEADER: {
            "token": AppManager.getInstance<AppUser>().token!
          },
        },
        needToken: false);
  }

  /// 坐骑列表
  Future<HttpResultContainer> carList() {
    return _onCommonRequest(AppRequest.carList, {});
  }

  /// 购买坐骑
  /// （0=月卡 1=季卡 2=年卡）
  Future<HttpResultContainer> carBuy({required int id, required int type}) {
    return _onCommonRequest(AppRequest.buyCar, {
      HttpPluginKey.BODY: {"id": id, "carPriceState": type}
    });
  }

  /// 使用坐骑
  Future<HttpResultContainer> useCar({required int id}) {
    return _onCommonRequest(AppRequest.useCar, {
      HttpPluginKey.BODY: {"id": id}
    });
  }

  /// app 活动
  Future<HttpResultContainer> appActivity() {
    return _onCommonRequest(AppRequest.appActivity, {});
  }

  /// 按类型搜索分类
  Future<HttpResultContainer> searchAnchorOnType(int type,
      {required int page, int pageSize = _pageSize}) {
    return _onCommonRequest(AppRequest.searchAnchorType, {
      HttpPluginKey.BODY: {
        "pageNum": page,
        "pageSize": pageSize,
        "anchorType": type
      }
    });
  }

  /// 系统字典
  Future<HttpResultContainer> systemDictionary() {
    return _onCommonRequest(
        AppRequest.systemDictionary,
        {
          HttpPluginKey.HEADER: {
            "token": AppManager.getInstance<AppUser>().token!
          },
        },
        needToken: false);
  }

  /**
   *     remainPoints: ()=> UserRemainingRewardPoint(),
      exchangeGift: ()=> PointExchangeGift(),
      exchangeRecord: ()=> UserExchangeRecord(),
      exchangeGiftList: ()=> ExchangeGiftList()*/

  /// 用户剩余积分
  Future<HttpResultContainer> userRemainPoints() {
    return _onCommonRequest(AppRequest.remainPoints, {});
  }

  /// 兑换礼物
  Future<HttpResultContainer> exchangeGift(
      {required int count, required String giftId}) {
    return _onCommonRequest(AppRequest.exchangeGift, {
      HttpPluginKey.BODY: {"exchangeQuantity": count, "giftId": giftId}
    });
  }

  /// 兑换记录
  Future<HttpResultContainer> exchangeRecord(
      {required int page, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.exchangeRecord, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": pageSize}
    });
  }

  /// 可兑换礼物列表
  Future<HttpResultContainer> exchangeGiftList(
      {required int page, int pageSize: _pageSize}) {
    return _onCommonRequest(AppRequest.exchangeGiftList, {
      HttpPluginKey.BODY: {"pageNum": page, "pageSize": pageSize}
    });
  }

  /// 用户背包
  Future<HttpResultContainer> userPackageList() {
    return _onCommonRequest(AppRequest.userPackageList, {});
  }

  /// 首页TAB
  Future<HttpResultContainer> cateGoryLabel() {
    return _onCommonRequest(AppRequest.categoryLabel, {});
  }

  /// 广告Banner图片
  /// （1:开机屏幕 2:首页弹框 3:首页广告位）
  Future<HttpResultContainer> advertiseBanner({required int advertiseType}) {
    return _onCommonRequest(AppRequest.advertiseBanner, {
      HttpPluginKey.BODY: {"advertiseType": advertiseType}
    });
  }

  /// 站内信、消息
  /// type: 1.公告 2.站内信
  Future<HttpResultContainer> announcementList(int type) {
    return _onCommonRequest(AppRequest.announcementList, {
      HttpPluginKey.BODY: {"type": type}
    });
  }

  /// 获取环信账户信息
  Future<HttpResultContainer> chatRoomAccount(bool force) {
    return _onCommonRequest(AppRequest.chatRoomAccount, {
      HttpPluginKey.BODY: {"force": force}
    });
  }

  /// 获取验证码
  Future<HttpResultContainer> smsSend({required String phone}) {
    return _onCommonRequest(AppRequest.smsSend, {
      HttpPluginKey.BODY: {"phone": phone}
    });
  }

  /// 绑定手机号
  Future<HttpResultContainer> bindPhone({
    required String phone,
    required String verifyCode,
    required int codeId
  }) {
    return _onCommonRequest(AppRequest.bindPhone, {
      HttpPluginKey.BODY: {"phone": phone, "verifyCode": verifyCode, "codeId": codeId}
    });
  }

  /// 切换直播间
  Future<HttpResultContainer> changeRoom() {
    return _onCommonRequest(AppRequest.changeRoom, {});
  }

}

// 分页数
const int _pageSize = 10;

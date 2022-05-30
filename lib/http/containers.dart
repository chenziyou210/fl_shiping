/*
 *  Copyright (C), 2015-2021
 *  FileName: containers
 *  Author: Tonight丶相拥
 *  Date: 2021/3/11
 *  Description: 
 **/

import 'package:httpplugin/httpplugin.dart' show HttpTickContainer;
import 'package:url_launcher/link.dart';
import 'request.dart';

class AppRequest {
  /// 微信获取token
  static const String userWeChatAccessToken = "oauth2/access_token";

  static const String heartBeat = "live_room/anchor_heartbeat";

  /// 那主播类型搜索
  static const String searchAnchorType = "anchor/showPageByAnchorType";

  /// 系统字典
  static const String systemDictionary = "system/sysDictionaryList.no";

  // 注册
  static const String registered = "index/registered";

  // 登录
  static const String logIn = "index/login";

  // 游客登录
  static const String guestlogIn = "index/guestLogin";

  // // 获取token
  // static const String liveToken = "token/getToken";

  // 上传文件
  static const String uploadImage = "data/image";

  // 用户信息
  static const String userInfo = "myCenter/Info";

  // 用户信息编辑
  static const String editUserInfo = "info/edit";

  // 设置信息
  static const String settingInfo = "myCenter/settingInfo";

  // 更新设置
  static const String settingUpdate = "settingInfo/update";

  // 黑名单
  static const String blackList = "settingInfo/showBlackList";

  // 删除黑名单
  static const String deleteBlackList = "settingInfo/deleteBlackList";

  // 加入黑名单
  static const String insertBlackList = "settingInfo/insertBlackList";

  /// 我的关注
  static const String favoritePaging = "follow/list";

  /// 添加关注
  static const String favoriteInsert = "myAttention/insert";

  /// 取消关注
  static const String favoriteDelete = "myAttention/delete";

  /// 退出登录
  static const String logOut = "app/logout";

  /// firebase 上传
  static const String firebaseSubmit = "userfirebasetoken/save";

  /// 主播列表
  static const String anchorList = "index/showAnchorByLable";

  /// 关注主播列表
  static const String followAnchorList = "api/app/liveRoom/followAnchor";

  /// 创建普通直播间
  static const String createCommonRoom = "MLVBLiveRoom/createCommonRoom";

  // ///  创建游戏直播间
  // static const String createGameRoom = "MLVBLiveRoom/createGameRoom";
  //
  // /// 创建门票房间
  // static const String createTickerAmountRoom = "MLVBLiveRoom/createTicketAmountRoom";
  //
  // /// 创建计时房间
  // static const String createTimeDeductionRoom = "MLVBLiveRoom/createTimeDeductionRoom";
  //
  // /// 创建密码房间
  // static const String createPasswordRoom = "MLVBLiveRoom/createPassWordRoom";

  // /// 主播退出直播间
  // static const String anchorExitRoom = "MLVBLiveRoom/deleteAnchor";

  /// 销毁直播间
  static const String destroyRoom = "MLVBLiveRoom/destroyRoom";

  /// 刷礼物
  static const String brushGift = "LiveingRoom/brushGift";

  /// 观众退出直播间
  static const String audienceExitRoom = "LiveingRoom/deleteAudience";

  // /// 退出并关注
  // static const String audienceExitAndAttention = "LiveingRoom/deleteAudienceAndAttiontion";

  // /// 获取直播间关键人数
  // static const String audienceCount = "LiveingRoom/getAudiences";

  /// 日排行榜
  static const String liveRoomRank = "getLiveRoomRank/daily";
  //
  // /// 月排行榜
  // static const String monthRank = "getLiveRoomRank/month";
  //
  // /// 周排行
  // static const String weekRank = "getLiveRoomRank/week";

  /// 获取用户信息
  static const String getUserInfo = "LiveingRoom/getUserInfo";

  /// 获取直播间礼物列表
  static const String roomGiftList = "LiveingRoom/gitLiveRoomGift";

  /// 进入直播间成为观众
  static const String addAudience = "index/addAudience";

  /// 获取附近主播
  static const String nearAnchor = "geo/near";

  /// 上传地理位置
  static const String locationSave = "geo/sava";
  // /// 获取房间信息
  // static const String getAnchors = "index/getAnchors";
  // /// 首页-日排行榜
  // static const String indexDailyRank = "getIndexRank/daily";
  // /// 首页-月排行榜
  // static const String indexMonthRank = "getIndexRank/month";
  /// 首页-周排行榜
  static const String indexRank = "getIndexRank/week";

  /// 直播间信息
  static const String liveRoomInfo = "liveRoom/getLiveRoomInfo";

  /// 首页banner
  static const String banner = "global/showAdvertise";

  /// 首页搜索
  static const String homeSearch = "index/recommend";

  /// 获取其他人信息
  static const String getUserById = "LiveingRoom/getAnchorHomePageInfo";

  /// 主播贡献榜
  static const String anchorContributionList =
      "LiveingRoom/getAnchorContributionList";

  /// 砖石充值页面
  static const String showConsPage = "MoneyrRelated/showConsPage";

  /// 砖石充值
  static const String chargeDiamond = "showConsPage/recharge";

  /// 余额充值
  static const String balanceRecharge = "MoneyrRelated/balanceRecharge";

  /// 主播标签
  static const String anchorLabel = "MLVBLiveRoom/selectAnchorLable";

  /// 直播间进入验证
  static const String liveRoomVerify = "MLVBLiveRoom/addAudience";

  /// 计时性直播间
  static const String timerLiveRoom =
      "LiveingRoom/timeDeductionRoomToDeductionTo";

  /// 直播间禁言
  static const String banSpeak = "banSpeak/add";

  /// 取消禁言
  static const String deleteBanSpeak = "banSpeak/delete";

  /// 禁言列表
  static const String banSpeakList = "banSpeak/list";

  /// 系统参数列表
  static const String systemParameter = "system/sysParamMap";

  /// 提现
  static const String withdraw = "moneyrRelated/moneyWithdraw";

  /// 下注
  static const String bet = "game/bottomPour";

  /// 游戏配置
  static const String gameConfig = "game/getGameConfig";

  /// 进入直播间拉取游戏
  static const String runtimeGame = "game/getRuntimeGame";

  /// 直播间推荐
  static const String livingRoomRecommend = "liveingRoom/recommend";

  /// 观众人数
  static const String audienceNumber = "liveingRoom/audienceNumber";

  /// 开奖记录
  static const String lotteryLog = "game/getLotteryLog";

  /// 下注记录
  static const String betLog = "game/getBottomPourLog";

  /// 银行展示
  static const String showBank = "moneyrRelated/showBank.no";

  /// 删除绑定银行卡
  static const String bindBankDelete = "userbindbank/delete";

  /// 单挑绑定银行卡信息
  static const String bindBankInfo = "userbindbank/info";

  /// 用户已绑定列表
  static const String userBindList = "userbindbank/list";

  /// 银行卡信息修改
  static const String userBindBankModify = "userbindbank/saveOrUpdate";

  /// 系统支持银行卡列表
  static const String systemBankList = "userbindbank/sysBankList";

  /// 创建订单
  static const String createOrder = "orderpayment/createOrder";

  /// 支付结果
  static const String payNotify = "orderpayment/payNotifyUrl.no";

  /// 新提现接口
  static const String withdrawNew = "userwithdraw/saveOrUpdate";

  /// 发送验证码
  static const String sendVerificationCode = "enter/code.no";

  /// 忘记密码
  static const String forgetPassword = "enter/forgetPassword.no";

  /// 等级列表
  static const String gradeList = "level/info";

  /// 富豪榜
  static const String userGiftRank = "rank/user";

  /// 主播榜
  static const String anchorRank = "rank/anchor";

  /// 粉丝列表
  static const String fansPage = "follow/fanList";

  /// 主播端：在线人数
  static const String anchorOnlineNumber = "anchor/anchorNumber";

  /// 取消状态
  static const String livingCancelStatus = "anchor/cancelAnchorAdmin";

  /// 添加状态
  static const String livingAddStatus = "anchor/addAnchorAdmin";

  /// 系统参数列表
  static const String systemParamList = "system/sysParamList";

  /// 提现记录
  static const String withdrawInfo = "userwithdraw/info";

  /// 账户明细
  static const String accountDetail = "masonrywater/getRecord";

  /// 下注记录
  static const String betRecord = "gamebottompourlog/list";

  /// 充值记录
  static const String chargeRecord = "orderpayment/list";

  /// 礼物报表
  static const String giftFormReport = "giftsend/giftForm";

  ///  直播时段
  static const String livingTimeSlot = "anchor/getLiveTime";

  /// 修改提现密码
  static const String modifyWithdrawPassword = "user/setWithdrawPassword";

  /// 修改支付密码
  static const String modifyLogInPassword = "user/updeteLoginPassword";

  /// 主播反馈
  static const String anchorFeedback = "anchoradvice/save";

  /// 直播间贡献榜
  static const String contributionListInLiving = "anchor/ContributionList";

  /// 更新版本信息
  static const String upgradeVersion = "appversion/list";

  /// app 下载
  static const String appDownload = "app/download";

  /// 客服列表
  static const String customService = "customerservice/list.no";

  /// 使用坐骑
  static const String useCar = "car/useCar";

  /// 坐骑列表
  static const String carList = "car/carList";

  /// 购买坐骑
  static const String buyCar = "car/buyCar";

  /// app 活动
  static const String appActivity = "appactivity/list";

  /// 查询可积分兑换的礼物列表
  static const String exchangeGiftList = "bagpack/listExchangeGift";

  /// 兑换记录
  static const String exchangeRecord = "exchange/listUserExchangeRecord";

  /// 积分兑换礼物
  static const String exchangeGift = "exchange/exchangeGift";

  /// 用户背包礼物
  static const String userPackageList = "bagpack/listUserBagpackGifs";

  /// 查询剩余可用积分
  static const String remainPoints = "account/getUserRemainingRewardPoint";

  /// 分类和标签接口
  static const String categoryLabel = "liveRoom/categoryLabel";

  /// 首页Banner
  static const String advertiseBanner = "advertise/showAdvertise";

  /// 站内信、消息
  static const String announcementList = "announcement/list";

  /// 关注列表
  static const String followList = "user/info";

  /// IM信息
  static const String chatRoomAccount = "user/chatRoomAccount";

  /// 获取验证码
  static const String smsSend = "captcha/sms/send";

  /// 绑定手机号
  static const String bindPhone = "user/bindPhone";

  /// 切换直播间
  static const String changeRoom = "change/room";

  /// 所有请求
  static Map<String, HttpTickContainer Function()> request = {
    guestlogIn: () => GuestLogin(),
    userWeChatAccessToken: () => WeChatAuth(),
    registered: () => Register(),
    logIn: () => Login(),
    // liveToken: ()=> LiveToken(),
    uploadImage: () => UploadImage(),
    userInfo: () => UserInfo(),
    editUserInfo: () => EditUserInfo(),
    settingInfo: () => SettingInfo(),
    settingUpdate: () => SettingUpdate(),
    blackList: () => BlackList(),
    deleteBlackList: () => DeleteBlackList(),
    insertBlackList: () => InsertBlackList(),
    favoritePaging: () => FavoritePaging(),
    favoriteInsert: () => FavoriteInsert(),
    favoriteDelete: () => FavoriteDelete(),
    logOut: () => LogOut(),
    anchorList: () => AnchorList(),
    createCommonRoom: () => CreateLiveRoom(),
    // createGameRoom: ()=> CreateGameRoom(),
    // createTickerAmountRoom: ()=> CreateTicketAmountRoom(),
    // createTimeDeductionRoom: ()=> CreateTimeDeductionRoom(),
    // anchorExitRoom: ()=> AnchorExitRoom(),
    destroyRoom: () => DestroyRoom(),
    brushGift: () => BrushGift(),
    audienceExitRoom: () => AudienceExitRoom(),
    // audienceExitAndAttention: ()=> AudienceExitAndAttention(),
    // audienceCount: ()=> AudienceCount(),
    liveRoomRank: () => LiveRoomRank(),
    // monthRank: ()=> MonthRank(),
    // weekRank: ()=> WeekRank(),
    getUserInfo: () => GetUserInfo(),
    roomGiftList: () => GetRoomGiftList(),
    addAudience: () => AddAudience(),
    nearAnchor: () => NearAnchor(),
    locationSave: () => LocationSave(),
    // getAnchors: () => GetAnchor(),
    // indexDailyRank: () => IndexDailyRank(),
    // indexMonthRank: () => IndexMonthRank(),
    indexRank: () => IndexRank(),
    heartBeat: () => TencentHeartBeat(),
    // createPasswordRoom: ()=> CreatePasswordRoom(),
    banner: () => HomeBanner(),
    liveRoomInfo: () => LiveRoomInfo(),
    // homeSearch: ()=> HomeSearch(),
    getUserById: () => UserInfoById(),
    anchorContributionList: () => AnchorContributionList(),
    showConsPage: () => ShowConsPage(),
    chargeDiamond: () => ChargeDiamond(),
    balanceRecharge: () => BalanceRecharge(),
    anchorLabel: () => AnchorLabel(),
    liveRoomVerify: () => VerifyRoom(),
    timerLiveRoom: () => TimerLiveRoom(),
    banSpeak: () => BanSpeak(),
    deleteBanSpeak: () => DeleteBanSpeak(),
    banSpeakList: () => BanSpeakList(),
    systemParameter: () => SystemParameterList(),
    withdraw: () => Withdraw(),
    bet: () => Bet(),
    gameConfig: () => GameConfig(),
    runtimeGame: () => RuntimeGame(),
    audienceNumber: () => AudienceNumber(),
    livingRoomRecommend: () => LivingRoomRecommend(),
    lotteryLog: () => LotteryLog(),
    betLog: () => BetLog(),
    showBank: () => ShowBank(),
    bindBankDelete: () => DeleteBindBank(),
    bindBankInfo: () => UserBindBankInfo(),
    userBindList: () => BindBankList(),
    userBindBankModify: () => UserBindBankModify(),
    systemBankList: () => SystemBankList(),
    createOrder: () => CreateOrder(),
    payNotify: () => PayNotifyUrl(),
    withdrawNew: () => WithdrawNew(),
    sendVerificationCode: () => SendVerificationCode(),
    forgetPassword: () => ForgetPassword(),
    gradeList: () => GradeList(),
    anchorRank: () => AnchorRank(),
    userGiftRank: () => UserGiftRank(),
    fansPage: () => FansPage(),
    anchorOnlineNumber: () => AnchorOnlineNumber(),
    livingAddStatus: () => LivingAddStatus(),
    livingCancelStatus: () => LivingCancelStatus(),
    systemParamList: () => SysParamMap(),
    withdrawInfo: () => WithdrawInfo(),
    accountDetail: () => AccountDetail(),
    betRecord: () => BetRecord(),
    chargeRecord: () => ChargeRecord(),
    giftFormReport: () => AnchorGiftFormReport(),
    livingTimeSlot: () => LivingTimeSlot(),
    modifyLogInPassword: () => ModifyLogInPassword(),
    modifyWithdrawPassword: () => ModifyWithdrawPassword(),
    anchorFeedback: () => AnchorFeedback(),
    contributionListInLiving: () => ContributionListInLiving(),
    upgradeVersion: () => UpgradeVersion(),
    appDownload: () => AppDownload(),
    firebaseSubmit: () => FireBaseTokenSubmit(),
    customService: () => CustomServicesList(),
    useCar: () => UseCar(),
    carList: () => CarList(),
    buyCar: () => CarBuy(),
    appActivity: () => AppActivity(),
    searchAnchorType: () => SearchAnchorOnType(),
    systemDictionary: () => SystemDictionary(),
    remainPoints: () => UserRemainingRewardPoint(),
    exchangeGift: () => PointExchangeGift(),
    exchangeRecord: () => UserExchangeRecord(),
    exchangeGiftList: () => ExchangeGiftList(),
    userPackageList: () => UserPackageList(),

    categoryLabel: () => CateGoryLabel(),
    followAnchorList: () => FollowAnchorListLabel(),
    advertiseBanner: () => AdvertiseBanner(),
    announcementList: () => AnnouncementList(),
    followList: () => FollowList(),
    chatRoomAccount: () => ChatRoomAccount(),
    smsSend: () => SmsSend(),
    bindPhone: () => BindPhone(),
    changeRoom: () => ChangeRoom()
  };
}

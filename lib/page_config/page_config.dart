/*
 *  Copyright (C), 2015-2021
 *  FileName: page_config
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/pages/about_us/about_us.dart';
import 'package:hjnzb/pages/account_security/account_security.dart';
import 'package:hjnzb/pages/advertising/advertising.dart';
import 'package:hjnzb/pages/announcement_list_page/announcement_list_page.dart';
import 'package:hjnzb/pages/app_share/app_share.dart';
import 'package:hjnzb/pages/balance_recharge/balance_recharge.dart';
import 'package:hjnzb/pages/bind_bank/bind_bank.dart';
import 'package:hjnzb/pages/bind_bank_card/bind_bank_card.dart';
import 'package:hjnzb/pages/bind_bank_manager/bind_bank_manager.dart';
import 'package:hjnzb/pages/black_list/black_list.dart';
import 'package:hjnzb/pages/change_log_in_password/change_log_in_password.dart';
import 'package:hjnzb/pages/change_payment_password/change_payment_password.dart';
import 'package:hjnzb/pages/charge/charge.dart';
import 'package:hjnzb/pages/charge/url_page.dart';
import 'package:hjnzb/pages/chats_list/chats_list.dart';
import 'package:hjnzb/pages/contact_service_page/app_activity_image.dart';
import 'package:hjnzb/pages/contact_service_page/contact_service_page.dart';
import 'package:hjnzb/pages/conversation/conversation.dart';
import 'package:hjnzb/pages/custom_service_list/custom_service_list.dart';
import 'package:hjnzb/pages/diamond_recharge/diamond_recharge.dart';
import 'package:hjnzb/pages/edit_personal_information/edit_page.dart';
import 'package:hjnzb/pages/favorite/fans_new.dart';
import 'package:hjnzb/pages/favorite/favorite.dart';
import 'package:hjnzb/pages/favorite/favorite_new.dart';
import 'package:hjnzb/pages/feedback/feedback.dart';
import 'package:hjnzb/pages/forget_password/forget_password.dart';
import 'package:hjnzb/pages/grade/grade.dart';
import 'package:hjnzb/pages/invitation_code/invitation_code.dart';
import 'package:hjnzb/pages/list/list_page.dart';
import 'package:hjnzb/pages/list/total_list_page.dart';
import 'package:hjnzb/pages/live_room/live_room.dart';
import 'package:hjnzb/pages/live_room/live_room_anchor.dart';
import 'package:hjnzb/pages/live_room/live_room_new.dart';
import 'package:hjnzb/pages/live_room_preview/live_room_preview.dart';
import 'package:hjnzb/pages/live_room_preview/live_room_preview_new.dart';
import 'package:hjnzb/pages/login/login.dart';
import 'package:hjnzb/pages/login/login_new.dart';
import 'package:hjnzb/pages/modify_password/modify_log_in.dart';
import 'package:hjnzb/pages/modify_password/modify_pay_password.dart';
import 'package:hjnzb/pages/muting_list/muting_list.dart';
import 'package:hjnzb/pages/my_mine/my_fans/my_fans_view.dart';
import 'package:hjnzb/pages/my_mine/mine_backpack/mine_backpack_view.dart';
import 'package:hjnzb/pages/my_mine/mine_phone_approve/mine_phone_approve_view.dart';
import 'package:hjnzb/pages/my_mine/my_mine_info/my_mine_info_view.dart';
import 'package:hjnzb/pages/my_mine/my_mine_setting/my_mine_setting_view.dart';
import 'package:hjnzb/pages/my_mine/mine_edit_info/mine_edit_info_view.dart';
import 'package:hjnzb/pages/personal_information/other_information.dart';
import 'package:hjnzb/pages/points_redemption/points_redemption_view.dart';
import 'package:hjnzb/pages/points_redemption_record/points_redemption_record_view.dart';
import 'package:hjnzb/pages/rank/anchor_rank_page.dart';
import 'package:hjnzb/pages/rank/rank_integration.dart';
import 'package:hjnzb/pages/rank/user_rank_in_living.dart';
import 'package:hjnzb/pages/rank/user_rank_page.dart';
import 'package:hjnzb/pages/register/register.dart';
import 'package:hjnzb/pages/register/register_new.dart';
import 'package:hjnzb/pages/setting/setting.dart';
import 'package:hjnzb/pages/setting/setting_new_view.dart';
import 'package:hjnzb/pages/switch_way/switch_way.dart';
import 'package:hjnzb/pages/tab/tab.dart';
import 'package:hjnzb/pages/personal_information/personal_information.dart';
import 'package:hjnzb/pages/edit_personal_information/edit_personal_information.dart';
import 'package:hjnzb/pages/test_page/test_page.dart';
import 'package:hjnzb/pages/vip_grade/vip_grade.dart';
import 'package:hjnzb/pages/wallet_detail/wallet_detail.dart';
import 'package:hjnzb/pages/withdraw/withdraw.dart';
import 'package:hjnzb/pages/withdraw/withdraw_new.dart';
import 'package:hjnzb/pages/withdraw_record/account_detail.dart';
import 'package:hjnzb/pages/withdraw_record/anchor_gift_report.dart';
import 'package:hjnzb/pages/withdraw_record/bet_record.dart';
import 'package:hjnzb/pages/withdraw_record/charge_record.dart';
import 'package:hjnzb/pages/withdraw_record/living_time_slot.dart';
import 'package:hjnzb/pages/withdraw_record/withdraw_record.dart';
import '../pages/recharge/recharge_diamond _view.dart';

class AppRoutes {
  AppRoutes._();

  /// tab
  static const String tab = "/tab";

  // 个人中心x
  static const String personalInformation = "/personalInformation";

  // 编辑个人资料
  static const String editPersonalInformation = "/editPersonalInformation";

  // 榜单
  static const String listPage = "/listPage";

  // 设置页面
  static const String setting = "/setting";
  static const String settingNew = "/settingNew";

  // 积分兑换
  static const String pointsRedemption = "/pointsRedemption";

  /// 积分兑换记录
  static const String pointsRedemptionRecord = "/pointsRedemptionRecord";

  // 我的关注
  static const String favorite = "/favorite";

  // 钱包
  static const String walletDetail = "/walletDetail";

  // 钻石充值
  static const String diamondRecharge = "/diamondRecharge";

  // 提现
  static const String withdraw = "/withdrawPage";

  // 绑定银行卡
  static const String bindBankCard = "/bindBankCardPage";

  // 直播间
  static const String liveRoom = "/liveRoom";

  // 编辑
  static const String editPage = "/editPage";

  // 黑名单
  static const String blackList = "/blackList";

  /// 登录
  static const String logIn = "/logIn";

  /// 预览
  static const String preview = "/preview";

  /// 聊天
  static const String conversation = "/conversation";

  /// 聊天列表
  static const String conversationList = "/conversationList";

  /// 其他人信息
  static const String userById = "/userById";

  /// 总排行榜
  static const String totalList = "/totalList";

  /// 注册页面
  static const String register = "/registerPage";

  /// 余额充值
  static const String balanceRecharge = "/balanceRecharget";

  /// 广告
  static const String advertising = "/advertisingPage";

  /// 禁言列表
  static const String mutingList = "/mutingList";

  /// 账号安全
  static const String accountSecurity = "/accountSecurity";

  /// 修改登录密码
  static const String changeLogInPassword = "/changeLogInPassword";

  /// 等级
  static const String gradePage = "/gradePage";

  /// 修改支付密码
  static const String changePaymentPassword = "/changePaymentPassword";

  /// 充值页面
  static const String chargePage = "/chargePage";

  /// 绑定银行卡
  static const String bindBank = "/bindBank";

  /// 绑定银行卡管理
  static const String bindBankManger = "/bindBankManager";

  /// 充值url页面
  static const String urlPage = "/urlPage";

  /// 提现新页面
  static const String withdrawNew = "/withdrawNew";

  /// 测试页面
  static const String testPage = "/testPage";

  /// 新登录页面
  static const String logInNew = "/logInNewPage";

  /// 新注册页面
  static const String registerNew = "/registerNewPage";

  /// 忘记密码
  static const String forgetPassword = "/forgetPassword";

  /// vip 等级
  static const String vipGradePage = "/vipGradePage";

  /// 主播等级
  static const String anchorRank = "/anchorRank";

  /// 用户排行
  static const String userRank = "/userRank";

  /// 预览页
  static const String livingPreviewNew = "/livingPreviewNew";

  /// 观众
  static const String audiencePage = "/audiencePage";

  /// 主播页面
  static const String anchorPage = "/anchorPage";

  /// 提现记录页面
  static const String withdrawRecord = "/withdrawRecord";

  /// 账户明细
  static const String accountDetail = "/accountDetail";

  /// 下注记录
  static const String betRecord = "/betRecord";

  /// 下注记录
  static const String chargeRecord = "/chargeRecord";

  /// 礼物报表
  static const String anchorGiftFormReport = "/anchorGiftFormReport";

  /// 直播时段
  static const String livingTimeSlot = "/livingTimeSlot";

  /// 粉丝列表
  static const String fansList = "/fansList";

  /// 关注列表
  static const String favoriteNewList = "/favoriteNewList";

  /// 修改登录密码
  static const String modifyLogInPassword = "/modifyLogInPassword";

  /// 修改支付密码
  static const String modifyPayPassword = "/modifyPayPassword";

  /// 关于我们
  static const String aboutUS = "/aboutUS";

  /// 反馈
  static const String anchorFeedback = "/anchorFeedback";

  /// 站内信、公告
  static const String announcementList = "/announcementList";

  /// 切换线路
  static const String switchWay = "/switchWay";

  /// 联系客服
  static const String contactServicePage = "/contactServicePage";

  /// 用户直播间排行榜
  static const String userRankInLiving = "/userRankInLiving";

  /// 直播间贡献榜
  static const String contributionInLiving = "/contributionInLiving";

  /// 排行榜集成
  static const String rankIntegration = "/rankIntegration";

  /// 邀请码
  static const String invitationCode = "/invitationCode";

  /// 客服列表
  static const String customListService = "/customListService";

  /// 坐骑列表
  static const String carList = "/carList";

  /// 图片展示
  static const String imageUrlDisplay = "/imageUrlDisplay";

  /// app分享
  static const String appShare = "/appShare";

  /// 兑换钻石
  static const String redeemDiamonds = "/redeemDiamonds";

  /// 设置
  static const String mineSetting = "/my_mine/my_mine_setting";

  /// 个人资料
  static const String mineInfo = "/my_mine/my_mine_info";

  //关注粉丝
  static const String mineFloowAndFans = "/my_mine/my_fans";

  /// 我的/手机认证
  static const String minePhoneApprovePage = "/minePhoneApprovePage";

  /// 我的/编辑个人资料
  static const String mineEditInfo = "/mineEditInfo";

  /// 我的/我的背包
  static const String mineBackpackPage = "/mineBackpackPage";

  /// 我的/编辑资料/编辑签名
  static const String editSignaturePage = "/editSignaturePage";
}

class _PageConfig {
  _PageConfig({required this.pageRoute, required this.getInstance});

  /// 路由名称
  final String pageRoute;

  final Widget Function(Map<String, dynamic>?) getInstance;
}

Map<String, _PageConfig> pageConfig = {
  AppRoutes.tab: _PageConfig(
      pageRoute: AppRoutes.tab, getInstance: (arguments) => TabContainer()),
  AppRoutes.personalInformation: _PageConfig(
      pageRoute: AppRoutes.personalInformation,
      getInstance: (arguments) => PersonalInformation()),
  AppRoutes.editPersonalInformation: _PageConfig(
      pageRoute: AppRoutes.editPersonalInformation,
      getInstance: (arguments) =>
          EditPersonalInformation(arguments: arguments)),
  AppRoutes.mineEditInfo: _PageConfig(
      pageRoute: AppRoutes.mineEditInfo,
      getInstance: (arguments) => MineEditInfoPage()),
  AppRoutes.listPage: _PageConfig(
      pageRoute: AppRoutes.listPage,
      getInstance: (arguments) => ListPage(anchorId: (arguments ?? {})["id"])),
  AppRoutes.setting: _PageConfig(
      pageRoute: AppRoutes.setting, getInstance: (arguments) => SettingPage()),
  AppRoutes.favorite: _PageConfig(
      pageRoute: AppRoutes.favorite,
      getInstance: (arguments) => FavoritePage()),
  AppRoutes.walletDetail: _PageConfig(
      pageRoute: AppRoutes.walletDetail,
      getInstance: (arguments) => WalletDetailPage()),
  AppRoutes.diamondRecharge: _PageConfig(
      pageRoute: AppRoutes.diamondRecharge,
      getInstance: (argument) => DiamondRechargePage()),
  AppRoutes.withdraw: _PageConfig(
      pageRoute: AppRoutes.withdraw, getInstance: (argument) => WithdrawPage()),
  AppRoutes.bindBankCard: _PageConfig(
      pageRoute: AppRoutes.bindBankCard,
      getInstance: (argument) => BindBankCardPage()),
  AppRoutes.liveRoom: _PageConfig(
      pageRoute: AppRoutes.liveRoom,
      getInstance: (arguments) => LiveRoomPage(arguments: arguments)),
  AppRoutes.editPage: _PageConfig(
      pageRoute: AppRoutes.editPage,
      getInstance: (arguments) => EditPage(arguments: arguments)),
  AppRoutes.blackList: _PageConfig(
      pageRoute: AppRoutes.blackList, getInstance: (_) => BlackList()),
  AppRoutes.logIn:
      _PageConfig(pageRoute: AppRoutes.logIn, getInstance: (_) => LogInPage()),
  AppRoutes.preview: _PageConfig(
      pageRoute: AppRoutes.preview, getInstance: (_) => LiveRoomPreviewPage()),
  AppRoutes.conversation: _PageConfig(
      pageRoute: AppRoutes.conversation,
      getInstance: (arguments) => ConversationPage(arguments: arguments)),
  AppRoutes.conversationList: _PageConfig(
      pageRoute: AppRoutes.conversationList,
      getInstance: (_) => ChatsListPage()),
  AppRoutes.userById: _PageConfig(
      pageRoute: AppRoutes.userById,
      getInstance: (arguments) => OtherUserInfo(arguments: arguments)),
  AppRoutes.totalList: _PageConfig(
      pageRoute: AppRoutes.totalList,
      getInstance: (arguments) => TotalListPage(arguments: arguments)),
  AppRoutes.register: _PageConfig(
      pageRoute: AppRoutes.register, getInstance: (_) => RegisterPage()),
  AppRoutes.balanceRecharge: _PageConfig(
      pageRoute: AppRoutes.balanceRecharge,
      getInstance: (_) => BalanceRechargePage()),
  AppRoutes.advertising: _PageConfig(
      pageRoute: AppRoutes.advertising,
      getInstance: (arguments) => AdvertisingPage()),
  AppRoutes.mutingList: _PageConfig(
      pageRoute: AppRoutes.mutingList,
      getInstance: (arguments) => MutingList(arguments: arguments)),
  AppRoutes.accountSecurity: _PageConfig(
      pageRoute: AppRoutes.accountSecurity,
      getInstance: (_) => AccountSecurityPage()),
  AppRoutes.changeLogInPassword: _PageConfig(
      pageRoute: AppRoutes.changeLogInPassword,
      getInstance: (_) => ChangeLogInPasswordPage()),
  AppRoutes.gradePage: _PageConfig(
      pageRoute: AppRoutes.gradePage, getInstance: (_) => GradePage()),
  AppRoutes.changePaymentPassword: _PageConfig(
      pageRoute: AppRoutes.changePaymentPassword,
      getInstance: (_) => ChangePaymentPasswordPage()),
  AppRoutes.chargePage: _PageConfig(
      pageRoute: AppRoutes.chargePage,
      getInstance: (arguments) => ChargePage(arguments: arguments)),
  AppRoutes.bindBank: _PageConfig(
      pageRoute: AppRoutes.bindBank, getInstance: (_) => BindBank()),
  AppRoutes.bindBankManger: _PageConfig(
      pageRoute: AppRoutes.bindBankManger,
      getInstance: (arguments) => BindBankManager(arguments: arguments)),
  AppRoutes.urlPage: _PageConfig(
      pageRoute: AppRoutes.urlPage,
      getInstance: (arguments) => UrlPage(arguments: arguments)),
  AppRoutes.withdrawNew: _PageConfig(
      pageRoute: AppRoutes.withdrawNew, getInstance: (_) => WithDrawNew()),
  AppRoutes.testPage: _PageConfig(
      pageRoute: AppRoutes.testPage, getInstance: (_) => TestPage()),
  AppRoutes.logInNew: _PageConfig(
      pageRoute: AppRoutes.logInNew, getInstance: (_) => LogInNewPage()),
  AppRoutes.registerNew: _PageConfig(
      pageRoute: AppRoutes.registerNew,
      getInstance: (arguments) => RegisterNewPage(arguments: arguments)),
  AppRoutes.forgetPassword: _PageConfig(
      pageRoute: AppRoutes.forgetPassword,
      getInstance: (_) => ForgetPassword()),
  AppRoutes.vipGradePage: _PageConfig(
      pageRoute: AppRoutes.vipGradePage, getInstance: (_) => VipGradePage()),
  AppRoutes.anchorRank: _PageConfig(
      pageRoute: AppRoutes.anchorRank, getInstance: (_) => AnchorRankPage()),
  AppRoutes.userRank: _PageConfig(
      pageRoute: AppRoutes.userRank, getInstance: (_) => UserRankPage()),
  AppRoutes.livingPreviewNew: _PageConfig(
      pageRoute: AppRoutes.livingPreviewNew,
      getInstance: (_) => LiveRoomPreviewNewPage()),
  AppRoutes.audiencePage: _PageConfig(
      pageRoute: AppRoutes.audiencePage,
      getInstance: (arguments) => AudienceNewPage(arguments: arguments)),
  AppRoutes.anchorPage: _PageConfig(
      pageRoute: AppRoutes.anchorPage,
      getInstance: (arguments) => LiveRoomAnchorPage(arguments: arguments)),
  AppRoutes.withdrawRecord: _PageConfig(
      pageRoute: AppRoutes.withdrawRecord,
      getInstance: (_) => WithdrawRecord()),
  AppRoutes.accountDetail: _PageConfig(
      pageRoute: AppRoutes.accountDetail, getInstance: (_) => AccountDetail()),
  AppRoutes.betRecord: _PageConfig(
      pageRoute: AppRoutes.betRecord, getInstance: (_) => BetRecordPage()),
  AppRoutes.chargeRecord: _PageConfig(
      pageRoute: AppRoutes.chargeRecord,
      getInstance: (_) => ChargeRecordPage()),
  AppRoutes.anchorGiftFormReport: _PageConfig(
      pageRoute: AppRoutes.anchorGiftFormReport,
      getInstance: (_) => AnchorGiftReportPage()),
  AppRoutes.livingTimeSlot: _PageConfig(
      pageRoute: AppRoutes.livingTimeSlot,
      getInstance: (_) => LivingTimeSlotPage()),
  AppRoutes.fansList: _PageConfig(
      pageRoute: AppRoutes.fansList, getInstance: (_) => FansNewPage()),
  AppRoutes.favoriteNewList: _PageConfig(
      pageRoute: AppRoutes.favoriteNewList,
      getInstance: (_) => FavoriteNewPage()),
  AppRoutes.modifyLogInPassword: _PageConfig(
      pageRoute: AppRoutes.modifyLogInPassword,
      getInstance: (_) => ModifyLogInPasswordPage()),
  AppRoutes.modifyPayPassword: _PageConfig(
      pageRoute: AppRoutes.modifyPayPassword,
      getInstance: (_) => ModifyPayPasswordPage()),
  AppRoutes.anchorFeedback: _PageConfig(
      pageRoute: AppRoutes.modifyPayPassword,
      getInstance: (_) => AnchorFeedbackPage()),
  AppRoutes.aboutUS: _PageConfig(
      pageRoute: AppRoutes.modifyPayPassword,
      getInstance: (_) => AboutUSPage()),
  AppRoutes.announcementList: _PageConfig(
      pageRoute: AppRoutes.announcementList,
      getInstance: (_) => AnnouncementPage()),
  AppRoutes.switchWay: _PageConfig(
      pageRoute: AppRoutes.switchWay, getInstance: (_) => SwitchWayPage()),
  AppRoutes.contactServicePage: _PageConfig(
      pageRoute: AppRoutes.contactServicePage,
      getInstance: (arguments) => ContactServicePage(arguments: arguments)),
  AppRoutes.userRankInLiving: _PageConfig(
      pageRoute: AppRoutes.userRankInLiving,
      getInstance: (_) => UserRankInLivingPage()),
  AppRoutes.contributionInLiving: _PageConfig(
      pageRoute: AppRoutes.contributionInLiving,
      getInstance: (arguments) => UserRankInLivingPage(arguments: arguments)),
  AppRoutes.rankIntegration: _PageConfig(
      pageRoute: AppRoutes.rankIntegration,
      getInstance: (_) => RankIntegrationPage()),
  AppRoutes.invitationCode: _PageConfig(
      pageRoute: AppRoutes.invitationCode,
      getInstance: (_) => InvitationCodePage()),
  AppRoutes.customListService: _PageConfig(
      pageRoute: AppRoutes.customListService,
      getInstance: (_) => CustomServiceListPage()),
  AppRoutes.imageUrlDisplay: _PageConfig(
      pageRoute: AppRoutes.imageUrlDisplay,
      getInstance: (arguments) => AppActivityImagePage(arguments: arguments)),
  AppRoutes.appShare: _PageConfig(
      pageRoute: AppRoutes.appShare,
      getInstance: (arguments) => AppSharePage(arguments: arguments)),
  AppRoutes.settingNew: _PageConfig(
      pageRoute: AppRoutes.settingNew, getInstance: (_) => SettingNewPage()),
  AppRoutes.pointsRedemption: _PageConfig(
      pageRoute: AppRoutes.pointsRedemption,
      getInstance: (_) => PointsRedemptionPage()),
  AppRoutes.pointsRedemptionRecord: _PageConfig(
      pageRoute: AppRoutes.pointsRedemptionRecord,
      getInstance: (_) => PointsRedemptionRecordPage()),
  AppRoutes.redeemDiamonds: _PageConfig(
      pageRoute: AppRoutes.redeemDiamonds,
      getInstance: (_) => RechargeDiamondPage()),
  AppRoutes.mineSetting: _PageConfig(
      pageRoute: AppRoutes.mineSetting,
      getInstance: (_) => MyMineSettingPage()),
  AppRoutes.mineInfo: _PageConfig(
      pageRoute: AppRoutes.mineInfo, getInstance: (_) => MyMineInfoPage()),
  AppRoutes.mineFloowAndFans: _PageConfig(
      pageRoute: AppRoutes.mineFloowAndFans, getInstance: (_) => MyFansPage()),
  AppRoutes.mineBackpackPage: _PageConfig(
      pageRoute: AppRoutes.mineBackpackPage,
      getInstance: (_) => MineBackpackPage()),
  AppRoutes.minePhoneApprovePage: _PageConfig(
      pageRoute: AppRoutes.minePhoneApprovePage,
      getInstance: (_) => MinePhoneApprovePage()),
  AppRoutes.editSignaturePage: _PageConfig(
      pageRoute: AppRoutes.editSignaturePage,
      getInstance: (arguments) => EditSignaturePage(arguments: arguments)),
};

/*
 *  Copyright (C), 2015-2021
 *  FileName: user
 *  Author: Tonight丶相拥
 *  Date: 2021/7/29
 *  Description: 
 **/

part of appmanager;

class AppUser extends CommonNotifierModel with _TokenMixin{
  AppUser._();
  void fromJson(Map<String, dynamic> json, [bool needSetToken = true, bool needNotification = true]){
    if (needSetToken)
      _setTokenWithJson(json);
    _fromJson(json, needNotification);
  }

  void _fromJson(Map<String, dynamic> json, [bool needNotification = true]){
    this.attentionNum = json["attentionNum"];
    this.fansNum = json["fansNum"];
    this.signature = json["signature"];
    this.name = json["username"];
    this.header = json["header"];
    this.rank = json["rank"] ?? 0;
    this._userId = json["userId"];
    this.withdraw = double.tryParse(json["withdraw"].toString());
    this.wallet = double.tryParse(json["balance"].toString());
    this._userSig = json["usersig"];
    this._memberId = json["memberId"];
    // this.withdraw = json["withdraw"]?.toDouble();
    this.studioToken = json["mlvbToken"];
    this._sex = json["sex"];
    this._birthday = json["birthday"];
    this._accountId = json["accountId"];
    this._coins = double.tryParse(json["coins"].toString());
    this._reward = double.tryParse(json["reward"].toString());
    this._recharge = double.tryParse(json["recharge"].toString());
    this._guestLoss = double.tryParse(json["guestLoss"].toString());
    this._constellation = json["constellation"];
    this._profession = json["profession"];
    this._hometown = json["hometown"];
    this._feeling = json["feeling"];
    this._sendOut = json["sendOut"];
    this._hxPassword = json["hxPassword"];
    this._hxAccount = json["hxUsername"];
    this._lockMoney = double.tryParse(json["lockMoney"].toString());
    this._enableOpenLive = json["openLiveFlag"];
    this.withdrawPassword = json["withdrawPassword"] ?? "";
    if (this.hasListeners && needNotification) {
      this.notifyListeners();
    }
    _save();
  }

  /// 设置token
  void setToken(Map<String, dynamic> json){
    _setTokenWithJson(json);
  }

  void fromMemory(String? jsonStr){
    _setTokenWithString(jsonStr);
  }

  // 更新数据
  void userUpdate(Map<String, dynamic> json){
    // this.birthday = json["birthday"];
    // this.hometown = json["city"];
    // this.feeling = json["emotion"];
    this.header = json["header"];
    this.name = json["name"];
    // this.profession = json["profession"];
    // this.sex = json["sex"];
    this.signature = json["signature"];
    updateState();
  }

  void userUpdateIM(IMRoomAccountEntity entry){
    // this.birthday = json["birthday"];
    // this.hometown = json["city"];
    // this.feeling = json["emotion"];
    this._hxAccount = entry.chatUsername;
    this._hxPassword = entry.chatPassword;
    updateState();
  }

  void updateData(Map<String, dynamic> json){
    this._birthday = json["birthday"];
    this._hometown = json["city"];
    this._feeling = json["emotion"];
    this.header = json["header"];
    this.name = json["name"];
    this._profession = json["profession"];
    this._sex = json["sex"];
    this.signature = json["signature"];
    if (this.hasListeners) {
      this.notifyListeners();
    }
    this._save();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    Map<String, dynamic> json = super.toJson();
    json["attentionNum"] = this.attentionNum;
    json["fansNum"] = this.fansNum;
    json["signature"] = this.signature;
    json["name"] = this.name;
    json["header"] = this.header;
    json["rank"] = this.rank ?? 0;
    json["userId"] = this._userId;
    json["withdraw"] = this.withdraw ?? 0.0;
    json["balance"] = this.wallet;
    json["usersig"] = this._userSig;
    json["memberId"] = this._memberId;
    json["studioToken"] = this.studioToken;
    json["sex"] = this._sex;
    json["birthday"] = this._birthday;
    json["accountId"] = this._accountId;
    json["coins"] = this._coins;
    json["reward"] = this._reward;
    json["recharge"] = this._recharge;
    json["guestLoss"] = this._guestLoss;
    json["profession"] = this._profession;
    json["constellation"] = this._constellation;
    json["profession"] = this._profession;
    json["hometown"] = this._hometown;
    json["feeling"] = this._feeling;
    json["sendOut"] = this._sendOut;
    json["hxUsername"] = this._hxAccount;
    json["hxPassword"] = this._hxPassword;
    json["lockMoney"] = this._lockMoney;
    json["openLiveFlag"] = this._enableOpenLive;
    return json;
  }

  void addAttention() {
    this.attentionNum = (this.attentionNum ?? 0) + 1;
    updateState();
  }

  void removeAttention(){
    if (this.attentionNum != null && this.attentionNum! > 0) {
      this.attentionNum = this.attentionNum! - 1;
      updateState();
    }
  }

  void chargeDiamond(int balance){
    if (this.wallet == null)
      return;
    this.wallet = this.wallet! - balance;
    updateState();
  }

  void chargeBalance(double balance){
    this.wallet = (this.wallet ?? 0) + balance;
    updateState();
  }

  void logOut(){
    this.fromJson({}, true, false);
  }

  void updateMoney(Map<String, dynamic> json){
    var key = "coins";
    if (json.containsKey(key))
      this._coins = double.tryParse(json[key].toString()) ?? this.coins;
    key = "lockMoney";
    if (json.containsKey(key))
      this._lockMoney = double.tryParse(json[key].toString()) ?? this._lockMoney;
    updateState();
  }

  // token相关
  String? get token => _token;
  // bool get isExpire => DateTime.now().isAfter(_expire ?? DateTime.now().subtract(Duration(days: 1)));

  // 关注
  int? attentionNum;
  // 粉丝
  int? fansNum;
  // 钱包
  double? wallet;
  // 签名
  String? signature;
  // 名称
  String? name;
  // 头像
  String? header;
  // 等级
  int? rank;
  // 用户id
  String? _userId;
  String? get userId => _userId;
  // 成员id
  String? _memberId;
  String? get memberId => _memberId;
  // 提现
  double? withdraw;
  /// 签名 生成UserSig
  String? _userSig;
  String? get userSig => _userSig;
  String? studioToken;
  /// 性别
  int? _sex;
  int? get sex => _sex;
  /// 生日
  String? _birthday;
  String? get birthday => _birthday;
  /// 账户id
  String? _accountId;
  String? get accountId => _accountId;
  /// 可提现余额
  double? _coins;
  double? get coins => _coins;
  /// 不可提现余额
  double? _lockMoney;
  double? get lockMoney => _lockMoney;
  /// 酬金
  double? _reward;
  double? get reward => _reward;
  /// 充值
  double? _recharge;
  double? get recharge => _recharge;
  /// 未知字段
  double? _guestLoss;
  double? get guestLoss => _guestLoss;
  /// 星座
  String? _constellation;
  String? get constellation => _constellation;
  /// 职业
  String? _profession;
  String? get profession => _profession;
  /// 城镇
  String? _hometown;
  String? get hometown => _hometown;
  /// 情感
  String? _feeling;
  String? get feeling => _feeling;
  /// 送出
  int? _sendOut;
  int? get sendOut => _sendOut;

  String? _hxAccount;
  String? get hxAccount => _hxAccount;

  String? _hxPassword;
  String? get hxPassword => _hxPassword;
  int?  _enableOpenLive;
  bool get enableOpenLive => _enableOpenLive != null && _enableOpenLive == 1;
  String? withdrawPassword;
  bool get withdrawIsNull => withdrawPassword == null || withdrawPassword!.isEmpty;
}

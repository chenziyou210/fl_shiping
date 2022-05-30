
import 'package:flutter/cupertino.dart';

import '../../../../generated/anchor_list_model_entity.dart';

/// 游戏信息
class HomeGameInfo{
  // 命名函数
  HomeGameInfo({this.id, this.imageUrl});
  // 图片id
   String?   id;
  // 图片url
   String? imageUrl;
}

/// 跑马灯信息
class HomeMarqueeInfo{
  // // 命名函数
  // HomeMarqueeInfo({
  //   this.marqueeStr,
  // });
  // // 拼接的跑马灯数据
  //  String? marqueeStr;

  HomeMarqueeInfo({this.content, this.jumpPath,this.title});

  String? content;
  String? jumpPath;
  String? title;

  HomeMarqueeInfo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    jumpPath = json['jumpPath'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['content'] = this.content;
    data['jumpPath'] = this.jumpPath;
    data['title'] = this.title;
    return data;
  }

}

/// 轮播图
class HomeBannerInfo{
  // 命名函数
  HomeBannerInfo({this.pic, this.url});
  // 拼接的跑马灯数据
  //  String? imgUrl;
  String? pic;
  String? url;

  HomeBannerInfo.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pic'] = this.pic;
    data['url'] = this.url;
    return data;
  }


}

/// 主播信息
class HomeAnchorItemInfo{
  // 命名函数
  HomeAnchorItemInfo(
      {this.anchorTitle,
      this.anchorCount,
      this.anchorDes,
      this.city,
      this.province,
      this.billing,
      this.topLabel = false,
      });
  // 直播标题类型
  String? anchorTitle;
  // 直播描述
  String? anchorDes;
  // 直播描述
  String? anchorImgUrl;
  String? city;
  String? province;
  String? anchorCount;
  // top标签
  bool?   topLabel;
  // 计费
  String? billing;
}

/// 获取排行版
class HomeRankingInfo{
  // 命名函数
  HomeRankingInfo({
    this.nickname,
    this.firepower,
  });
  String? firepower;
  String? nickname;
}


class HomeInfoModel{
  HomeInfoModel({
    this.viewType,
});
  // 网格类型
   String? viewType;
   HomeGameInfo game =           HomeGameInfo();
   HomeMarqueeInfo marquee =     HomeMarqueeInfo();
   HomeRankingInfo ranking =     HomeRankingInfo();
   /// 单个主播
   AnchorListModelEntity anchorItem = AnchorListModelEntity();
   /// 主播列表 提供给直播间翻页
   List <AnchorListModelEntity >  anchorItems = [];
   List <HomeBannerInfo >  banner = [];

}

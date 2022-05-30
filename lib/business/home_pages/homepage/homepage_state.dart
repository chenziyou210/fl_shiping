import 'package:flutter/material.dart';
import 'package:hjnzb/business/home_pages/homepage/models/homepage_model.dart';


enum ListViewType {
  Game,
  Banner,
  Ranking,
  Anchor,
  Marquee,
}

class HomepageState {
  HomepageState({
    ///Initialize variables
    required this.homeList ,
  });
  ///游戏数组
  List<HomeInfoModel> homeList =  List.empty(growable: true);

  gameValues (){
    for(int i= 0 ; i < 8 ; i++){
      HomeInfoModel homeModel = HomeInfoModel();
      HomeGameInfo game =  HomeGameInfo();
      game.imageUrl = "https://img.iplaysoft.com/wp-content/uploads/2019/free-images/free_stock_photo.jpg";
      homeModel.game = game;
      homeModel.viewType = "Game";
      this.homeList.add(homeModel);
    }
    return this.homeList;
  }

  rankingValues(){
    HomeInfoModel homeModel = HomeInfoModel();
    HomeRankingInfo ranking = HomeRankingInfo();
    ranking.firepower = "2313.w";
    ranking.nickname = "希林娜依·高 荣登榜首第一名";
    homeModel.viewType = "Ranking";
    homeModel.ranking = ranking;
    this.homeList.add(homeModel);
  }

}

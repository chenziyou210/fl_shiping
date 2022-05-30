import 'package:get/get.dart';
import 'package:hjnzb/business/home_pages/homepage/homepage_view.dart';
import 'package:hjnzb/business/home_pages/homepage/models/homepage_model.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:httpplugin/http_result_container/http_result_container.dart';

import '../../../generated/anchor_list_model_entity.dart';
import '../../../pages/live/live_home_data.dart';
import 'homepage_state.dart';

class HomepageLogic extends GetxController {
  final HomepageState state = HomepageState(homeList: []);

  @override
  void onInit() {
    super.onInit();
    state.gameValues();
    this.appBannerLoad();
    this.dataRefresh();
    this.homeMarqueeInfoLoad();
    state.rankingValues();

  }


  /// 数据请求
  Future _dataRequest(int page, {Failure? failure, void Function(dynamic)? success}) {

    Future<HttpResultContainer> future;
    // if (this.type == null) {
    //   if(_type==1111){
    //     future = HttpChannel.channel.watchlistListByType(page);
    //   }else{
    //     future = HttpChannel.channel.anchorListByType(page, 0);
    //   }
    // }else {
    //   future = HttpChannel.channel.searchAnchorOnType(type!, page: page);
    // }
    future = HttpChannel.channel.anchorListByType(page, 0);
    return future..then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: failure,
            success: (data) {
              if (data is Map) {

                print("我成果了吗");
                List lst = data["data"] ?? [];
                // _count = data["total"];
                List<AnchorListModelEntity> anchorList = lst.map((e) => AnchorListModelEntity.fromJson(e)).toList();
                anchorList.forEach((element) {
                  HomeInfoModel homeModel = HomeInfoModel();
                  homeModel.viewType = "Anchor";
                  homeModel.anchorItem = element;
                  homeModel.anchorItems = anchorList;
                  state.homeList.add(homeModel);
                });

                success?.call(lst.map((e) => AnchorListModelEntity.fromJson(e)).toList());
              }
            }
        ));
  }

  /// banner
  Future appBannerLoad(){
    return HttpChannel.channel.advertiseBanner(advertiseType: 3)..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<HomeBannerInfo> banners = lst.map((e) => HomeBannerInfo.fromJson(e)).toList();
          HomeInfoModel homeModel = HomeInfoModel();
          homeModel.viewType = "Banner";
          homeModel.banner = banners;
          state.homeList.add(homeModel);
        }
    ));
  }

  @override
  Future dataRefresh() {
    // TODO: implement refresh
    // page = 1;
    return _dataRequest(1, failure: (e) {
      // showToast(e);
    }, success: (data){
      // dismiss();
      // page ++;
      // this.data = data;
       update();
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _dataRequest(1, failure: (e) {
      // showToast(e);
    }, success: (data){
      // page ++;
      // this.data += data;
      // updateState();
      update();

    });
  }

  Future homeMarqueeInfoLoad(){
    return HttpChannel.channel.announcementList(1)..then((value) => value.finalize(
        wrapper: WrapperModel(),
        success: (data) {
          List lst = data ?? [];
          List<HomeMarqueeInfo> announcement = lst.map((e) => HomeMarqueeInfo.fromJson(e)).toList();

           String tempContent = "";
          announcement.forEach((element) {
              tempContent = "$tempContent ${element.content}";
          });

          ///跑马灯模型
          HomeMarqueeInfo tempMarquee = HomeMarqueeInfo();
          tempMarquee.content = tempContent;
          ///列表 跑马模型
          HomeInfoModel homeModel = HomeInfoModel();
          homeModel.viewType = "Marquee";
          homeModel.marquee = tempMarquee;
          state.homeList.add(homeModel);

        }
    ));
  }

}

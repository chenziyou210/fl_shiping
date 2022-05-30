/*
 *  Copyright (C), 2015-2021
 *  FileName: live_detail_page
 *  Author: Tonight丶相拥
 *  Date: 2021/8/9
 *  Description: 
 **/

// import 'package:card_swiper/card_swiper.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/config/app_colors.dart';

// import 'package:hjnzb/generated/anchor_list_entity.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:get/get.dart';
import '../../components/components_view.dart';
import '../live_cell.dart';
import '../live_enum.dart';
import '../live_home_data.dart';
import 'live_detail_model.dart';
// import '../live_new_logic.dart';

class LiveDetailPage extends StatefulWidget {
  LiveDetailPage(this.type, {this.onTap, this.onTap1});

  final void Function(AnchorListModelEntity)? onTap;
  final void Function(List<AnchorListModelEntity> data, int index)? onTap1;

  // final AnchorType type;
  final int? type;

  @override
  createState() => _LiveDetailPageState();
}

class _LiveDetailPageState extends AppStateBase<LiveDetailPage>
    with AutomaticKeepAliveClientMixin {
  late final LiveViewModel _viewModel;
  late Future _future;
  final RefreshController _controller = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = LiveViewModel(widget.type);
    _future = _viewModel.dataRefresh();
    EventBus.instance.addListener(_onHomeLabelChange,
        name: homeLabelChange + "${widget.type}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventBus.instance.removeListener(_onHomeLabelChange,
        name: homeLabelChange + "${widget.type}");
  }

  void _onHomeLabelChange(dynamic value) {
    _viewModel.type = value;
    _viewModel.show();
    _viewModel.dataRefresh();
    // _controller.requestRefresh();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return ChangeNotifierProvider.value(value: _viewModel, child: body);
  }

  @override
  // TODO: implement body
  Widget get body => LoadingWidget(
      builder: (_, __) {
        return RefreshWidget(
            controller: _controller,
            children: [
              // SliverPadding(
              //     padding: EdgeInsets.zero,
              //     sliver: SelectorCustom<SettingViewModel,
              //             List<HomeHotGameEntity>>(
              //         builder: (value) {
              //           if (value.length == 0) {
              //             return SizedBox();
              //           }
              //           return [
              //             SizedBox(height: 8),
              //             Row(
              //               children: [
              //                 CustomText("${intl.hotGame}",
              //                     fontSize: 16.pt,
              //                     fontWeight: w_500,
              //                     color: Colors.black),
              //                 Spacer(),
              //                 Row(children: [
              //                   CustomText("${intl.more}",
              //                       fontSize: 12.pt,
              //                       fontWeight: w_400,
              //                       color: Color.fromARGB(255, 78, 75, 75)),
              //                   SizedBox(width: 8),
              //                   Image.asset(AppImages.forwardGray)
              //                 ]).cupertinoButton(onTap: () {
              //                   var index = 2;
              //                   EventBus.instance.notificationListener(
              //                       name: homeHotGameMoreTaped,
              //                       parameter: index);
              //                 })
              //               ],
              //             ),
              //             SizedBox(height: 8),
              //             SingleChildScrollView(
              //               scrollDirection: Axis.horizontal,
              //               child: Row(
              //                 children: value.map((e) {
              //                   return Column(children: [
              //                     ExtendedImage.network(e.icon,
              //                             width: 60,
              //                             height: 60,
              //                             fit: BoxFit.fill)
              //                         .clipRRect(
              //                             radius: BorderRadius.circular(6)),
              //                     SizedBox(height: 4),
              //                     CustomText("${e.name}",
              //                         fontSize: 12.pt,
              //                         fontWeight: w_400,
              //                         color: Colors.black)
              //                   ])
              //                       .sizedBox(width: 60)
              //                       .padding(
              //                           padding: EdgeInsets.only(right: 16))
              //                       .gestureDetector(onTap: () {
              //                     pushViewControllerWithName(
              //                         AppRoutes.contactServicePage,
              //                         arguments: {
              //                           "url": e.gameUrl,
              //                           "title": "",
              //                         });
              //                   });
              //                 }).toList(),
              //               ),
              //             ),
              //             SizedBox(height: 8)
              //           ]
              //               .column(
              //                   crossAxisAlignment: CrossAxisAlignment.start)
              //               .padding(
              //                   padding: EdgeInsets.symmetric(horizontal: 16));
              //         },
              //         selector: (s) => s.hotGame).offstage.sliverToBoxAdapter),
              SliverToBoxAdapter(
                child: UniversalBanner(),
              ),
              SliverToBoxAdapter(
                child: UniversalAnnouncement(),
              ),
              SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.pt),
                  sliver: SelectorCustom<LiveViewModel,
                          List<AnchorListModelEntity>>(
                      builder: (data) {
                        return NullWidget<List<AnchorListModelEntity>>(data,
                            builder: (_, value) {
                              return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.74,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8),
                                  delegate:
                                      SliverChildBuilderDelegate((_, index) {
                                    var model = data[index];
                                    var type = LiveEnum.common
                                        .getLiveType(model.roomType ?? 0);
                                    var v;
                                    if (type == LiveEnum.secret) {
                                      v = "***";
                                    } else if (type == LiveEnum.ticker) {
                                      v = model.ticketAmount;
                                    } else if (type == LiveEnum.timer) {
                                      v = model.timeDeduction;
                                    } else {
                                      v = "";
                                    }
                                    return GestureDetector(
                                        onTap: () {
                                          widget.onTap?.call(model);
                                          widget.onTap1?.call(data, index);
                                        },
                                        child: LiveCell(LiveCellViewModel(
                                            avatar: model.roomCover ?? "",
                                            //model.cover!,
                                            name: model.roomTitle ?? "",
                                            //model.name!,
                                            local: model.username ?? "",
                                            //model.city!,
                                            eventName: model.roomTitle ?? "",
                                            //model.labelName!,
                                            count: model.heat ?? 0,
                                            //model.order!
                                            liveType: model.roomType ?? 0,
                                            unit: v)));
                                  }, childCount: value.length)
                              );
                            },
                            predict: (d) => d.length == 0,
                            placeHolder: SliverFillRemaining(
                              child: DataEmptyWidget(),
                            ));
                      },
                      selector: (l) => l.data))
            ],
            enablePullUp: true,
            onRefresh: (c) async {
              await _viewModel.dataRefresh();
              c.refreshCompleted();
              c.resetNoData();
            },
            onLoading: (c) async {
              if (_viewModel.hasMoreData) await _viewModel.loadMore();
              if (_viewModel.hasMoreData) {
                c.loadComplete();
              } else {
                c.loadNoData();
              }
            });
      },
      future: _future);

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/business/home_pages/homepage/widget/homepage_widget.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/generated/anchor_list_model_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'homepage_logic.dart';
import 'homepage_state.dart';
import 'models/homepage_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeListWidgets extends StatelessWidget {
  final logic = Get.put(HomepageLogic());
  final state = Get.find<HomepageLogic>().state;

  late Future _future = logic.dataRefresh();
  final RefreshController _controller = RefreshController();

  final Function(List<AnchorListModelEntity>, int index) onTap;

  HomeListWidgets(this.onTap,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      LoadingWidget(
          builder: (_, __) {
            return RefreshWidget(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  /// 不加这个不让加载
                  SliverToBoxAdapter(
                    child:  Container(
                      color: Color(0xff101010),
                      child: StaggeredGridView.countBuilder(
                          physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                          crossAxisCount: 12,
                          padding: EdgeInsets.all(12),
                          shrinkWrap: true,
                          itemCount: state.homeList.length,
                          // itemCount: state.count,
                          itemBuilder: (BuildContext context, int index) {
                            ///构建 不同cell样式Widgt
                            HomeInfoModel itemModel = state.homeList[index];
                            int tempIndex = itemModel.anchorItems.indexOf(itemModel.anchorItem);
                            tempIndex == -1 ? 0 : tempIndex;
                            print("下边时候多是啊啊啊啊 ： $tempIndex");
                            return HomePageViews(itemModel, (){
                              onTap(itemModel.anchorItems, tempIndex)!;
                            });
                          },
                          staggeredTileBuilder: (int index) {
                            // MediaQuery.of(context).size.width = 高度
                            // StaggeredTile.extent(crossAxisCellCount, mainAxisExtent)
                            HomeInfoModel itemModel = state.homeList[index];
                            /// 构建 排列样式
                            switch (itemModel.viewType) {
                            //2排显示
                              case 'Anchor':return StaggeredTile.extent(6, 224);break;
                            //3排显示
                              case 'Nearby':return StaggeredTile.extent(4, 224);break;
                            //4排显示
                              case 'Game':return StaggeredTile.extent(3, 48);break;
                            //1单排显示
                              case 'Marquee':return StaggeredTile.extent(12, 48);break;
                              case 'Banner':return StaggeredTile.extent(12, 108);break;
                              case 'Ranking':return StaggeredTile.extent(12, 68);break;
                            // 默认两排布局 2
                              default:return StaggeredTile.extent(6, 224);break;
                            }
                          }
                      ),
                    ),
                  ),
                ],
                enablePullUp: true,
                onRefresh: (c) async {

                  c.refreshCompleted();
                },
                onLoading: (c) async {
                  logic.loadMore();
                  c.refreshCompleted();
                  c.loadNoData();

                });
          },
          future: _future);


  }
}
//
// Wiget sadas(){
//   LoadingWidget(
//       builder: (_, __) {
//         return RefreshWidget(
//             controller: _controller,
//             children: [
//
//             ],
//             enablePullUp: true,
//             onRefresh: (c) async {
//               await _viewModel.dataRefresh();
//               c.refreshCompleted();
//               c.resetNoData();
//             },
//             onLoading: (c) async {
//               if (_viewModel.hasMoreData) await _viewModel.loadMore();
//               if (_viewModel.hasMoreData) {
//                 c.loadComplete();
//               } else {
//                 c.loadNoData();
//               }
//             });
//       },
//       future: _future);
// }

testOntop() {
  print("asldalkdsjaskldj");
}
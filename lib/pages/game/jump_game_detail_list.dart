import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_images/app_images.dart';
import '../../base/app_base.dart';
import '../../common/app_common_widget.dart';
import '../../http/http_channel.dart';
import '../../manager/app_manager.dart';
import 'game_model.dart';
import 'jump_game_logic.dart';

class JumpGameDetailPage extends StatefulWidget {

  JumpGameDetailPage(this.gameType);

  final String? gameType;

  @override
  createState() => _JumpGameDetailPageState();
}

class _JumpGameDetailPageState extends AppStateBase<JumpGameDetailPage> {
  final logic = Get.put(JumpGameLogic());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(
        "JumpGameDetailPage: ${widget.gameType} ${logic.state.gameTabList.value.where((element) => element.gameType == widget.gameType).first.listData?.length}");
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    var gameType = widget.gameType;
    return Container(
        child: RefreshIndicator(
            // child: gameType == "HOT" ? gameGridViewList(gameList) : gameListView(gameList),
            child: GetBuilder<JumpGameLogic>(
              builder: (_) {
                var gameList = logic.state.gameTabList.value
                    .where((element) => element.gameType == gameType)
                    .first
                    .listData;
                return gameGridViewList(gameList);
              },
            ),
            // CustomScrollView(slivers: [
            //   SizedBox(height: 16).sliverToBoxAdapter,
            //   // Container(
            //   //   child: (index!=null&&index % 2==0)? gameGridViewList():gameListView(),
            //   // ),
            //    gameGridViewList(),
            // ]),
            onRefresh: () async {
      await HttpChannel.channel.userInfo().then((value) => value.finalize(
          wrapper: WrapperModel(),
          success: (data) {
            AppManager.getInstance<AppUser>().fromJson(data, false);
          }));
      return;
    }));
  }

  // ListView gameListView(gameList) {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(8),
  //       itemCount: gameList?.length ?? 0,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Container(
  //             height: 100,
  //             decoration: BoxDecoration(
  //                 color: Colors.red,
  //                 borderRadius: BorderRadius.circular(10.pt)),
  //             margin: EdgeInsets.only(top: 10),
  //             child: Center(
  //                     child: CustomText((gameList?[index].name) ?? "",
  //                         fontSize: 13, color: Colors.white))
  //                 .gestureDetector(onTap: () {}));
  //       });
  // }

  GridView gameGridViewList(gameList) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 2.0,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10, //显示区域宽高相等
      ),
      itemCount: gameList?.length ?? 0,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: Column(
              children: [
                Image.asset(AppImages.announcement).expanded(),
                CustomText((gameList?[index].name) ?? "",
                    fontSize: 13, color: Colors.white),
              ],
            ),
            onTap: () {
              logic.addTestGame(widget.gameType);
            });
      },
    );
  }
}

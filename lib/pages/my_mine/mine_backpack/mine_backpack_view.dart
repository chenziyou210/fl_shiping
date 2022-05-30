import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/pages/my_mine/mine_backpack/views/car_buy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import '../../../app_images/app_images.dart';
import '../../../common/common_widget/custom_gradientbutton/custom_gradientbutton.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_layout.dart';
import '../../../generated/car_list_entity.dart';
import 'mine_backpack_logic.dart';
import 'mine_backpack_state.dart';
import 'package:hjnzb/i18n/i18n.dart';

AppInternational get intl => AppInternational.current;

class MineBackpackPage extends StatefulWidget {
  @override
  State<MineBackpackPage> createState() => _MineBackpackPageState();
}

class _MineBackpackPageState extends State<MineBackpackPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(MineBackpackLogic());
  final state = Get.find<MineBackpackLogic>().state;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    logic.loadCarList();
    logic.loadPackageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
            title: CustomTabBar(
              tabs: (_) => state.titles
                  .map((title) => Container(
                  width: 100,
                  height: 60,
                  child: Center(
                      child: Text(title)
                  )
              )).toList(),
              controller: _tabController,
              isScrollable: true,
              labelColor: AppMainColors.whiteColor100,
              unselectedLabelColor: AppMainColors.whiteColor70,
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelStyle: TextStyle(fontSize: 16),
            )
        ),
        body: Column(
          children: [
            TabBarView(
                children: [
                  MineCarPage(state, logic),
                  MineBagPage(state),
                ],
                controller: _tabController
            ).expanded()
          ],
        )
    );
  }

}

class MineCarPage extends StatelessWidget {
  const MineCarPage(this.state, this.logic, {Key? key}) : super(key: key);

  final MineBackpackState state;
  final MineBackpackLogic logic;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned.fill(child: carBody(context)),
          Positioned(child: carDisplay(), bottom: 0, left: 0, right: 0,)
        ]
    ).sizedBox(width: double.infinity, height: double.infinity);
  }

  Widget carBody(BuildContext context) {
    return Obx(() {
      return ListView.builder(
          itemCount: state.carList.length,
          itemBuilder: (context, index) {
            final model = state.carList[index];
            return Container(
                padding: EdgeInsets.fromLTRB(pageSpace, space16, pageSpace, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ExtendedImage.network(model.carStaticUrl, height: 56.pt),
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                      color: AppMainColors.separaLineColor6,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppMainColors.separaLineColor10,
                                          width: 1
                                      )
                                  ),
                                  child: Image.asset(AppImages.previewButton).cupertinoButton(
                                      onTap: () => logic.play(index)
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 16),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText("${model.carName}", fontSize: 16.pt, color: AppMainColors.whiteColor100),
                                  SizedBox(height: 8),
                                  if (model.carBuyState == 0)
                                    CustomText("${model.monthPrice} ${intl.diamond}/${intl.month}", fontSize: 12.pt, color: AppMainColors.whiteColor40)
                                  else
                                    CustomText("${intl.validateDate} : ${model.validityPeriod}", color: AppMainColors.whiteColor40, fontSize: 12.pt)
                                ]
                            ).expanded(),
                            GradientButton(
                              child: Text(logic.getCarBuyText(index)),
                              onPressed: () {
                                if (model.carBuyState == 0)
                                  buyCar(context, model);
                                if (model.carBuyState == 1)
                                  logic.use(model.id);
                              }
                            )
                          ]
                      ),
                      SizedBox(height: 15),
                      Container(
                          padding: EdgeInsets.only(left: 60),
                          height: 1.pt,
                          color: AppMainColors.separaLineColor4
                      ),
                    ]
                )
            );
          }
      );
    });
  }

  void buyCar(BuildContext context, CarListEntity model) {
    customShowModalBottomSheet(context: context, builder: (_){
      return CarBuy(model);
    }, backgroundColor: Colors.transparent, enableDrag: false,
        fixedOffsetHeight: context.height * 0.7).then((value){
      logic.loadCarList();
    });
  }

  Widget carDisplay() {
    return Obx((){
      String url = state.gifUrl.value;
      if (url.isEmpty)
        logic.updateAnimationStatus(false);
      else
        logic.updateAnimationStatus(true);
      return Offstage(
          offstage: !state.isAnimation,
          child: !state.isAnimation ? SizedBox.shrink() :
          CustomGiftView.network(
              url,
              onFinish: () => logic.playComplete(),
              loop: false,
              progress: CircularProgressIndicator().padding(padding: EdgeInsets.only(
              bottom: 16
          )).center)
      );
    });
  }
}


class MineBagPage extends StatelessWidget {
  const MineBagPage(this.state,{Key? key}) : super(key: key);

  final MineBackpackState state;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8
          ),
          padding: EdgeInsets.only(top: 10),
          itemCount: state.bagList.length,
          itemBuilder: (context, index) {
            final model = state.bagList[index];
            return Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  ExtendedImage.network(model.giftImg ?? "",
                      enableLoadState: false,
                      width: 46, height: 46, fit: BoxFit.cover),
                  Container(
                    width: 42,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppMainColors.whiteColor100,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: AppMainColors.blackColor70
                    ),
                      child: Text("${model.remainQuantity}个", style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 8))
                  ),
                  SizedBox(height: 8),
                  Text("${model.giftName}", style: TextStyle(color: AppMainColors.whiteColor70, fontSize: 14)),
                  SizedBox(height: 8),
                  GradientButton(
                    child: Text('使用'),
                    onPressed: () {

                    },
                  )
                ],
              ),
            );
          }
      );
    });
  }

}


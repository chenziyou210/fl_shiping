import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room/view/game_view/game_item.dart';
import 'package:hjnzb/pages/live_room/view/lottery_record/lottery_record.dart';
import 'package:hjnzb/pages/withdraw_record/bet_record.dart';
import 'package:hjnzb/util_tool/util_tool.dart';
import '../game_instruction/game_instruction.dart';
// import 'game_question_alter.dart';
import 'game_image.dart';

class GameViewPage extends StatelessWidget {
  GameViewPage(this.id);
  final String id;

  @override
  Widget build(BuildContext context) {
    var game = AppManager.getInstance<Game>();
    var games = game.games;
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 23, 35),
            // color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: context.height * 0.15, crossAxisCount: 3),
            itemBuilder: (_, index) {
              var m = games[index];
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.imageBase + m.gameName + ".png",
                        width: 50, height: 50, fit: BoxFit.fill),
                    SizedBox(height: 4),
                    CustomText("${m.gameName}",
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.f14w400c255_255_255)
                  ]).inkWell(onTap: () {
                double height = context.height * 0.5;
                var model = games[index];
                if (model.type == 1) {
                  height += 120;
                }
                customShowModalBottomSheet(
                        context: context,
                        fixedOffsetHeight: height, //context.height * 0.5,
                        enableDrag: false,
                        builder: (_) {
                          if (model.type == 0)
                            return Game1View(games[index], id);
                          else if (model.type == 1)
                            return Game2View(games[index] as GameModel1, id);
                          else if (model.type == 2)
                            return Game3View(games[index] as Game2Model, id);
                          return SizedBox.shrink();
                        },
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.transparent)
                    .then((value) {
                  if (value != null && value is bool && value) {
                    Navigator.of(context).pop();
                  }
                });
              });
            },
            itemCount: games.length));
  }
}

class _GameDetailViewBaseState<T extends StatefulWidget> extends AppStateBase<T>
    with TickerProviderStateMixin, Toast {
  late GameModel _model;

  late String id;

  int get length => _model.gamePlays.length;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_model);
    _controller = TabController(length: length, vsync: this);
  }

  late final TabController _controller;
  double? _height;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: _height ?? context.height / 2,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 23, 35),
            borderRadius: BorderRadius.circular(8)),
        // color: Colors.black.withOpacity(0.4),
        child: Column(children: [
          SizedBox(height: 16),
          Row(children: [
            Image.asset(AppImages.imageBase + _model.gameName + ".png",
                width: 24, height: 24, fit: BoxFit.fill),
            SizedBox(width: 8),
            CustomText("${_model.gameName}",
                style: AppStyles.f14w400c255_255_255),
            SizedBox(width: 8), // Image.asset(AppImages.gameQuestion)
            CustomText(intl.gameInstruction,
                    style: AppStyles.f14w400c255_255_255)
                .cupertinoButton(
                    miniSize: 30,
                    onTap: () {
                      customShowModalBottomSheet(
                          context: context,
                          barrierColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          builder: (_) {
                            return GameInstruction(_model.description);
                          });
                      // alertViewController(GameQuestionAlter(_model.description, onClose: (){
                      //   popViewController();
                      // }), false);
                    }),
            Spacer(),
            // CustomText("${intl.betRecord}", style: AppStyles.f14w400c255_255_255) paddingAll(4)
            Image.asset(AppImages.gameViewBetRecord).cupertinoButton(onTap: () {
              customShowModalBottomSheet(
                  context: context,
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return BetRecordPage().sizedBox(height: this.height * 0.8);
                  },
                  fixedOffsetHeight: this.height * 0.8);
            }),
            SizedBox(width: 8),
            GestureDetector(
                onTap: lotteryRecord,

                /// .paddingAll(4)
                child: Image.asset(AppImages.lotteryRecord))

            /// CustomText("${intl.record}",style: AppStyles.f14w400c255_255_255)
          ]).paddingSymmetric(horizontal: 12),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 16),
              CustomText("${intl.lotteryCountDown}:",
                  style: AppStyles.f14w400c255_255_255),
              SizedBox(width: 8),
              Obx(() {
                int m = _model.count1.value ~/ 60;
                int s = _model.count1.value % 60;
                return CustomText(
                    "${m.toStringAsFixed1(2)}:${s.toStringAsFixed1(2)}",
                    style: AppStyles.f14w400c255_255_255
                        .copyWith(color: AppColors.c255_225_0));
              }),
              Spacer(),
              Obx(() {
                if (_model.lotteryPeriodTime.value.isEmpty) return SizedBox();
                return CustomText(
                    "${intl.dn}: ${_model.lotteryPeriodTime.value}",
                    style: AppStyles.f14w400c255_255_255);
              }),
              SizedBox(width: 12)
            ],
          ),
          SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Spacer(),
            Obx(() {
              if (_model.lastGameResult.isEmpty ||
                  _model.lastGameResult.value.split(",").length == 0) {
                return SizedBox();
              } else {
                return lotteryResult;
              }
            })
            // CustomText("last lottery", style: AppStyles.f14w400c255_255_255)
          ]).paddingSymmetric(horizontal: 12),
          SizedBox(height: 8),
          optionView,
          SizedBox(height: 8),
          Expanded(
              child: TabBarView(
                  children: betViewList,
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics())),
          Row(children: [
            Image.asset(AppImages.coin),
            SizedBox(width: 4),
            SelectorCustom<AppUser, double?>(
                builder: (value) {
                  return CustomText("$value",
                      fontWeight: w_500, color: AppColors.c255_255_255);
                },
                selector: (u) => u.lockMoney),
            SizedBox(width: 8),
            SelectorCustom<SettingViewModel, bool>(
                builder: (value) {
                  if (value) return SizedBox();
                  return Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.c255_225_0)),
                    child: CustomText(
                        "${AppInternational.of(context).recharge} >",
                        style: AppStyles.f14w400c255_255_255),
                  ).cupertinoButton(onTap: () {
                    pushViewControllerWithName(AppRoutes.chargePage);
                  });
                },
                selector: (s) => s.isSameVersion),
            Spacer(),
            Container(
              constraints: BoxConstraints(minWidth: 30, minHeight: 30),
              alignment: Alignment.center,
              child: Obx(() => _model.isCustom
                  ? CustomText("${_model.betNum.value}",
                      fontSize: 14, fontWeight: w_400, color: Colors.white)
                  : Image.asset(
                      AppImages.imageBase + "mul_${_model.betNum.value}.png",
                      width: 30,
                      height: 30)),
            ).clipRRect(radius: BorderRadius.circular(15)).gestureDetector(
                onTap: () {
              // showModalBottomSheet(context: context, builder: builder)
              customShowModalBottomSheet(
                      context: context,
                      fixedOffsetHeight: context.height * 0.5,
                      enableDrag: false,
                      builder: (_) {
                        return _BetView();
                        // print("the viewInsets is ${MediaQuery.of(context).viewInsets}");
                        // return AnimatedPadding(padding: MediaQuery.of(context).viewInsets,
                        //   duration: Duration(milliseconds: 100),
                        //   child: _BetView()
                        // );
                      },
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.transparent)
                  .then((value) {
                if (value != null && value is bool && value) {
                  Navigator.of(context).pop();
                }
              });
            }),
            SizedBox(width: 12),
            Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        // color: Colors.deepOrange.withOpacity(0.8),
                        gradient: LinearGradient(
                            colors: AppColors.buttonGradientColors),
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: CustomText("${intl.wager}",
                        style: AppStyles.f14w400c255_255_255))
                .gestureDetector(onTap: () async {
              var result = this._model.submit(id);
              if (result == null) return;
              show();
              HttpChannel.channel.bet(result).then((value) => value.finalize(
                  wrapper: WrapperModel(),
                  failure: (e) => showToast(e),
                  success: (_) {
                    showToast("${intl.betSuccess}");
                    this._model.clear();
                    // popViewController(true);
                  }));
            })
          ]).paddingSymmetric(horizontal: 12),
          SizedBox(height: 16)
        ]));
  }

  /// 每一个游戏页面
  List<Widget> get betViewList =>
      List.generate(_model.gamePlays.length, (index) => SizedBox());

  Widget get lotteryResult => Row(
      children: _model.lastGameResult.value
          .split(",")
          .map((e) => [
                getItem(_model.gameName, e, size: Size(20, 20)),
                SizedBox(width: 4)
              ])
          .toList()
          .reduce((value, element) => value + element)
        ..removeLast());

  /// 类似tabBar
  Widget get optionView => CustomTabBar(
        tabs: (_) => _model.gamePlays.map((e) {
          return Container(
              alignment: Alignment.bottomCenter,
              // width: 60.pt,
              height: 80.pt,
              color: Colors.transparent,
              child: CustomText("${e.playName}"));
        }).toList(),
        labelStyle: TextStyle(
          fontSize: 14.pt,
          fontWeight: w_400,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.pt,
          fontWeight: w_400,
        ),
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        controller: _controller,
        onTap: (index) {
          _model.tapOption(index);
        },
        decoration: UnderlineTabLinearGradientIndicatorCustom(
            width: 25.pt,
            isCircle: true,
            gradient: LinearGradient(colors: AppColors.buttonGradientColors)),
        // isScrollable: true,
        labelPadding: EdgeInsets.zero,
      ).sizedBox(height: 40);
  // return Row(// D:\软件\Nox\bin\Nox.exe connect 127.0.0.1:62001
  //   children: _model.gamePlays.map((e) => [
  //     CustomText("${e.playName}", style: AppStyles.f14w400c255_255_255)
  //       .center
  //       .container(
  //       constraints: BoxConstraints.expand(),
  //       color: _model.index.value == _model.gamePlays.indexOf(e) ? Colors.deepPurpleAccent : null
  //     ).inkWell(
  //         onTap: (){
  //           int index = _model.gamePlays.indexOf(e);
  //           _model.tapOption(index);
  //           _controller.animateTo(index);
  //         }).expanded(),
  //     Container(
  //       width: 1,
  //       height: 30,
  //       color: Colors.white
  //     )]).toList().reduce((value, element) => value + element)..removeLast()
  // );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<GameModel>();
    _controller.dispose();
  }

  void lotteryRecord() {
    double? height;
    if (_model.type == 1) {
      height = context.height * 0.5 + 120;
    }
    customShowModalBottomSheet(
        context: context,
        fixedOffsetHeight: height ?? context.height * 0.5,
        enableDrag: false,
        builder: (_) {
          return LotteryRecord(_model.gameName, height: height);
        },
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent);
  }
}

class Game1View extends StatefulWidget {
  Game1View(this.game, this.id);
  final GameModel game;
  final String id;
  @override
  createState() => _Game1View();
}

class _Game1View extends _GameDetailViewBaseState<Game1View> {
  @override
  // TODO: implement _model
  GameModel get _model => widget.game;

  @override
  // TODO: implement id
  String get id => widget.id;

  @override
  // TODO: implement betViewList
  List<Widget> get betViewList => _model.gamePlays.map((e) {
        int index = _model.gamePlays.indexOf(e);
        return BetViewWidget(index, e);
      }).toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class BetViewWidget extends GetView<GameModel> {
  BetViewWidget(this.row, this._options);
  final PlayOption _options;
  final int row;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool isMulOf3 = _options.options.length % 3 == 0;
    bool isGreaterThan6 = _options.options.length > 6;
    // return Obx((){
    if (isGreaterThan6) {
      return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 80.pt),
              itemBuilder: (_, index) {
                var e = _options.options[index];
                return Obx(() {
                  return _ItemWidget(
                      image: _getImage(controller.gameName, e.betPic),
                      title: e.lossRate,
                      isSelected: _options.selectIndexes.contains(index));
                }).gestureDetector(onTap: () => _tapIndex(index));
              },
              itemCount: _options.options.length)
          .paddingSymmetric(vertical: 8);
    } else if (isMulOf3) {
      int mul = _options.options.length ~/ 3;
      return Column(
              children: List.generate(
                  mul,
                  (index) => [
                        Row(
                            children: [index * 3, index * 3 + 1, index * 3 + 2]
                                .map((e) => Obx(() {
                                      return _ItemWidget(
                                          image: _getImage(controller.gameName,
                                              _options.options[e].betPic),
                                          title: _options.options[e].lossRate,
                                          isSelected: _options.selectIndexes
                                              .contains(e));
                                    })
                                        .gestureDetector(
                                            onTap: () => _tapIndex(e))
                                        .expanded())
                                .toList()),
                        SizedBox(height: 16)
                      ]).toList().reduce((value, element) => value + element)
                ..removeLast())
          .paddingSymmetric(vertical: 8)
          .singleScrollView();
    }
    return [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _options.options
              .map((e) {
                int index = _options.options.indexOf(e);
                return [
                  Obx(() {
                    return _ItemWidget(
                        image: _getImage(controller.gameName, e.betPic),
                        title: e.lossRate,
                        isSelected: _options.selectIndexes.contains(index));
                  }).gestureDetector(onTap: () => _tapIndex(index)),
                  SizedBox(width: 16)
                ];
              })
              .toList()
              .reduce((value, element) => value + element)
            ..removeLast())
    ]
        .column(mainAxisAlignment: MainAxisAlignment.center)
        .paddingSymmetric(vertical: 8);
    // });
  }

  /// 选中
  void _tapIndex(int index) {
    controller.tapIndex(index);
  }
  //
  // String _getImage(String gameName, String value){
  //   return AppImages.imageBase + gameName
  //       + "_" + value + ".png";
  // }

  String _getImage(String gameName, String value) {
    var intl = AppInternational.current;
    var key = gameName + "_" + value;
    var r = commonImage[key];
    if (r != null) return r;
    if (intl is $zh_CN) {
      return image$zh[key]!;
    }
    return image$us[key]!;
  }
}

class _ItemWidget extends StatelessWidget {
  _ItemWidget(
      {required this.image, required this.title, required this.isSelected});
  final String image;
  final String title;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      _ImageItem(image, isSelected),
      SizedBox(height: 8),
      CustomText(title, fontSize: 14, fontWeight: w_400, color: Colors.white)
    ]);
  }
}

class _ImageItem extends StatelessWidget {
  _ImageItem(this.image, this.isSelected);
  final String image;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget widget;
    if (!isSelected)
      widget = Image.asset(image).marginAll(4);
    else
      widget = CustomGradientBorderContainer(
          strokeWidth: 4,
          radius: 10,
          gradient: LinearGradient(
              transform: GradientRotation(pi / 4),
              colors: AppColors.buttonGradientColors),
          child: Image.asset(image).marginAll(4));
    return widget;
  }
}

class _BetView extends StatefulWidget {
  @override
  createState() => _BetViewState();
}

class _BetViewState extends AppStateBase<_BetView> with Toast {
  GameModel get controller => Get.find<GameModel>();

  final TextEditingController _textController = TextEditingController();

  final List<String> _mul = [
    AppImages.mul5,
    AppImages.mul10,
    AppImages.mul20,
    AppImages.mul100,
    AppImages.mul200,
    AppImages.mul500,
    AppImages.mul1000,
    AppImages.mul2000,
    AppImages.mul4000,
    AppImages.mul6000,
    AppImages.mul8000,
    AppImages.mul10000
  ];

  final List<int> _m = [
    5,
    10,
    20,
    100,
    200,
    500,
    1000,
    2000,
    4000,
    6000,
    8000,
    10000
  ];

  final int _n = 4;

  late int _bet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bet = controller.betNum.value;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 21, 23, 35),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        width: context.width,
        height: context.height / 2,
        child: Column(children: [
          SizedBox(height: 16),
          CustomText("${intl.selectMagnification}",
              fontSize: 16, fontWeight: w_500, color: Colors.white),
          SizedBox(height: 46),
          GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 62,
                      mainAxisSpacing: 16,
                      crossAxisCount: _n),
                  itemBuilder: (_, index) {
                    return _ImageItem(_mul[index], _bet == _m[index])
                        .container(alignment: Alignment.center)
                        .gestureDetector(onTap: () {
                      _bet = _m[index];
                      _textController.clear();
                      unFocus();
                      setState(() {});
                    });
                  },
                  itemCount: _m.length)
              .expanded(),
          SizedBox(height: 8),
          Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 16),
                Container(
                  width: 133.pt,
                  height: 40.pt,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 44, 44, 56),
                      border:
                          Border.all(color: Color.fromARGB(255, 74, 74, 86)),
                      borderRadius: BorderRadius.circular(6.pt)),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: CustomTextField(
                    controller: _textController,
                    hintText: "${intl.customMul}",
                    textInputAction: TextInputAction.done,
                    inputFormatter: [OnlyInputInt()],
                    onChange: (text) {
                      try {
                        _bet = int.parse(text);
                      } catch (e) {
                        _textController.clear();
                      }
                    },
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                        fontSize: 16.pt,
                        fontWeight: w_400,
                        color: Colors.white),
                    hintTextStyle: TextStyle(
                        fontSize: 16.pt,
                        fontWeight: w_400,
                        color: Color.fromARGB(255, 110, 110, 124)),
                  ),
                ),
                Spacer(),
                Container(
                        height: 34,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            gradient: LinearGradient(
                                transform: GradientRotation(pi / 4),
                                colors: AppColors.buttonGradientColors)),
                        child: CustomText(intl.confirm,
                            fontSize: 16,
                            fontWeight: w_400,
                            color: Colors.white))
                    .gestureDetector(onTap: () {
                  // if (_bet < 200) {
                  //   _textController.clear();
                  //   showToast("${intl.betMustBigger200}");
                  //   return;
                  // }
                  controller.changeMultiple(_bet, _m.contains(_bet));
                  popViewController();
                }),
                SizedBox(width: 16)
              ]),
          SizedBox(height: 16)
        ]));
  }
}

class Game2View extends StatefulWidget {
  Game2View(this.game, this.id);
  final GameModel1 game;
  final String id;
  @override
  createState() => _Game2View();
}

class _Game2View extends _GameDetailViewBaseState<Game2View> {
  @override
  // TODO: implement _model
  GameModel1 get _model => widget.game;

  @override
  // TODO: implement id
  String get id => widget.id;

  int get length => _model.plays.length;

  @override
  // TODO: implement _height
  double? get _height => context.height * 0.5 + 120;

  @override
  // TODO: implement betViewList
  List<Widget> get betViewList => _model.plays.map((e) {
        int index = _model.plays.indexOf(e);
        return _GameView2OptionView(e, index);
        // return BetViewWidget(index, e);
      }).toList();

  @override
  // TODO: implement lotteryResult
  Widget get lotteryResult =>
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Obx(() {
          var result = widget.game.racingGameResult.value;
          List<String> value = result.split(",");
          return Row(
              children: value
                  .map((e) => [
                        getItem(widget.game.gameName, e, size: Size(15, 15)),
                        SizedBox(width: 4)
                      ])
                  .toList()
                  .reduce((value, element) => value + element));
        }),
        SizedBox(height: 4),
        Obx(() {
          var result = widget.game.racingGameResult1.value;
          if (result.length == 0) return SizedBox(height: 15);
          List<String> value = result.split(",");
          return Row(
              children: value
                  .map((e) => [
                        getItem(widget.game.gameName, e, size: Size(15, 15)),
                        SizedBox(width: 4)
                      ])
                  .toList()
                  .reduce((value, element) => value + element));
        })
      ]);

  @override
  // TODO: implement optionView
  Widget get optionView => BackgroundTabBar(
        tabs: (_) => _model.plays.map((e) {
          return Container(
              alignment: Alignment.center,
              // width: 60.pt,
              height: 80.pt,
              color: Colors.transparent,
              child: CustomText("${e.tabName}", textAlign: TextAlign.center));
        }).toList(),
        labelStyle: TextStyle(
          fontSize: 14.pt,
          fontWeight: w_400,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.pt,
          fontWeight: w_400,
        ),
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        controller: this._controller,
        onTap: (index) {
          _model.tapOption(index);
        },
        height: 40,
        child: Container(
            width: this.width / widget.game.plays.length,
            height: 40,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: AppColors.buttonGradientColors))),
        // isScrollable: true,
        labelPadding: EdgeInsets.zero,
      ).sizedBox(height: 40);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class _GameView2OptionView extends StatefulWidget {
  _GameView2OptionView(this.plays, this.index);
  final Game1Plays plays;
  final int index;
  @override
  createState() => _GameView2OptionViewState();
}

class _GameView2OptionViewState extends State<_GameView2OptionView>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.plays.isTab) {
      _controller =
          TabController(length: widget.plays.options.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var l =
        widget.plays.options.where((element) => element.showOption).toList();
    bool hasTab = l.isNotEmpty;
    if (widget.plays.isTab) {
      if (hasTab)
        return Column(children: [
          CustomTabBar(
                  tabs: (_) => widget.plays.options.map((e) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            // width: 60.pt,
                            height: 80.pt,
                            constraints: BoxConstraints(minWidth: 80),
                            color: Colors.transparent,
                            child: CustomText("${e.playName}"));
                      }).toList(),
                  controller: _controller!,
                  labelStyle: TextStyle(
                    fontSize: 14.pt,
                    fontWeight: w_500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.pt,
                    fontWeight: w_500,
                  ),
                  unselectedLabelColor: Colors.white,
                  labelColor: Color.fromARGB(255, 237, 129, 224),
                  onTap: (index) {
                    widget.plays.onTap(index);
                  },
                  decoration: UnderlineTabLinearGradientIndicatorCustom(
                      // width: 25.pt,
                      isCircle: true,
                      gradient: LinearGradient(
                          colors: AppColors.buttonGradientColors)),
                  // isScrollable: true,
                  labelPadding: EdgeInsets.zero,
                  isScrollable: true)
              .sizedBox(height: 30, width: double.infinity),
          SizedBox(height: 8),
          TabBarView(children: [
            for (int i = 0; i < l.length; i++) BetViewWidget(i, l[i])
          ], controller: _controller)
              .expanded()
        ]);
      return BetViewWidget(0, widget.plays.options[0]);
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          for (int i = 0; i < l.length; i++)
            Obx(() {
              bool isSelect = widget.plays.selectIndexes.contains(i);
              TextPainter p = TextPainter(
                  textDirection: TextDirection.ltr,
                  text: TextSpan(
                      text: l[i].playName,
                      style: TextStyle(fontSize: 14, fontWeight: w_500)));
              p.layout();
              return Column(children: [
                CustomText(
                  l[i].playName,
                  fontSize: 14,
                  fontWeight: w_500,
                  color: isSelect
                      ? Color.fromARGB(255, 237, 129, 224)
                      : Colors.white, // rgba(237, 129, 224, 1)
                )
                    .padding(padding: EdgeInsets.symmetric(horizontal: 8))
                    .center
                    .expanded(),
                if (isSelect)
                  Container(
                      height: 2,
                      width: p.width + 8 + 8,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: AppColors.buttonGradientColors),
                          borderRadius: BorderRadius.circular(1)))
                else
                  SizedBox(height: 2)
              ]);
            }).inkWell(onTap: () {
              widget.plays.onTap(i);
            })
        ])
            .sizedBox(height: 30)
            .singleScrollView(scrollDirection: Axis.horizontal),
        SizedBox(height: 8),
        BetViewWidget(0, widget.plays.options[0]).expanded()
      ]);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }
}

class Game3View extends StatefulWidget {
  Game3View(this.game, this.id);
  final Game2Model game;
  final String id;
  @override
  createState() => _Game3ViewState();
}

class _Game3ViewState extends _GameDetailViewBaseState<Game3View> {
  @override
  // TODO: implement _model
  GameModel get _model => widget.game;

  @override
  // TODO: implement id
  String get id => widget.id;

  @override
  // TODO: implement length
  int get length => 1;

  @override
  // TODO: implement betViewList
  List<Widget> get betViewList => <Widget>[_GameView3OptionView(widget.game)];

  @override
  // TODO: implement optionView
  Widget get optionView => SizedBox.shrink();

  @override
  // TODO: implement lotteryResult
  Widget get lotteryResult =>
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        [
          Obx(() {
            return getItem(widget.game.gameName, widget.game.leftValue.value);
          }),
          SizedBox(width: 4),
          Obx(() {
            List<String> values = widget.game.midValue.value.split(",");
            List<String> values1 = widget.game.mid1Value.value.split(",");
            return Row(
                children: values
                        .map((e) => [
                              getItem(widget.game.gameName, e,
                                  size: Size(25, 35), fit: BoxFit.fill)
                            ])
                        .reduce((value, element) => value + element) +
                    [SizedBox(width: 6)] +
                    values1
                        .map((e) => [
                              getItem(widget.game.gameName, e,
                                  size: Size(25, 35), fit: BoxFit.fill)
                            ])
                        .reduce((value, element) => value + element));
          }),
          SizedBox(width: 4),
          Obx(() {
            return getItem(widget.game.gameName, widget.game.rightValue.value);
          })
        ].row(),
        SizedBox(height: 8),
        Row(
          children: [
            CustomText("${intl.betLimit}: 2-10000000",
                fontSize: 12, fontWeight: w_400, color: Colors.white)
          ],
        )
      ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class _GameView3OptionView extends StatefulWidget {
  _GameView3OptionView(this.game);
  final Game2Model game;
  @override
  createState() => _GameView3OptionViewState();
}

class _GameView3OptionViewState extends AppStateBase<_GameView3OptionView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return body;
  }

  @override
  // TODO: implement body
  Widget get body => GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          mainAxisExtent: 80.pt),
      itemBuilder: (_, int index) {
        var model = widget.game.optionDetails[index];
        return Stack(children: [
          _ItemWidget(
                  image: _getImage(widget.game.gameName, model.betPic),
                  title: model.lossRate,
                  isSelected: false)
              .gestureDetector(onTap: () {
            widget.game.tapIndex(index);
          }).padding(padding: EdgeInsets.only(left: 16, right: 10)),
          Obx(() {
            var v = model.bet.value;
            bool bet = v > 0;
            if (!bet) {
              return SizedBox.shrink();
            }
            String value = "";
            if (v > 1000) {
              int i = 0;
              if (v % 1000 != 0) {
                i = 1;
              }
              value = (v / 1000).toStringAsFixed(i) + "k";
            } else {
              value = "$v";
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: ShapeDecoration(
                          shape: BottomLeftTriangleBorder(
                              borderRadius: BorderRadius.circular(3),
                              triangleHeight: 4,
                              triangleWidth: 8,
                              borderWidth: 2,
                              offsetX: 2,
                              fillColor: Colors.white)),
                      child: CustomText("$value", color: Colors.black)
                          .marginSymmetric(horizontal: 4)),
                  SizedBox(height: 2),
                  Image.asset(AppImages.coin),
                  SizedBox(height: 4),
                  Container(
                    child: Image.asset(AppImages.livingClose, width: 15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                  ).cupertinoButton(
                      onTap: () {
                        model.clean();
                      },
                      padding: EdgeInsets.symmetric(vertical: 4) +
                          EdgeInsets.only(right: 4))
                ]);
          }).position(left: 0, top: 0)
        ]).center;
      },
      itemCount: widget.game.optionDetails.length);

  String _getImage(String gameName, String value) {
    var intl = AppInternational.current;
    var key = gameName + "_" + value;
    var r = commonImage[key];
    if (r != null) return r;
    if (intl is $zh_CN) {
      return image$zh[key]!;
    }
    return image$us[key]!;
  }
}

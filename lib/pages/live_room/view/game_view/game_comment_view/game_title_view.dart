import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/state_manager.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';
import '../game_table/game_table_view.dart';
import 'game_base.dart';

class GameTitleView extends StatefulWidget {
  final RxMap webResult;
  final RxList dataResult;
  final String rule;
  final GameInit init;
  final GameOpen gameOpen;
  final GameRecord gameRecord;
  final RxDouble haderHight;
  GameTitleView(this.webResult, this.rule, this.dataResult, this.haderHight,
      {required this.init, required this.gameOpen, required this.gameRecord});
  @override
  _GameTitleViewState createState() => _GameTitleViewState();
}

class _GameTitleViewState extends State<GameTitleView> with Toast {
  var myData = "";
  var showBetRecord = false;
  var showprizeRecord = false;
  var showprizeRecordPage = 1;
  var showBetPage = 1;

  @override
  Widget build(BuildContext context) {
    // return Text("");
    return _titleContent(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.haderHight.value == 0) {
        showBetRecord = false;
        showprizeRecord = true;
      } else {
        showBetRecord = false;
        showprizeRecord = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _titleContent(BuildContext context) {
    Map data = widget.webResult;
    String results = data["result"] ?? "";

    if (myData.isEmpty && widget.dataResult.isNotEmpty) {
      setState(() {
        myData = widget.dataResult[0]['result'];
      });
    }

    List list = getImage(myData);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                // 开奖记录和更换游戏
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (showprizeRecord) {
                                showprizeRecord = false;
                              }
                              showBetRecord = !showBetRecord;
                            });
                            widget.gameOpen.call(showBetRecord, showBetPage);
                          },
                          child: titleBut("投注记录", showBetRecord),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (showBetRecord) {
                                showBetRecord = false;
                              }
                              showprizeRecord = !showprizeRecord;
                            });
                            widget.gameRecord
                                .call(showprizeRecord, showprizeRecordPage);
                          },
                          child: titleBut("开奖记录", showprizeRecord),
                        ),
                        InkWell(
                            onTap: () {
                              showGameRule();
                            },
                            child: titleBut("玩法", false)),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showGameTable(context);
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.ic_little_game,
                                  width: 18.pt,
                                  height: 18.pt,
                                ),
                                SizedBox(
                                  width: 4.pt,
                                ),
                                Text(
                                  '切换',
                                  style: TextStyle(
                                      color: AppMainColors.whiteColor70,
                                      fontSize: 10.pt),
                                ),
                                SizedBox(
                                  width: 20.pt,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showGameTable(BuildContext context) {
    Navigator.of(context).pop();
    customShowModalBottomSheet(
        context: context,
        builder: (_) {
          // return GameViewPage(_anchorId!);
          return GameTablePage();
        },
        fixedOffsetHeight: 380.pt,
        isScrollControlled: false,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent);
  }

  // 玩法说明
  showGameRule() {
    customShowModalBottomSheet(
        context: context,
        builder: (_) {
          return dialogRuleView();
        },
        fixedOffsetHeight: 420.pt,
        isScrollControlled: false,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white);
  }

  // 开奖记录
  showGamePrizeRecord() {
    customShowModalBottomSheet(
        context: context,
        builder: (_) {
          return dialogPrizeRecordView();
        },
        fixedOffsetHeight: 420.pt,
        isScrollControlled: false,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.white);
  }

  List<String> getImage(String data) {
    if (data.isEmpty) {
      return [];
    }
    List<String> list = data.split(",");
    for (var i = 0; i < list.length; i++) {
      switch (list[i]) {
        case "1":
          list[i] = AppImages.dice1;
          break;
        case "2":
          list[i] = AppImages.dice2;
          break;
        case "3":
          list[i] = AppImages.dice3;
          break;
        case "4":
          list[i] = AppImages.dice4;
          break;
        case "5":
          list[i] = AppImages.dice5;
          break;
        case "6":
          list[i] = AppImages.dice6;
          break;
        default:
      }
    }
    return list;
  }

  Widget titleBut(String value, bool show) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.pt, vertical: 2.pt),
      margin: EdgeInsets.symmetric(horizontal: 4.pt, vertical: 8.pt),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      //   borderRadius: BorderRadius.all(Radius.circular(12.pt)),
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style:
                TextStyle(color: AppMainColors.whiteColor70, fontSize: 10.pt),
          ),
          value != "玩法"
              ? SizedBox(
                  width: 12.pt,
                  height: 12.pt,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppMainColors.whiteColor70,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget shaizi(String value) {
    return value.isEmpty
        ? Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              width: 42,
              height: 42,
            ),
          )
        : Padding(
            padding: EdgeInsets.all(2),
            child: Image.asset(
              value,
              width: 42,
              height: 42,
              fit: BoxFit.fill,
            ),
          );
  }

  Widget dialogRuleView() {
    return Container(
      height: 420.pt,
      child: SingleChildScrollView(
        child: Html(
          data: widget.rule,
        ),
      ),
    );
  }

  Widget dialogPrizeRecordView() {
    return Container(
      height: 420.pt,
      child: Column(
        children: [
          ListView.builder(
              itemCount: widget.dataResult.value.length,
              itemBuilder: (c, i) {
                List list = getImage(widget.dataResult[i]['result']);
                return Row(
                  children: [
                    Row(
                      children: [
                        shaizi(list.isEmpty ? "" : list[0]),
                        shaizi(list.isEmpty ? "" : list[1]),
                        shaizi(list.isEmpty ? "" : list[2]),
                      ],
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}

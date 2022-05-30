import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';

/**
 * 倒计时
 */
class GameLastTimeView extends StatefulWidget {
  final Map result;
  final RxList dataResult;
  final RxDouble showTime;
  GameLastTimeView(this.result, this.dataResult, this.showTime);
  @override
  _GameLastTimeViewState createState() => _GameLastTimeViewState();
}

class _GameLastTimeViewState extends State<GameLastTimeView> with Toast {
  var _myResutl = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.showTime.value == 0
            ? Container(
                width: double.infinity,
                height: 0.2.pt,
                color: Colors.white70,
              )
            : Container(),
        widget.showTime.value == 0 ? listResoult() : Container(),
        lastTime(),
      ],
    );
  }

  Widget lastTime() {
    if (!widget.result.containsKey("state")) {
      return Container();
    }
    var state = widget.result['state'];
    var time = widget.result['time'];
    var result = widget.result['result'] ?? '';
    if (result != '') {
      _myResutl = result;
    }
    if (_myResutl.isEmpty && widget.dataResult.isNotEmpty) {
      _myResutl = widget.dataResult[0]['result'];
    }
    var data = widget.result;
    if (state == 2) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          int values1 = Random().nextInt(5) + 1;
          int values2 = Random().nextInt(5) + 1;
          int values3 = Random().nextInt(5) + 1;
          _myResutl = "$values1,$values2,$values3";
        });
      });
    } else if (state == 3) {
      if (result.isNotEmpty) {
        setState(() {
          _myResutl = result;
        });
      }
    }

    List<String> list = getImage(_myResutl);
    var arrData = _myResutl.split(",");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.pt),
              child: Image.asset(AppImages.baccaratGame_x),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "data",
                  style: TextStyle(color: AppMainColors.whiteColor100),
                ),
                Row(
                  children: [
                    Text(
                      state == 1 ? "本期:" : "封盘:",
                      style: TextStyle(
                          color: AppMainColors.whiteColor100, fontSize: 10.pt),
                    ),
                    Text(
                      "00:${time < 10 ? '0$time' : time}",
                      style: TextStyle(
                          color: state == 1 ? Colors.green : Colors.red,
                          fontSize: 12.pt),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 15.pt),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  shaizi(list[0], true),
                  shaizi(list[1], true),
                  shaizi(list[2], true),
                ],
              ),
            ),
            Row(
              children: gameResoult(_myResutl),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> gameResoult(String myResutl) {
    List<Widget> list = [];
    if (myResutl.isEmpty) {
      myResutl = '1,1,1';
    }
    var arrData = myResutl.split(",");
    int dd = 0;
    arrData.forEach((element) {
      dd += int.parse(element);
    });
    for (var i = 0; i < 3; i++) {
      String datas = "";
      switch (i) {
        case 0:
          datas = dd.toString();
          break;
        case 1:
          datas = dd > 9 ? "大" : "小";
          break;
        case 2:
          var b = dd % 2;
          datas = b == 0 ? "双" : "单";
          break;
        default:
      }
      list.add(
        Container(
          margin: EdgeInsets.only(left: 2.pt, right: 2.pt),
          alignment: Alignment.center,
          width: 20.pt,
          height: 20.pt,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            datas,
            style: TextStyle(fontSize: 10.pt),
          ),
        ),
      );
    }
    return list;
  }

  Widget listResoult() {
    return Container(
      width: double.infinity,
      height: 110.pt,
      child: ListView.builder(
          itemCount: widget.dataResult.length,
          itemBuilder: ((context, index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.pt),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4.pt),
                          child: Text(
                            "${widget.dataResult[index]['issue_id']}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            shaizi(
                                getImage(widget.dataResult[index]['result'])[0],
                                false),
                            shaizi(
                                getImage(widget.dataResult[index]['result'])[1],
                                false),
                            shaizi(
                                getImage(widget.dataResult[index]['result'])[2],
                                false),
                          ],
                        ),
                      ),
                      Row(
                        children:
                            gameResoult(widget.dataResult[index]['result']),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 0.2.pt,
                  color: Colors.white70,
                )
              ],
            );
          })),
    );
  }

  Widget shaizi(String value, bool bigs) {
    return value.isEmpty
        ? Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              width: bigs ? 30.pt : 20.pt,
              height: bigs ? 30.pt : 20.pt,
            ),
          )
        : Padding(
            padding: EdgeInsets.all(2),
            child: Image.asset(
              value,
              width: bigs ? 30.pt : 20.pt,
              height: bigs ? 30.pt : 20.pt,
              fit: BoxFit.fill,
            ),
          );
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
}

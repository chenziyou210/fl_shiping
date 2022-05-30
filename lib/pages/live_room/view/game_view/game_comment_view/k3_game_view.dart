import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';

/**
 * 款三游戏
 */
class K3GameView extends StatefulWidget {
  RxList data;
  K3GameView(this.data);
  @override
  _K3GameViewState createState() => _K3GameViewState();
}

class _K3GameViewState extends State<K3GameView> with Toast {
  int talbesIndex = 0;
  var selection1 = [];
  var selection2 = [];
  var selection3 = [];
  var selection4 = [];
  var selection5 = [];

  @override
  void initState() {
    super.initState();
    _requestGame();
  }

  @override
  Widget build(BuildContext context) {
    return contentView();
  }

  Widget contentView() {
    if (selection1.isEmpty) {
      _requestGame();
      return Container(
        child: Text(
          "数据加载中...",
          style: TextStyle(color: Colors.white, fontSize: 18.pt),
        ),
      );
    }
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 8.pt,
          ),
          _gameTables(),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: _gamesView(talbesIndex),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _gameTables() {
    return Stack(
      children: [
        Opacity(
          opacity: 0.8,
          child: Container(
            height: 30.pt,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: AppMainColors.string2Color("33323E"),
            ),
            width: double.infinity,
          ),
        ),
        Row(
          children: _gameTableItem(),
        ),
      ],
    );
  }

  List<Widget> _gameTableItem() {
    List<Widget> list = [];
    for (var i = 0; i < widget.data.length; i++) {
      list.add(
        Expanded(
          child: GestureDetector(
            child: Container(
              height: 30.pt,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24)),
                color: i == talbesIndex ? Colors.white : Colors.transparent,
              ),
              child: Text(
                widget.data[i]['name'],
                style: TextStyle(
                    fontSize: 12,
                    color: i == talbesIndex
                        ? AppMainColors.string2Color("101010")
                        : AppMainColors.whiteColor70),
              ),
            ),
            onTap: () {
              _changeTabIndex(i);
            },
          ),
        ),
      );
    }
    return list;
  }

  _requestGame() {
    widget.data.forEach((data) {
      List odds = data['odds'];
      switch (data['name']) {
        case "大小":
          odds.forEach((element) {
            selection1.add(false);
          });
          break;
        case "总和":
          odds.forEach((element) {
            selection2.add(false);
          });
          break;
        case "单骰":
          odds.forEach((element) {
            selection3.add(false);
          });
          break;
        case "对子":
          odds.forEach((element) {
            selection4.add(false);
          });
          break;
        case "豹子":
          odds.forEach((element) {
            selection5.add(false);
          });
          break;
        default:
      }
    });
    setState(() {});
  }

  Widget _gamesView(int talbesIndex) {
    Widget view = Container();
    if (widget.data.isEmpty) {
      return view;
    }
    var firstList = widget.data.value;
    List data = firstList[talbesIndex]['odds'];
    int crossAxisCount = 0;
    var childAspectRatio = 0.6;
    switch (talbesIndex) {
      case 0:
        crossAxisCount = 4;
        childAspectRatio = 0.6;
        break;
      case 1:
        crossAxisCount = 7;
        childAspectRatio = 0.6;
        break;
      case 2:
        crossAxisCount = 3;
        childAspectRatio = 1.4;
        break;
      case 3:
        crossAxisCount = 3;
        childAspectRatio = 1.4;
        break;
      case 4:
        crossAxisCount = 4;
        childAspectRatio = 1;
        break;
      default:
    }
    view = GridView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 5,
        crossAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return _tableItem(context, talbesIndex, index, data[index]);
      },
    );
    return view;
  }

  Widget _tableItem(
      BuildContext context, int talbesIndex, int index, dynamic data) {
    var siede = 48.pt;
    var fontsized = 16.pt;
    if (talbesIndex == 0) {
      fontsized = 16.pt;
    } else {
      fontsized = 14.pt;
    }
    switch (talbesIndex) {
      case 0:
        siede = 62.pt;
        break;
      case 1:
        siede = 42.pt;
        break;
      default:
    }
    return GestureDetector(
      onTap: () {
        _changeSelectItem(index);
      },
      child: Column(
        children: [
          Container(
            width: siede,
            height: siede,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getSelectItem()[index]
                  ? AppMainColors.pink20
                  : AppMainColors.string2Color("33323E"),
              border: Border.all(
                color: _getSelectItem()[index]
                    ? AppMainColors.string2Color("FF1EAF")
                    : AppMainColors.string2Color("33323E"),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: fontsized),
                ),
                Padding(
                  padding: EdgeInsets.all(2.pt),
                  child: Text(
                    "${data['odds']}",
                    style: TextStyle(
                        color: AppMainColors.string2Color("32C5FF"),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.pt),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _changeTabIndex(int index) {
    setState(() {
      talbesIndex = index;
    });
  }

  _changeSelectItem(int index) {
    switch (talbesIndex) {
      case 0:
        selection1[index] = !selection1[index];
        break;
      case 1:
        selection2[index] = !selection2[index];
        break;
      case 2:
        selection3[index] = !selection3[index];
        break;
      case 3:
        selection4[index] = !selection4[index];
        break;
      case 4:
        selection5[index] = !selection5[index];
        break;
    }
    setState(() {});
  }

  List _getSelectItem() {
    List list = selection1;
    switch (talbesIndex) {
      case 0:
        list = selection1;
        break;
      case 1:
        list = selection2;
        break;
      case 2:
        list = selection3;
        break;
      case 3:
        list = selection4;
        break;
      case 4:
        list = selection5;
        break;
    }
    return list;
  }
}

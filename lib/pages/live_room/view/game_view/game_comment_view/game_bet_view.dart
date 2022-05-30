import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';

/**
 * 下注
 */
class GameBetView extends StatefulWidget {
  RxList data;
  GameBetView(this.data);

  @override
  _GameBetViewState createState() => _GameBetViewState();
}

class _GameBetViewState extends State<GameBetView> with Toast {
  int betIndex = 0;

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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: gameBte(),
    );
  }

  Widget gameBte() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.pt),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "余额:",
                style: TextStyle(color: Colors.white, fontSize: 12.pt),
              ),
              Container(
                width: 65.pt,
                child: Text(
                  "0.0",
                  style: TextStyle(color: Colors.yellowAccent, fontSize: 12.pt),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showToast("刷新数据~~~");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.autorenew_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "充值",
                  style: TextStyle(
                      color: AppMainColors.string2Color("32C5FF"),
                      fontSize: 10.pt,
                      fontWeight: w_600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showToast("选择筹码");
                },
                child: Image.asset(
                  _mul[betIndex],
                  width: 32.pt,
                  height: 32.pt,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.pt),
                child: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white,
                ),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showToast("下注");
                    },
                    child: Image.asset(
                      AppImages.ic_confirm_button,
                      width: 54.pt,
                      height: 32.pt,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "投注",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.pt,
                            fontWeight: w_600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
 *  Copyright (C), 2015-2022
 *  FileName: cost_alert
 *  Author: Tonight丶相拥
 *  Date: 2022/1/6
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';
import '../../../mine/log_out.dart';

class TicketCostAlertWidget extends LogOutWidget {
  TicketCostAlertWidget({required VoidCallback onCancel,
    required VoidCallback onConfirm,
    required this.coins,
    this.leftTextTitle
  }): super(onCancel: onCancel, onLogOut: onConfirm);

  final String coins;
  final String? leftTextTitle;

  @override
  // TODO: implement contentDescription
  Widget get contentDescription => [Wrap(
    children: [
      CustomText("$contentText",
          fontSize: 16,
          fontWeight: w_400,
          color: Colors.black,
          textAlign: TextAlign.center
      )
    ]
  ).expanded()].row();

  @override
  // TODO: implement leftButton
  Widget get leftButton => CustomText("$leftText",
    fontSize: 16, fontWeight: w_500,
    color: Color.fromARGB(255, 34, 40, 49),
  );

  String get leftText => leftTextTitle ?? AppInternational.current.skip;

  String get contentText => AppInternational.current.ticketLivingRoom(coins);

  @override
  // TODO: implement rightButton
  Widget get rightButton => CustomText("$rightText",
    fontSize: 16, fontWeight: w_500,
    color: Colors.white
  );

  String get rightText => AppInternational.current.enterRoom;

  @override
  // TODO: implement logo
  Widget get logo => Image.asset(AppImages.costConfirm);
}

class TimerCostAlertWidget extends TicketCostAlertWidget {
  TimerCostAlertWidget({required VoidCallback onCancel,
    required VoidCallback onConfirm,
    required String coins,
    String? leftText
  }): super(onCancel: onCancel, onConfirm: onConfirm,
      coins: coins, leftTextTitle: leftText);

  String get contentText => AppInternational.current.timerLivingRoom(coins);
}

class CloseLivingAlertWidget extends TicketCostAlertWidget {
  CloseLivingAlertWidget({required VoidCallback onCancel,
    required VoidCallback onConfirm,
    required String coins,
    String? leftText
  }): super(onCancel: onCancel, onConfirm: onConfirm,
      coins: coins, leftTextTitle: leftText);

  @override
  // TODO: implement contentText
  String get contentText => AppInternational.current.livingClose;

  @override
  // TODO: implement logo
  Widget get logo => Image.asset(AppImages.closeLiving);

  @override
  // TODO: implement leftText
  String get leftText => AppInternational.current.cancel;

  @override
  // TODO: implement rightText
  String get rightText => AppInternational.current.close;
}
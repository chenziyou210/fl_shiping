/*
 *  Copyright (C), 2015-2021
 *  FileName: bind_bank_manager
 *  Author: Tonight丶相拥
 *  Date: 2021/11/29
 *  Description: 
 **/
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'bind_bank_manager_logic.dart';

class BindBankManager extends StatefulWidget {
  BindBankManager({dynamic arguments}): this.lastPageIsWithdraw = arguments["lastPageIsWithdraw"] ?? false;
  final bool lastPageIsWithdraw;
  @override
  createState()=> _BindBankManagerState();
}

class _BindBankManagerState extends AppStateBase<BindBankManager> {

  final BindBankManagerLogic _controller = BindBankManagerLogic();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
    _controller.loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<BindBankManagerLogic>();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.onlineManager}",
      fontSize: 16,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
    ),
    actions: [
      TextButton(
        onPressed: (){
          _controller.toggleState();
        },
        child: Obx((){
          return CustomText(_controller.state.unBinding.value ? "${intl.complete}" : "${intl.unBinding}",
              fontSize: 16, fontWeight: w_500,
              color: Color.fromARGB(255, 34, 40, 49));
        }))
    ]
  );

  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      SizedBox(
        height: 16
      ),
      RefreshWidget(
        onRefresh: (c) async{
          await _controller.loadData();
          c.refreshCompleted();
        },
        children: [
          Obx(() {
          return SliverList(delegate: SliverChildBuilderDelegate((_, index) {
            var model = _controller.state.data[index];
            return Obx((){
              return Stack(
                alignment: Alignment.center,
                children: [
                  Obx((){
                    return Container(
                      child: _controller.state.unBinding.value ?
                        Image.asset(AppImages.unbindCardBackground, fit: BoxFit.fill,
                            width: this.width, height: 170)
                        : Image.asset(AppImages.cardBackground, fit: BoxFit.fill,
                          width: this.width, height: 170)
                    );
                  }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText("${model.bankname}", fontSize: 14,
                            fontWeight: w_500,
                            color: Colors.white)
                        ]
                      ),
                      SizedBox(height: 16),
                      CustomText("${model.cardNumber}", fontSize: 24,
                        fontWeight: w_bold, 
                        color: Colors.white),
                      SizedBox(height: 16),
                      CustomText("${model.name}", fontSize: 16,
                        fontWeight: w_500, color: Colors.white),
                      SizedBox(height: 4),
                      // Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         CustomText("VALID", fontSize: 8, fontWeight: w_400, color: Colors.white),
                      //         CustomText("THRU", fontSize: 8, fontWeight: w_400, color: Colors.white)
                      //       ]
                      //     ),
                      //     SizedBox(width: 8),
                      //     CustomText("03/24", fontSize: 14, fontWeight: w_500, color: Colors.white)
                      //   ]
                      // )
                    ]
                  ).paddingSymmetric(horizontal: 16),
                  if (_controller.state.unBinding.value)
                    Positioned(child: Container(
                      alignment: Alignment.center,
                      color: Colors.red,
                      child: CustomText("${intl.delete}",
                        fontWeight: w_500, fontSize: 16,
                        color: Colors.white),
                    ).gestureDetector(onTap: (){
                      _controller.delete(index);
                    }), right: 0, top: 0, bottom: 0, width: 60)
                ]
              );
            }).clipRRect(radius: BorderRadius.circular(16)).gestureDetector(
              onTap: (){
                if (widget.lastPageIsWithdraw) {
                  popViewController(model);
                }
              }
            )
              .paddingSymmetric(horizontal: 16, vertical: 8);
          }, childCount: _controller.state.data.length));}),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              width: 200,
              height: 47,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 34, 40, 49),
                borderRadius: BorderRadius.circular(23.5),
                boxShadow: [BoxShadow(
                  color: Color.fromARGB(255, 34, 40, 49).withOpacity(0.2),
                  offset: Offset(0, 9),
                  blurRadius: 26
                )]
              ),
              child: CustomText("+${intl.addNewBank}", fontSize: 13, fontWeight: w_500, color: Colors.white)
            ).gestureDetector(
              onTap: (){
                pushViewControllerWithName(AppRoutes.bindBank).then((value) {
                  _controller.loadData();
                });
              }
            ).center
          )
        ]
      ).expanded()
    ]
  );
}
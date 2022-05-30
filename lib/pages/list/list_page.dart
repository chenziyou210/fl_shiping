/*
 *  Copyright (C), 2015-2021
 *  FileName: list_page
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:provider/provider.dart';
import 'list_page_model.dart';
import 'list_page_view.dart';

class ListPage extends StatefulWidget {
  ListPage({this.anchorId});
  @override
  createState() => _ListPageState();
  final String? anchorId;
}

class _ListPageState extends AppStateBase<ListPage> with SingleTickerProviderStateMixin {

  @override
  // TODO: implement model
  ListPageModel get model => super.model as ListPageModel;

  late final TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: model.viewModel,
      child: widget.anchorId == null ? scaffold : body
    );
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    leading: CustomBackButton(
      icon: Image.asset(AppImages.backIconWhite)
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backwardsCompatibility: false,
    title: Text(intl.list, style: AppStyles.f17w400c255_255_255),
    backgroundColor: Colors.transparent
  );
  
  @override
  // TODO: implement body
  Widget get body => Stack(
    children: [
      Positioned.fill(
        child: Image.asset(AppImages.listBackground,
          fit: BoxFit.fill)),
      Positioned.fill(
        child: SafeArea(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                    children: [
                      SizedBox(height: 8),
                      CustomTabBar(
                        labelPadding: EdgeInsets.zero,
                        isScrollable: true,
                        borderSide: BorderSide(
                          color: Colors.transparent
                        ),
                        onTap: (index) {
                          model.changeIndex(index);
                        },
                        tabs: (_) => [
                          SelectorCustom<ListPageViewModel, bool>(
                              builder: (value) {
                                return _ItemButton(title: intl.daily,
                                    showBackground: value);
                              },
                              selector: (l) => l.isDaily),
                          SelectorCustom<ListPageViewModel, bool>(
                              builder: (value) {
                                return _ItemButton(title: intl.weekly,
                                    showBackground: value);
                              },
                              selector: (l) => l.isWeekly),
                          SelectorCustom<ListPageViewModel, bool>(
                              builder: (value) {
                                return _ItemButton(title: intl.monthly,
                                    showBackground: value);
                              },
                              selector: (l) => l.isMonthly)
                        ],
                        controller: controller),
                      Expanded(child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ListPageView<ListPageViewModel>(model, index: 0),
                          ListPageView<ListPageViewModel>(model, index: 1),
                          ListPageView<ListPageViewModel>(model, index: 2)
                        ],
                        controller: controller
                      ))
                    ]
                ))))
    ]
  );

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return ListPageModel()..anchorId = widget.anchorId;
  }
}

class _ItemButton extends StatelessWidget {
  _ItemButton({required this.title,
    required this.showBackground, 
    Color? backgroundColor}): 
        this.backgroundColor = backgroundColor ?? Colors.white.withOpacity(0.2);
  final bool showBackground;
  final String title;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        height: 30,
        width: 80,
        alignment: Alignment.center,
        child: Text(title, style: showBackground
            ? AppStyles.f15w500c255_255_255
            : AppStyles.f15w400c255_255_255),
        decoration: BoxDecoration(
            color: showBackground ? backgroundColor : null,
            borderRadius: showBackground ? BorderRadius.circular(15) : null
        )
    );
    // return InkWell(
    //   onTap: onTap,
    //   child:
    // );
  }
}




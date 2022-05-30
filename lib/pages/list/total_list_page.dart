/*
 *  Copyright (C), 2015-2021
 *  FileName: total_list_page
 *  Author: Tonight丶相拥
 *  Date: 2021/10/11
 *  Description: 
 **/


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:provider/provider.dart';
import 'total_list_page_model.dart';
import 'list_page_view.dart';

class TotalListPage extends StatefulWidget {
  TotalListPage({dynamic arguments}): this.id = arguments["id"];
  @override
  createState() => _TotalListPageState();
  final String id;
}

class _TotalListPageState extends AppStateBase<TotalListPage> with Toast{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    show();
    model.dataRefresh();
  }

  @override
  // TODO: implement extendBodyBehindAppBar
  bool get extendBodyBehindAppBar => true;

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
      Positioned.fill(child: ListPageView<TotalListPageViewModel>(model, index: 0).safeArea())
    ],
  );

  @override
  // TODO: implement scaffold
  Widget get scaffold => ChangeNotifierProvider.value(value: model.viewModel1,
      child: super.scaffold);

  @override
  // TODO: implement model
  TotalListPageModel get model => super.model as TotalListPageModel;

  @override
  AppModel? initializeModel() {
    // TODO: implement initializeModel
    return TotalListPageModel()..anchorId = widget.id;
  }
}
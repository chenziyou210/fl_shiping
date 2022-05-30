

import 'package:flutter/material.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'custom_service_list_logic.dart';

class CustomServiceListPage extends StatefulWidget {
  @override
  createState() => _CustomServiceListPageState();
}

class _CustomServiceListPageState extends AppStateBase<CustomServiceListPage> {

  final CustomServiceListLogic _controller = CustomServiceListLogic();
  late final Future _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _controller.loadList();
  }
  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText(intl.customServiceGroup,
      fontSize: 16.pt,
      color: Color.fromARGB(255, 34, 40, 49),
    )
  );

  @override
  // TODO: implement body
  Widget get body => LoadingWidget(
    builder: (_, __) {
      return SizedBox();
    }, future: _future);
}
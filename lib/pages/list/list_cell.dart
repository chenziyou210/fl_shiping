/*
 *  Copyright (C), 2015-2021
 *  FileName: list_cell
 *  Author: Tonight丶相拥
 *  Date: 2021/7/19
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';

class ListCellModel {
  ListCellModel({
    required this.index,
    required this.account,
    required this.level,
    required this.isFollowed,
    required this.name,
    required this.avatar,
    required this.id
  });
  final int index;
  final String avatar;
  final String name;
  final String account;
  final int level;
  final bool isFollowed;
  final String id;
}

class ListCell extends StatefulWidget {
  ListCell(this.entity);
  final ListCellModel entity;
  final Size _imageSize = Size(74, 28);
  @override
  createState()=> _ListCellState(this.entity.isFollowed);
}

class _ListCellState extends State<ListCell> with Toast {
  _ListCellState(this._isFollow);
  bool _isFollow;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isFollow != widget.entity.isFollowed) {
      _isFollow = widget.entity.isFollowed;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 77,
        child: Row(
            children: [
              Text("${widget.entity.index}", style: AppStyles.f15w500c0_0_0),
              SizedBox(width: 16),
              ClipRRect(
                  child: ExtendedImage.network(
                      widget.entity.avatar,
                      enableLoadState: false,
                      width: 50, height: 50,
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(25)
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            children: [
                              Text("${widget.entity.name}",
                                  style: AppStyles.f16w400c0_0_0),
                              SizedBox(width: 4),
                              LevelWidget(AppImages.vipBackground, 20)
                            ]
                        ),
                        SizedBox(height: 4),
                        Text("${widget.entity.account}", style: AppStyles.f14w400c0_0_0.copyWith(
                            color: AppColors.c0_0_0.withOpacity(0.6)
                        ))
                      ]
                  )),
              if (!_isFollow)
                Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(AppImages.attentionButtonBackground,
                          width: widget._imageSize.width,
                          height: widget._imageSize.height,
                          fit: BoxFit.fill
                      ),
                      Text(AppInternational.of(context).attention,
                          style: AppStyles.f12w400c255_255_255)
                    ]
                ).gestureDetector(
                  onTap: (){
                    show();
                    HttpChannel.channel.favoriteInsert(widget.entity.id).then((value) =>
                      value.finalize(
                        wrapper: WrapperModel(),
                        failure: (e) => showToast(e),
                        success: (_) {
                          dismiss();
                          this._isFollow = !this._isFollow;
                          setState((){});
                        }
                      ));
                  }
                )
              else
                Container(
                    width: widget._imageSize.width,
                    height: widget._imageSize.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget._imageSize.height / 2),
                        border: Border.all(
                            color: AppColors.c165_59_227,
                            width: 1
                        )
                    ),
                    alignment: Alignment.center,
                    child: Text(intl.followed, style: AppStyles.f12w400c0_0_0.copyWith(
                        color: AppColors.c165_59_227
                    ))
                ).gestureDetector(
                    onTap: (){
                      show();
                      HttpChannel.channel.favoriteInsert(widget.entity.id).then((value) =>
                        value.finalize(
                          wrapper: WrapperModel(),
                          failure: (e) => showToast(e),
                          success: (_) {
                            dismiss();
                            this._isFollow = !this._isFollow;
                            setState((){});
                          }));
                    }
                )
            ]
        )
    );
  }
}
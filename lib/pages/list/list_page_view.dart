/*
 *  Copyright (C), 2015-2021
 *  FileName: list_page_view
 *  Author: Tonight丶相拥
 *  Date: 2021/9/23
 *  Description: 
 **/

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/index_rank_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/pages/component_widget/level_widget.dart';
import 'list_cell.dart';
import 'list_page_model.dart';

class ListPageView<T extends ListPageViewModel> extends StatefulWidget {
  ListPageView(this.model, {required this.index});
  @override
  createState() => _ListPageViewState<T>();
  final ListPageModel model;
  final int index;
}

class _ListPageViewState<T extends ListPageViewModel> extends AppStateBase<ListPageView>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.dataRefresh();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return body;
  }

  Widget get body => Container(
    child: Column(
      children: [
        SizedBox(height: 13),
        _SelectorWidget<T>(selector: (data) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (data.length > 1)
                      _Card(_RankCardSecond(data[1].header),
                          name: data[1].username!,//"Myrtie Clarke",
                          account: data[1].totalValue!.toString(),//"1063294",
                          level: data[1].rank!,
                          id: data[1].userId!,
                          follow: data[1].attention!,
                          followWidget: (f) => f ? _FollowedWidget(intl.followed) :
                            _AttentionWidget(intl.attention)
                      )
                    else
                      _CardVirtual(_RankCardSecond(null),
                          text: intl.virtualWaiting),
                    SizedBox(width: 8),
                    if (data.length > 0)
                      _Card(_RankCardFirst(data[0].header),
                          name: data[0].username!,//"Myrtie Clarke",
                          account: data[0].totalValue!.toString(),//"1063294",
                          level: data[0].rank!,
                          id: data[0].userId!,
                          follow: data[0].attention!,
                          followWidget: (f) => f ? _FollowedWidget(intl.followed) :
                          _AttentionWidget(intl.attention)
                      )
                    else
                      _CardVirtual(_RankCardFirst(null),
                          text: intl.virtualWaiting),
                    SizedBox(width: 8),
                    if (data.length > 2)
                      _Card(_RankCardThird(data[2].header),
                          name: data[2].username!,//"Myrtie Clarke",
                          account: data[2].totalValue!.toString(),//"1063294",
                          level: data[2].rank!,
                          id: data[2].userId!,
                          follow: data[2].attention!,
                          followWidget: (f) => f ? _FollowedWidget(intl.followed) :
                          _AttentionWidget(intl.attention)
                          // followWidget: data[2].attention! ? _FollowedWidget(intl.followed) :
                          // _AttentionWidget(intl.attention)
                      )
                    else
                      _CardVirtual(_RankCardThird(null),
                          text: intl.virtualWaiting)
                  ]
              );
            }, index: widget.index),
        SizedBox(height: 16),
        Expanded(child: Container(
            decoration: BoxDecoration(
                color: AppColors.c255_255_255,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(8)
                )
            ),
            child:RefreshWidget(
                children: [
                  _SelectorWidget<T>(selector: (data) {
                    if (data.length > 3) {
                      return SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (_, index) {
                                var model = data[index + 3];
                                return Column(
                                  children: [
                                    ListCell(
                                        ListCellModel(
                                            index: index + 4,
                                            id: model.userId!,
                                            account: model.totalValue.toString(),
                                            avatar: model.header ?? "",
                                            level: model.rank!,
                                            name: model.username!,
                                            isFollowed: model.attention!
                                        )
                                    ),
                                    CustomDivider(height: 1)
                                  ]
                                );
                              },
                            childCount: data.length - 3
                          )
                      );
                      // return ListView.separated(itemBuilder: (_, index) {
                      //   var model = data[index + 3];
                      //   return ;
                      // },
                      //     separatorBuilder: (_, __) => CustomDivider(height: 1),
                      //     itemCount: data.length - 3);
                    }else {
                      return SliverToBoxAdapter(
                        child: SizedBox()
                      );
                    }
                  }, index: widget.index)
                ],
                enablePullUp: true,
                onRefresh: (c) async{
                  await widget.model.dataRefresh();
                  c.refreshCompleted();
                  c.resetNoData();
                },
                onLoading: (c) async{
                  await widget.model.loadMore();
                  if (widget.model.hasMoreData) {
                    c.loadComplete();
                  }else {
                    c.loadNoData();
                  }
                }
        )))
      ]
    )
  );
}

class _SelectorWidget<T extends ListPageViewModel> extends StatelessWidget {
  _SelectorWidget({required this.selector, required this.index});
  final Widget Function(List<IndexRankEntity> data) selector;
  final int index;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SelectorCustom<T, List<IndexRankEntity>>(
        builder: (data) {
          return selector(data);
        },
        selector: (l) => index == 0 ? l.daily
          : (index == 1 ? l.week : l.month));
  }
}


class _CardVirtual extends StatelessWidget {
  _CardVirtual(this.child, {this.text: ""});
  final Widget child;
  final String text;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        children: [
          child,
          Positioned(child: Text("$text",
              style: AppStyles.f15w500c255_255_255), bottom: 40)
        ]
    );
  }
}

class _Card extends StatefulWidget {
  _Card(this.child, {required this.name,
    required this.account,
    required this.followWidget,
    required this.id,
    required this.level, required this.follow});
  final Widget child;
  final String name;
  final int level;
  final String account;
  final String id;
  final bool follow;
  final Widget Function(bool) followWidget;

  @override
  createState() => _CardState(follow);
}

class _CardState extends State<_Card> with Toast {
  _CardState(this._follow);
  bool _follow;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_follow != widget.follow){
      _follow = widget.follow;
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        children: [
          widget.child,
          Positioned(child: Container(
              child: Column(
                  children: [
                    Text(widget.name, style: AppStyles.f15c255_255_255),
                    SizedBox(height: 8),
                    LevelWidget(AppImages.vipBackground, 18),
                    SizedBox(height: 8),
                    Text(widget.account, style: AppStyles.f13w400c255_255_255),
                    SizedBox(height: 8),
                    widget.followWidget(_follow).gestureDetector(
                      onTap: (){
                        if (_follow) {
                          show();
                          HttpChannel.channel.favoriteCancel(widget.id).then((value) =>
                            value.finalize(
                              wrapper: WrapperModel(),
                              failure: (e) => showToast(e),
                              success: (_) {
                                dismiss();
                                _follow = !_follow;
                                setState(() {});
                              }
                            ));
                        }else {
                          show();
                          HttpChannel.channel.favoriteInsert(widget.id).then((value) =>
                            value.finalize(
                              wrapper: WrapperModel(),
                              failure: (e) => showToast(e),
                              success: (_) {
                                dismiss();
                                _follow = !_follow;
                                setState(() {});
                              }));
                        }
                      }
                    )
                  ]
              )
          ), left: 0, right: 0, bottom: 8)
        ]
    );
  }
}

class _RankCardFirst extends StatelessWidget {
  _RankCardFirst(this.avatar);
  final String? avatar;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 121,
                height: 157 + 68,
              ),
              Positioned(
                  child: Image.asset(AppImages.firstBackground),
                  left: 0, bottom: 0, right: 0
              ),
              Positioned(child: avatar == null ? SizedBox()
                  : _Avatar(AppImages.first,
                  avatar!, 78),
                  left: 0, right: 0, top: 0
              )
            ]
        )
    );
  }
}

class _RankCardSecond extends StatelessWidget {
  _RankCardSecond(this.avatar);
  final String? avatar;
  final String backGround = AppImages.secondBackground;
  final String crown = AppImages.second;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 109,
                height: 140 + 58,
              ),
              Positioned(
                  child: Image.asset(backGround),
                  left: 0, bottom: 0, right: 0
              ),
              Positioned(child: avatar == null ? SizedBox() : _Avatar(crown,
                  avatar!, 58, bottomMargin: 1.5),
                  left: 0, right: 0, top: 0
              )
            ]
        )
    );
  }
}

class _RankCardThird extends _RankCardSecond {
  _RankCardThird(String? avatar): super(avatar);
  final String backGround = AppImages.thirdBackground;
  final String crown = AppImages.third;
}

class _Avatar extends StatelessWidget {
  _Avatar(this.crownIcon, this.avatar,
      this.avatarSize, {this.bottomMargin: 2});
  final String crownIcon;
  final String avatar;
  final double avatarSize;
  final double bottomMargin;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(crownIcon),
          Positioned(child: ClipRRect(
              child: ExtendedImage.network(avatar,
                  enableLoadState: false,
                  fit: BoxFit.cover, width: avatarSize,
                  height: avatarSize),
              borderRadius: BorderRadius.circular(avatarSize / 2)
          ), bottom: 3)
        ]
    );
  }
}

class _FollowedWidget extends StatelessWidget {
  _FollowedWidget(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: 70,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: AppColors.c255_255_255,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
                color: AppColors.c255_255_255,
                width: 1
            )
        ),
        child: Text(text,
            style: AppStyles.f12w400c255_255_255)
    );
  }
}

class _AttentionWidget extends StatelessWidget {
  _AttentionWidget(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 70,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.c255_255_255,
          borderRadius: BorderRadius.circular(11)
      ),
      child: Text(text, style: AppStyles.f12w400c255_58_121),
    );
  }
}
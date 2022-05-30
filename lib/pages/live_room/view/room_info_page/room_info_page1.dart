// /*
//  *  Copyright (C), 2015-2021
//  *  FileName: room_info_page
//  *  Author: Tonight丶相拥
//  *  Date: 2021/12/9
//  *  Description:
//  **/
//
// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hjnzb/app_images/app_images.dart';
// import 'package:hjnzb/base/app_base.dart';
// import 'package:hjnzb/common/app_common_widget.dart';
// import 'package:hjnzb/common/colors.dart';
// import 'package:hjnzb/common/toast.dart';
// import 'package:hjnzb/generated/live_room_info_entity.dart';
// import 'package:hjnzb/http/http_channel.dart';
// import 'package:hjnzb/i18n/i18n.dart';
// import 'package:hjnzb/manager/app_manager.dart';
// import 'package:hjnzb/page_config/page_config.dart';
// import 'package:hjnzb/pages/alert_widget/live_alert.dart';
// import 'package:hjnzb/pages/live_room/view/bet_record/bet_record.dart';
// import 'package:hjnzb/pages/live_room/view/follow_bet/follow_bet.dart';
// import 'package:hjnzb/pages/live_room/view/game_view/game_base_view/game_base_view_view.dart';
// import 'package:hjnzb/pages/live_room/view/game_view/game_table/game_table_view.dart';
// import 'package:hjnzb/pages/live_room/view/game_view/game_view_view.dart';
// import 'package:hjnzb/pages/live_room/view/online_view/anchor_online_view.dart';
// import 'package:hjnzb/pages/live_room/view/online_view/audience_online_view.dart';
// import '../../live_room_chat_model.dart';
// import '../../live_room_enum.dart';
// import '../../live_room_new_logic.dart';
// import '../charge_view/charge_view.dart';
// import '../gift_card/gift_card.dart';
// import '../gift_package_view/gift_package_view.dart';
// // import '../gift_view.dart';
// // import '../share_link/share_link.dart';
//
// class RoomInfoPage extends StatefulWidget {
//   RoomInfoPage(this.isAnchor, this.imController,
//       {this.imRoomId: "", required this.anchorId});
//
//   /// 是否是主播
//   final bool isAnchor;
//   final String imRoomId;
//   final String Function() anchorId;
//   final IMModel imController;
//   @override
//   createState() => _RoomInfoPage();
// }
//
// class _RoomInfoPage extends AppStateBase<RoomInfoPage>
//     with AutomaticKeepAliveClientMixin, Toast {
//   /// 房间控制器
//   LiveRoomNewLogic get _roomController => Get.find<LiveRoomNewLogic>();
//
//   /// 聊天滚动器
//   final ScrollController _scrollController = ScrollController();
//
//   /// 房间信息
//   LiveRoomInfoEntity? get _roomModel => _roomController.state.roomInfo;
//
//   /// 节点
//   final FocusNode _node = FocusNode();
//   final TextEditingController _textController = TextEditingController();
//
//   /// 主播id
//   String? get _anchorId => widget.isAnchor
//       ? widget.anchorId()
//       : _roomController
//           .state.rooms[_roomController.state.roomIndex.value].id;
//   double? get _distance => _roomController
//       .state.rooms[_roomController.state.roomIndex.value].distance;
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.imController.setUp(_scrollToTop, (value) {
//       _roomController.setCoins(value);
//     });
//     if (widget.isAnchor) {
//       widget.imController.getRoom(widget.imRoomId);
//     }
//     _node.addListener(_textFiledState);
//     WidgetsBinding.instance?.addPostFrameCallback(_addListener);
//   }
//
//   void _addListener(_) {
//     widget.imController.intl = intl;
//   }
//
//   void _scrollToTop() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(0,
//           duration: Duration(milliseconds: 100), curve: Curves.easeIn);
//     }
//   }
//
//   void _textFiledState() {
//     if (_node.hasFocus) {
//       widget.imController.chats.onFocus();
//     } else {
//       widget.imController.chats.unFocus();
//     }
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     Get.delete<LiveRoomChatViewModel>();
//     _node.removeListener(_textFiledState);
//     widget.imController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     super.build(context);
//     return Stack(children: [
//       body,
//       if (!widget.isAnchor && _distance != null)
//         Positioned(
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 4),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.3),
//                   borderRadius:
//                       BorderRadius.horizontal(right: Radius.circular(30))),
//               child: [
//                 [
//                   CustomText("${AppInternational.of(context).distanceAnchor}",
//                       fontSize: 10, fontWeight: w_500, color: Colors.white),
//                   SizedBox(height: 2),
//                   CustomText("${_distance}km",
//                       fontSize: 10, fontWeight: w_500, color: Colors.white)
//                 ].column(crossAxisAlignment: CrossAxisAlignment.start),
//                 SizedBox(width: 4),
//                 Image.asset(AppImages.locationDistance),
//                 SizedBox(width: 4)
//               ].row(),
//             ),
//             left: 0,
//             top: context.height / 2),
//       Positioned(
//           child: Obx(() {
//             if (widget.imController.chats.isOnFocus.value) {
//               Widget child = CustomTextField(
//                 node: _node,
//                 hintText: "${intl.sayHi}~",
//                 textInputAction: TextInputAction.send,
//                 controller: _textController,
//                 textAlignVertical: TextAlignVertical.bottom,
//                 submit: (text) {
//                   if (text.isEmpty) {
//                     unFocus();
//                     widget.imController.chats.unFocus();
//                     return;
//                   }
//                   widget.imController.sendText(text);
//                   widget.imController.chats.unFocus();
//                   unFocus();
//                   _textController.clear();
//                 },
//                 hintTextStyle: TextStyle(
//                     fontWeight: w_400, color: Colors.black12, fontSize: 12.pt),
//                 style: TextStyle(
//                     fontWeight: w_400, color: Colors.black, fontSize: 12.pt),
//               );
//               return Obx(() {
//                 var v = widget.imController.chats.messageState.value;
//                 var type = v.type;
//                 if (type == MessageType.call) {
//                   child = Row(children: [
//                     Container(
//                         height: 40,
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 8),
//                         child: CustomText("@${v.ex["name"]}",
//                             fontSize: 12, color: Colors.black26)),
//                     child.expanded()
//                   ])
//                       .container(
//                           height: 40,
//                           width: context.width - 16,
//                           color: Colors.white)
//                       .clipRRect(radius: BorderRadius.circular(20));
//                 } else if (type == MessageType.reply) {
//                   child = Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         child,
//                         SizedBox(height: 8),
//                         CustomText("${v.ex["name"]}: ${v.ex["content"]}",
//                                 fontSize: 12, color: Colors.black26)
//                             .paddingSymmetric(horizontal: 8)
//                             .marginOnly(bottom: 8)
//                       ]).container(
//                       width: context.width - 16,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Colors.white));
//                 } else {
//                   child = child
//                       .container(
//                           height: 40,
//                           width: context.width - 16,
//                           color: Colors.white)
//                       .clipRRect(radius: BorderRadius.circular(20));
//                 }
//                 return AnimationPaddingView(child);
//               });
//             }
//             return SizedBox.shrink();
//           }),
//           bottom: 8,
//           left: 8)
//     ]);
//   }
//
//   @override
//   // TODO: implement body
//   Widget get body => Obx(() {
//         if (_roomController.state.roomInfoEmpty.value) {
//           return SizedBox();
//         }
//         return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           [
//             Row(mainAxisSize: MainAxisSize.min, children: [
//               SizedBox(width: 2),
//               ExtendedImage.network(_roomModel!.header!,
//                       width: 30.pt, height: 30.pt, fit: BoxFit.fill)
//                   .clipRRect(radius: BorderRadius.circular(15.pt)),
//               SizedBox(width: 4),
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 CustomText("${_roomModel!.username}",
//                     fontSize: 14.pt, fontWeight: w_500, color: Colors.white),
//                 CustomText("ID:${_roomModel!.memberId}",
//                     fontSize: 10.pt,
//                     fontWeight: w_400,
//                     color: Color.fromARGB(255, 165, 165, 165))
//               ]),
//               if (!widget.isAnchor) SizedBox(width: 8),
//               if (!widget.isAnchor)
//                 Obx(() {
//                   bool isAttention = _roomController.state.isFollowing.value;
//                   return Image.asset(
//                           isAttention
//                               ? AppImages.followedNew
//                               : AppImages.followNew,
//                           fit: BoxFit.fill,
//                           width: 28.pt,
//                           height: 28.pt)
//                       .gestureDetector(onTap: () {
//                     String userId = _roomController.state.roomInfo!.userid!;
//                     if (isAttention) {
//                       _roomController.followCancel(userId);
//                     } else {
//                       _roomController.follow(userId);
//                     }
//                   });
//                 }),
//               SizedBox(width: 2)
//             ])
//                 .container(
//                     // width: 146.pt,
//                     height: 34.pt,
//                     margin: EdgeInsets.only(left: 8),
//                     padding: widget.isAnchor ? EdgeInsets.only(right: 8) : null,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(17.pt),
//                         color: Colors.black.withOpacity(0.26)))
//                 .gestureDetector(onTap: () {
//               if (widget.isAnchor) return;
//               _roomController.userInfo(_anchorId!, 2, "").then((value) {
//                 alertViewController(LiveAlertWidget(value, _anchorId!,
//                         isLiveOwner: widget.isAnchor,
//                         anchorId: _anchorId!,
//                         showCallButton: true,
//                         userId: _roomController.state.roomInfo!.userid!,
//                         mute: value.banSpeak ?? false))
//                     .then((value) {
//                   if (value != null && value is bool) {
//                     if (value) {
//                       _roomController.following();
//                     } else {
//                       _roomController.cancelFollowing();
//                     }
//                   } else if (value != null && value is Map) {
//                     if (widget.imController.isMute) {
//                       showToast("${intl.muting}");
//
//                       ///util ${this._imController.muteUtil.replaceAll("T", " ")}
//                       return;
//                     }
//                     Future.delayed(Duration(milliseconds: 100), () {
//                       _node.requestFocus();
//                     });
//                     widget.imController.chats.onCall(
//                         _roomController.state.roomInfo!.userid ?? "",
//                         _roomController.state.roomInfo!.username ?? "");
//                   }
//                 });
//               });
//             }),
//             Spacer(),
//             Obx(() {
//               int length = _roomController.state.audiences.length;
//               if (length > 3) {
//                 length = 3;
//               }
//               if (length == 0) return SizedBox();
//
//               return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: List.generate(length, (index) {
//                     return [
//                       ExtendedImage.network(
//                               _roomController.state.audiences[index].header!,
//                               width: 26.pt,
//                               height: 26.pt,
//                               fit: BoxFit.cover)
//                           .clipRRect(radius: BorderRadius.circular(13.pt)),
//                       SizedBox(width: 4),
//                     ];
//                   }).reduce((value, element) => value + element)
//                     ..removeLast());
//             }).gestureDetector(onTap: () {
//               customShowModalBottomSheet(
//                   context: context,
//                   builder: (_) {
//                     if (widget.isAnchor)
//                       return AnchorOnlineView(_anchorId!, widget.imController);
//                     return AudienceOnlineView(_anchorId!);
//                   },
//                   fixedOffsetHeight: this.height * 0.5,
//                   isScrollControlled: false,
//                   barrierColor: Colors.transparent,
//                   backgroundColor: Colors.transparent);
//             }),
//             SizedBox(width: 4),
//             Container(
//               height: 26.pt,
//               padding: EdgeInsets.symmetric(horizontal: 4),
//               constraints: BoxConstraints(minWidth: 39.pt),
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.26),
//                   borderRadius: BorderRadius.circular(13.pt)),
//               child: Obx(() {
//                 return [
//                   CustomText("${_roomController.state.audience.value}",
//                       fontWeight: w_400, color: Colors.white, fontSize: 10.pt)
//                 ].column(mainAxisAlignment: MainAxisAlignment.center);
//               }),
//             ).gestureDetector(onTap: () {
//               customShowModalBottomSheet(
//                   context: context,
//                   builder: (_) {
//                     if (widget.isAnchor)
//                       return AnchorOnlineView(_anchorId!, widget.imController);
//                     return AudienceOnlineView(_anchorId!);
//                   },
//                   fixedOffsetHeight: this.height * 0.5,
//                   isScrollControlled: false,
//                   barrierColor: Colors.transparent,
//                   backgroundColor: Colors.transparent);
//             }),
//             CupertinoButton(
//                 child: Image.asset(AppImages.livingClose),
//                 onPressed: () {
//                   Navigator.of(context).maybePop();
//                 },
//                 padding: EdgeInsets.zero,
//                 minSize: 20,
//                 alignment: Alignment.center),
//             SizedBox(width: 8)
//           ].row(),
//           SizedBox(height: 8.pt),
//           Row(children: [
//             CupertinoButton(
//                 child: Container(
//                   height: 20.pt,
//                   decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.25),
//                       borderRadius: BorderRadius.circular(10.pt)),
//                   padding: EdgeInsets.symmetric(horizontal: 2),
//                   child: Row(children: [
//                     Image.asset(AppImages.livingCoin),
//                     SizedBox(width: 4),
//                     Obx(() {
//                       return CustomText("${_roomController.state.coins.value}",
//                           fontSize: 12.pt,
//                           fontWeight: w_400,
//                           color: Colors.white);
//                     }),
//                     SizedBox(width: 4),
//                     Image.asset(AppImages.forward,
//                         color: Colors.white, height: 8)
//                   ]),
//                 ),
//                 onPressed: () {
//                   pushViewControllerWithName(AppRoutes.contributionInLiving,
//                       arguments: {"id": _anchorId});
//                 },
//                 padding: EdgeInsets.zero),
//             SizedBox(width: 8),
//             CupertinoButton(
//                 child: Container(
//                   height: 20.pt,
//                   decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.25),
//                       borderRadius: BorderRadius.circular(10.pt)),
//                   padding: EdgeInsets.symmetric(horizontal: 2),
//                   child: Row(children: [
//                     Image.asset(AppImages.livingRank),
//                     SizedBox(width: 4),
//                     CustomText("${AppInternational.of(context).rank}",
//                         fontSize: 12.pt,
//                         fontWeight: w_400,
//                         color: Colors.white),
//                     SizedBox(width: 4),
//                     Image.asset(AppImages.forward,
//                         color: Colors.white, height: 8)
//                   ]),
//                 ),
//                 onPressed: () {
//                   // pushViewControllerWithName(AppRoutes.userRank);
//                   pushViewControllerWithName(AppRoutes.rankIntegration);
//                 },
//                 padding: EdgeInsets.zero)
//           ]).paddingOnly(left: 8),
//           Obx(() {
//             int count = _roomController.state.freeTimeCount.value;
//             if (count < 0) return SizedBox.shrink();
//             return Container(
//                 height: 20.pt,
//                 decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.25),
//                     borderRadius: BorderRadius.circular(10.pt)),
//                 padding: EdgeInsets.symmetric(horizontal: 2),
//                 child: Text.rich(TextSpan(
//                     style: TextStyle(fontSize: 16, fontWeight: w_bold),
//                     children: [
//                       TextSpan(
//                           text: "${intl.freeWatchRemaining}: ",
//                           style: TextStyle(color: Colors.white)),
//                       TextSpan(
//                           text: "$count", style: TextStyle(color: Colors.red))
//                     ])));
//           }).paddingOnly(left: 8),
//           Spacer(),
//
//           /// todo: 聊天
//           _Chats(
//                   widget.imController,
//                   _scrollController,
//                   widget.isAnchor,
//                   () => _anchorId!,
//                   _roomController.state.roomInfo!.username ?? "",
//                   _node)
//               .paddingOnly(left: 8),
//           // SizedBox(height: 16.pt),
//           Obx(() {
//             if (widget.imController.chats.isOnFocus.value) {
//               return SizedBox();
//             }
//             return Row(children: [
//               CupertinoButton(
//                   padding: EdgeInsets.zero,
//                   child: Container(
//                     height: 34.pt,
//                     width: 149.pt,
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.only(left: 8),
//                     decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.25),
//                         borderRadius: BorderRadius.circular(17.pt)),
//                     child: CustomText("${intl.sayHi}~",
//                         fontWeight: w_400,
//                         color: Colors.white,
//                         fontSize: 12.pt),
//                   ),
//                   onPressed: () {
//                     if (this.widget.imController.isMute) {
//                       showToast("${intl.muting}");
//
//                       ///util ${this._imController.muteUtil.replaceAll("T", " ")}
//                       return;
//                     }
//                     this.widget.imController.chats.onFocus();
//                     _node.requestFocus();
//                   }),
//               SizedBox(width: 8),
//               _CircleItem(
//                 child: Image.asset(AppImages.livingLottery),
//               ).cupertinoButton(onTap: () {
//                 // todo 开奖记录
//                 customShowModalBottomSheet(
//                     context: context,
//                     builder: (_) {
//                       return LotteryRecord();
//                     },
//                     fixedOffsetHeight: this.height * 0.5,
//                     isScrollControlled: false,
//                     barrierColor: Colors.transparent,
//                     backgroundColor: Colors.transparent);
//               }),
//               Spacer(),
//               if (!widget.isAnchor)
//                 _CircleItem(
//                         child: Image.asset(AppImages.anchorLiveRoomLinkCopy))
//                     .cupertinoButton(onTap: () {
//                   pushViewControllerWithName(AppRoutes.appShare,
//                       arguments: {"code": _anchorId});
//                   // showModalBottomSheet1(ShareLinkView(model: ShareModel(
//                   //   avatar: _roomController.state.rooms[_roomController.state.roomIndex.value].cover ?? "",//_roomController.state.roomInfo?.header ??
//                   //   nickName: _roomController.state.roomInfo?.username ?? "",
//                   //   roomLink: "https://translate.google.cn/?sl=zh-CN&tl=en&text=%E5%A4%8D%E5%88%B6%E6%88%BF%E9%97%B4%E9%93%BE%E6%8E%A5&op=translate",
//                   //   roomNumber: _roomController.state.roomInfo?.userid ?? ""
//                   // )), backGroundColor: Colors.transparent);
//                 }).marginOnly(right: 8),
//               if (!widget.isAnchor)
//                 SelectorCustom<SettingViewModel, bool>(
//                     builder: (value) {
//                       if (value) return SizedBox();
//                       return _CircleItem(
//                               child: Image.asset(AppImages.liveRoomCharge))
//                           .cupertinoButton(onTap: () {
//                         alertViewController(LiveChargeView1(
//                             onTap: () {
//                               popViewController();
//                             },
//                             onCharge: () {
//                               Navigator.of(context)
//                                   .popAndPushNamed(AppRoutes.chargePage);
//                             },
//                             url:
//                                 "https://www.111live.live/active/active/index.html"));
//                         // showModalBottomSheet1With(context, LiveChargeView(),
//                         //     backGroundColor: Colors.transparent);
//                       }).marginOnly(right: 8);
//                     },
//                     selector: (s) => s.isSameVersion),
//               _CircleItem(
//                 child: Image.asset(AppImages.livingGame),
//               ).cupertinoButton(onTap: () {
//                 customShowModalBottomSheet(
//                     context: context,
//                     builder: (_) {
//                       // return GameViewPage(_anchorId!);
//                       return GameTablePage();
//                     },
//                     fixedOffsetHeight: this.height * 0.5,
//                     isScrollControlled: false,
//                     barrierColor: Colors.transparent,
//                     backgroundColor: Colors.transparent);
//               }),
//               if (!widget.isAnchor) SizedBox(width: 8),
//               if (!widget.isAnchor)
//                 _CircleItem(
//                   child: Image.asset(AppImages.giftNew),
//                 ).cupertinoButton(onTap: () {
//                   showModalBottomSheet1(
//                           GiftPackageView(gifts: _roomController.state.gifts),
//                           barrierColor: Colors.transparent,
//                           backGroundColor: Colors.transparent)
//                       .then((value) {
//                     if (value != null && value is GiftModel) {
//                       HttpChannel.channel
//                           .brushGift(
//                               anchorId: _anchorId!,
//                               giftId: value.id,
//                               giftNum: value.number,
//                               type: value.type)
//                           .then((result) => result.finalize(
//                               wrapper: WrapperModel(),
//                               failure: (e) {
//                                 showToast(e);
//                               },
//                               success: (_) {
//                                 // int number = int.parse(value.number);
//                                 // _imController.sendText(value.name,
//                                 //     type: TextType.gift, number: number);
//                                 showToast("${intl.givingSuccess}");
//                               }));
//                     }
//                   });
//                 }),
//             ]);
//           }).paddingOnly(left: 8)
//         ]);
//       });
// }
//
// class _CircleItem extends StatelessWidget {
//   _CircleItem({required this.child});
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//         width: 34.pt,
//         height: 34.pt,
//         decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.25),
//             borderRadius: BorderRadius.circular(17.pt)),
//         child: child);
//   }
// }
//
// class _Chats extends StatefulWidget {
//   _Chats(this._imController, this._scrollController, this.isAnchor,
//       this.getAnchorId, this.name, this.node);
//
//   /// 聊天控制器
//   final IMModel _imController;
//
//   /// 聊天滚动器
//   final ScrollController _scrollController;
//
//   final bool isAnchor;
//   final String Function() getAnchorId;
//   final String name;
//   final FocusNode node;
//   @override
//   createState() => _ChatsState();
// }
//
// class _ChatsState extends AppStateBase<_Chats> with Toast {
//   /// 房间控制器
//   LiveRoomNewLogic get _roomController => Get.find<LiveRoomNewLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Stack(
//       children: [
//         body,
//         Obx(() {
//           return Offstage(
//               offstage: widget._imController.chats.count <= 0,
//               child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           color: Colors.white),
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       child: CustomText("${intl.someOneMentionedMe}",
//                           fontSize: 10,
//                           fontWeight: w_400,
//                           color: Color.fromARGB(255, 233, 88, 178)))
//                   .intervalButton(onTap: () {
//                 var m = widget._imController.chats.chats
//                     .where((p0) => p0.key != null);
//                 if (m.length > 0) {
//                   var m1 = m.last.key;
//                   if (m1!.currentContext != null)
//                     _getLocation(m1.currentContext!);
//                   m.last.key = null;
//                   widget._imController.subtractCount();
//                 }
//               }));
//         }).position(left: 12, bottom: 0)
//       ],
//     );
//   }
//
//   @override
//   // TODO: implement body
//   Widget get body => Container(
//       height: 200,
//       width: this.width,
//       margin: EdgeInsets.only(bottom: 16),
//       // color: Colors.red,
//       padding: EdgeInsets.only(left: 10),
//       alignment: Alignment.bottomCenter,
//       child: Obx(() {
//         return ListView.separated(
//             reverse: true,
//             padding: EdgeInsets.zero,
//             controller: widget._scrollController,
//             itemBuilder: (cellContext, index) {
//               var model = widget._imController.chats.chats[index];
//               /*
//               *
//   conversation,
//   /// 送礼物
//   gift,
//   mute,
//   muteCancel,
//   /// 初始化消息
//   initializeMessage,
//   /// 游戏开始
//   startGameIm,
//   attention,
//   enterLiveRoom,
//   winPrize,
//   /// 下注通知
//   bootomIm*/
//
//               if (model.type == TextType.bootomIm) {
//                 return _MessageWidget(
//                     child: RichText(
//                         text: TextSpan(children: [
//                   WidgetSpan(
//                       child: Container(
//                         height: 20,
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CustomText("${intl.bet}",
//                                   color: Colors.white, fontSize: 12)
//                             ]),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(colors: [
//                               Color.fromARGB(255, 252, 162, 109),
//                               Color.fromARGB(255, 190, 143, 135),
//                               Color.fromARGB(255, 116, 119, 162),
//                               Color.fromARGB(255, 59, 99, 185),
//                             ])),
//                       ),
//                       alignment: PlaceholderAlignment
//                           .middle), //Image.asset(AppImages.messageBet)
//                   WidgetSpan(child: SizedBox(width: 4)),
//                   TextSpan(
//                       text: "${model.content}",
//                       style: TextStyle(
//                           color: Color.fromARGB(255, 255, 188, 92),
//                           fontSize: 12.pt,
//                           fontWeight: w_600)),
//                   WidgetSpan(child: SizedBox(width: 4)),
//                   WidgetSpan(
//                       child: Container(
//                           height: 20,
//                           decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(10)),
//                           padding: EdgeInsets.symmetric(horizontal: 8),
//                           child: Row(mainAxisSize: MainAxisSize.min, children: [
//                             CustomText("${intl.getTogether}",
//                                 fontSize: 10.pt,
//                                 fontWeight: w_400,
//                                 color: Colors.white),
//                             Image.asset(AppImages.forward,
//                                 height: 8, color: Colors.white)
//                           ])).cupertinoButton(
//                           miniSize: 18,
//                           onTap: () {
//                             List lst = model.ex ?? [];
//                             if (lst.isEmpty) return;
//
//                             /// 跟投
//                             customShowModalBottomSheet(
//                                 context: context,
//                                 builder: (_) {
//                                   return FollowBetWidget(
//                                       model.name!,
//                                       model.id,
//                                       lst
//                                           .map((e) => BetModel(
//                                               betNumber: e["betNum"],
//                                               betValue: e["betValue"],
//                                               gamePlay: e["gamePlay"]))
//                                           .toList(),
//                                       anchorId: widget.getAnchorId());
//                                 },
//                                 fixedOffsetHeight: this.height * 0.5,
//                                 isScrollControlled: false,
//                                 barrierColor: Colors.transparent,
//                                 backgroundColor: Colors.transparent);
//                           }),
//                       alignment: PlaceholderAlignment.middle)
//                 ])));
//               } else if (model.type == TextType.initializeMessage) {
//                 return _MessageWidget(
//                     child: RichText(
//                         text: TextSpan(children: [
//                   WidgetSpan(
//                       child: Container(
//                         height: 20,
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CustomText("${intl.initializeMessage1}",
//                                   color: Colors.white, fontSize: 12)
//                             ]),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(colors: [
//                               Color.fromARGB(255, 253, 209, 224),
//                               Color.fromARGB(255, 238, 162, 190),
//                               Color.fromARGB(255, 231, 136, 168),
//                               Color.fromARGB(255, 223, 113, 152),
//                             ])),
//                       ),
//                       alignment: PlaceholderAlignment.middle),
//                   // WidgetSpan(
//                   //   child: Image.asset(AppImages.messageLocal)
//                   // ),
//                   WidgetSpan(child: SizedBox(width: 4)),
//                   TextSpan(
//                       text:
//                           "${intl.welcomeTo} ${widget.name} ${intl.livingRoom}, ${intl.initializeMessage}",
//                       style: TextStyle(
//                           fontSize: 12.pt,
//                           fontWeight: w_600,
//                           color: Color.fromARGB(255, 255, 146, 185)))
//                 ])));
//               } else if (model.type == TextType.startGameIm) {
//                 return _MessageWidget(
//                     child: RichText(
//                         text: TextSpan(children: [
//                   WidgetSpan(
//                       child: Container(
//                         height: 20,
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CustomText("${intl.gameStart1}",
//                                   color: Colors.white, fontSize: 12)
//                             ]),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(colors: [
//                               Color.fromARGB(255, 220, 252, 153),
//                               Color.fromARGB(255, 186, 241, 120),
//                               Color.fromARGB(255, 184, 233, 133),
//                               Color.fromARGB(255, 143, 208, 115),
//                             ])),
//                       ),
//                       alignment: PlaceholderAlignment
//                           .middle), // WidgetSpan(child: Image.asset(AppImages.messageGameStart)),
//                   WidgetSpan(child: SizedBox(width: 4)),
//                   TextSpan(
//                       text: "${model.name} ${intl.gameStart}",
//                       style: TextStyle(
//                           fontSize: 12.pt,
//                           fontWeight: w_600,
//                           color: Color.fromARGB(255, 156, 215, 131)))
//                 ])));
//               }
//               // else if (model.type == TextType.attention){
//               //   return messageWidget(RichText(text: TextSpan(
//               //     children: [
//               //       WidgetSpan(child: Image.asset(AppImages.gradeList + "${model.level}.png",
//               //           height: 20.pt, fit: BoxFit.fill
//               //       )),
//               //     ]
//               //   )));
//               // }
//               // else if (model.type == TextType.enterLiveRoom) {
//               //
//               // }
//               else if (model.type == TextType.winPrize) {
//                 return _MessageWidget(
//                     child: RichText(
//                         text: TextSpan(children: [
//                   WidgetSpan(
//                       child: Container(
//                         height: 20,
//                         padding: EdgeInsets.symmetric(horizontal: 8),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               CustomText("${intl.winPrize}",
//                                   color: Colors.white, fontSize: 12)
//                             ]),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(colors: [
//                               Color.fromARGB(255, 248, 196, 55),
//                               Color.fromARGB(255, 244, 167, 153),
//                               Color.fromARGB(255, 235, 121, 239),
//                               Color.fromARGB(255, 133, 189, 247),
//                               Color.fromARGB(255, 84, 222, 248),
//                             ])),
//                       ),
//                       alignment: PlaceholderAlignment
//                           .middle), // WidgetSpan(child: Image.asset(AppImages.messageWinPrize)),
//                   WidgetSpan(child: SizedBox(width: 4)),
//                   TextSpan(
//                       text: "${model.content}",
//                       style: TextStyle(
//                           fontSize: 12.pt,
//                           fontWeight: w_600,
//                           color: Color.fromARGB(255, 253, 115, 255)))
//                 ])));
//               } else if (model.type == TextType.gift) {
//                 return Row(children: [
//                   _MessageWidget(
//                       child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     SizedBox(
//                       child: ExtendedImage.network(model.pic!,
//                           enableLoadState: false,
//                           width: 26.pt,
//                           height: 26.pt,
//                           fit: BoxFit.fill),
//                     ),
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             "${model.name}",
//                             fontWeight: w_400,
//                             fontSize: 12.pt,
//                             color: Colors.white,
//                           ),
//                           SizedBox(height: 2),
//                           CustomText("${model.content}",
//                               fontWeight: w_400,
//                               fontSize: 12.pt,
//                               color: Color.fromARGB(255, 235, 121, 239))
//                         ]),
//                   ])),
//                   SizedBox(width: 8),
//                   CustomText("X",
//                       style: TextStyle(
//                           fontSize: 26.pt,
//                           fontWeight: w_400,
//                           color: Color.fromARGB(255, 84, 222, 248))),
//                   CustomText("${model.num}",
//                       style: TextStyle(
//                           fontSize: 26.pt,
//                           fontWeight: w_400,
//                           color: Color.fromARGB(255, 244, 167, 153)))
//                 ]);
//               }
//               Widget child = RichText(
//                   text: TextSpan(children: [
//                 WidgetSpan(
//                     child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Image.asset(AppImages.gradeList + "${model.level}.png",
//                       height: 20.pt, fit: BoxFit.fill),
//                   SizedBox(width: 4),
//                   CustomText(
//                       "${model.name}${model.type == TextType.attention || model.type == TextType.enterLiveRoom ? " " : " : "}",
//                       style: TextStyle(
//                           fontSize: 12.pt,
//                           fontWeight: w_600,
//                           color: _getColor(model.level!)))
//                 ]).gestureDetector(onTap: () => _userInfo(model))),
//                 if (model.messageType == MessageType.call)
//                   TextSpan(
//                       text: "@${model.ex["name"]}  ",
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: w_500,
//                           color: Colors.white)),
//                 TextSpan(
//                     text: "${_getString(model.type, model.content)}",
//                     style: TextStyle(
//                         fontSize: 12.pt,
//                         fontWeight: w_600,
//                         color: Colors.white))
//               ]));
//
//               /// 聊天、 关注、进入直播间
//               if (model.messageType == MessageType.reply) {
//                 child = Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       child,
//                       SizedBox(height: 4),
//                       Container(
//                         padding: EdgeInsets.only(left: 4) +
//                             EdgeInsets.symmetric(vertical: 4),
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 left: BorderSide(
//                                     width: 1,
//                                     color: Color.fromARGB(255, 233, 88, 178)))),
//                         child: CustomText(intl.quote,
//                             fontSize: 10,
//                             fontWeight: w_500,
//                             color: Color.fromARGB(255, 233, 88, 178)),
//                       ),
//                       RichText(
//                           text: TextSpan(
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 154, 231,
//                                       255), //rgba(1, 154, 231, 1)
//                                   fontSize: 12,
//                                   fontWeight: w_600),
//                               children: [
//                             TextSpan(text: "${model.ex["name"]}"),
//                             TextSpan(
//                                 text: ": " + (model.ex["content"] ?? ""),
//                                 style: TextStyle(
//                                     color: Colors.white, fontWeight: w_400))
//                           ]))
//                     ]);
//               }
//               return _MessageWidget(child: child, key: model.key)
//                   .gestureDetector(onTap: () {
//                 if (model.type == TextType.attention) {
//                   return;
//                 }
//                 if (widget._imController.isMute) {
//                   showToast("${intl.muting}");
//
//                   ///util ${this._imController.muteUtil.replaceAll("T", " ")}
//                   return;
//                 }
//                 var user = AppManager.getInstance<AppUser>();
//                 if (model.id == user.userId && model.id.isNotEmpty) {}
//                 widget.node.requestFocus();
//                 String content = model.content;
//                 if (model.messageType == MessageType.call) {
//                   content = "@${model.ex["name"]}: " + content;
//                 }
//                 widget._imController.chats
//                     .onReply(model.id, model.name ?? "", model.content);
//               });
//             },
//             separatorBuilder: (_, __) => SizedBox(height: 5),
//             itemCount: widget._imController.chats.chats.length);
//       }));
//
//   String _getString(TextType type, String defaultContent) {
//     if (TextType.attention == type) {
//       return intl.attentionLivingRoom;
//     } else if (TextType.enterLiveRoom == type) {
//       return intl.enterLivingRoom;
//     }
//     return defaultContent;
//   }
//
//   /// 用户信息
//   void _userInfo(ChatModel model) async {
//     if (!widget.isAnchor) {
//       return;
//     }
//     if (model.id == AppManager.getInstance<AppUser>().userId) {
//       return;
//     }
//     var user = await this._roomController.userInfo(model.id, 1, model.id);
//     var id = widget.getAnchorId();
//     alertViewController(LiveAlertWidget(
//       user,
//       model.id,
//       isLiveOwner: widget.isAnchor,
//       anchorId: id,
//       mute: user.banSpeak ?? false,
//       hideAttentionButton: true,
//       userId: model.id,
//     ));
//   }
//
//   /// 根据等级获取颜色
//   Color _getColor(int level) {
//     Color color = Color.fromARGB(255, 253, 128, 6);
//     if (level >= 10 && level <= 19) {
//       color = Color.fromARGB(255, 131, 159, 186);
//     } else if (level >= 20 && level <= 29) {
//       color = Color.fromARGB(255, 157, 107, 222); //157, 107, 222, 1
//     } else if (level >= 30 && level <= 39) {
//       color = Color.fromARGB(255, 236, 138, 47); //236, 138, 47, 1
//     } else if (level >= 40 && level <= 49) {
//       color = Color.fromARGB(255, 1, 154, 231); //1, 154, 231, 1
//     } else if (level >= 50 && level <= 59) {
//       color = Color.fromARGB(255, 234, 71, 91); //234, 71, 91, 1
//     } else if (level >= 60 && level <= 69) {
//       color = Color.fromARGB(255, 227, 37, 151); //227, 37, 151, 1
//     } else if (level >= 70 && level <= 79) {
//       color = Color.fromARGB(255, 232, 44, 93); //232, 44, 93, 1
//     } else if (level >= 80 && level <= 89) {
//       color = Color.fromARGB(255, 151, 91, 254); //151, 91, 254, 1
//     } else if (level >= 90 && level <= 94) {
//       color = Color.fromARGB(255, 151, 91, 254); //151, 91, 254, 1
//     } else if (level >= 95 && level <= 100) {
//       color = Color.fromARGB(255, 138, 144, 159); //138, 144, 159, 1
//     }
//     return color;
//   }
//
//   void _getLocation(BuildContext cellContext) {
//     RenderBox box = cellContext.findRenderObject() as RenderBox;
//     var x =
//         box.localToGlobal(Offset.zero, ancestor: context.findRenderObject()) &
//             box.size;
//     double offset = x.top;
//     if (x.top < 0) offset = -offset;
//     widget._scrollController.animateTo(offset + widget._scrollController.offset,
//         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
//   }
// }
//
// class _MessageWidget extends StatelessWidget {
//   _MessageWidget({required this.child, this.key});
//   final Widget child;
//   final GlobalKey? key;
//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//         child: Align(
//             // key: key,
//             alignment: Alignment.centerLeft,
//             child: Container(
//                 decoration: BoxDecoration(
//                     color: AppColors.c0_0_0.withOpacity(0.25),
//                     borderRadius: BorderRadius.circular(8)),
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.6),
//                 padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//                 child: child)),
//         key: key);
//   }
// }

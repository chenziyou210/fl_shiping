/*
 *  Copyright (C), 2015-2021
 *  FileName: mine
 *  Author: Tonight丶相拥
 *  Date: 2021/7/13
 *  Description: 
 **/

import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';

// import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/http/cache.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/i18n/local_model.dart';
import 'package:hjnzb/manager/app_manager.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live_room/view/grade_image.dart';
import 'package:hjnzb/pages/mine/log_out.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class MinePage extends StatefulWidget {
  @override
  createState() => _MinPageState();
}

class _MinPageState extends AppStateBase<MinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  bool? _isAnchor;

  bool get isAnchor =>
      (_isAnchor ??= AppManager.getInstance<AppUser>().enableOpenLive);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return scaffold;
  }

  @override
  // TODO: implement body
  Widget get body => Container(
      child: RefreshIndicator(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 251.pt,
              // systemOverlayStyle: SystemUiOverlayStyle.dark,
              toolbarHeight: 0,
              pinned: true,
              floating: true,
              snap: true,
              // primary: false,
              // collapsedHeight: 0,
              collapsedHeight: 251.pt,
              bottom: SpecialAppBar([
                Container(
                    height: 251.pt,
                    width: this.width,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: AppMainColors.backgroudColor,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.appbar_bg),
                        )),
                    child: Column(children: [
                      SizedBox(height: 66.pt),

                      _UserCard(),
                      SizedBox(height: 16.pt),
                      Row(children: [
                        _Attention(intl.attention, () {
                          pushViewControllerWithName(AppRoutes.favoriteNewList);
                        }),
                        Container(
                            color: Color.fromARGB(255, 224, 216, 233),
                            width: 1,
                            height: 34.pt),
                        _Fans(intl.fans, () {
                          pushViewControllerWithName(AppRoutes.fansList);
                        })
                      ]),
                      // if (!isAnchor)
                      //   Row(children: [
                      //     SelectorCustom<SettingViewModel, bool>(
                      //         builder: (value) {
                      //           Widget w = _WalletItem(
                      //               buttonTitle: "${intl.recharge}",
                      //               subTitle: "${intl.diamond}",
                      //               hideButton: value,
                      //               // height: v.data == value ? 65 : null,
                      //               // backgroundImage: v.data == value ? AppImages.mineAnchorWithdraw : null,
                      //               width: value ? this.width : null,
                      //               child: SelectorCustom<AppUser, double?>(
                      //                 builder: (value) {
                      //                   return CustomText(
                      //                     "$value",
                      //                     style: TextStyle(
                      //                         color: Color.fromARGB(
                      //                             255, 230, 196, 132),
                      //                         fontSize: 14.pt,
                      //                         fontWeight: w_bold),
                      //                   );
                      //                 },
                      //                 selector: (a) => a.lockMoney,
                      //               ),
                      //               onTap: () {
                      //                 pushViewControllerWithName(
                      //                     AppRoutes.chargePage);
                      //               });
                      //           // if (v.data == value)
                      //           //   return w.expanded();
                      //           return w;
                      //         },
                      //         selector: (s) => s.isSameVersion),
                      //     Spacer(),
                      //     SelectorCustom<SettingViewModel, bool>(
                      //         builder: (value) {
                      //           return _WalletItem(
                      //               hideButton: value,
                      //               buttonTitle: "${intl.withdraw}",
                      //               subTitle: "${intl.balance}",
                      //               child: SelectorCustom<AppUser, double?>(
                      //                   builder: (value) {
                      //                     return CustomText(
                      //                       "$value",
                      //                       style: TextStyle(
                      //                           color: Color.fromARGB(
                      //                               255, 230, 196, 132),
                      //                           fontSize: 14.pt,
                      //                           fontWeight: w_bold),
                      //                     );
                      //                   },
                      //                   selector: (a) => a.lockMoney //a.coins,
                      //                   ),
                      //               onTap: () {
                      //                 pushViewControllerWithName(
                      //                     AppRoutes.withdrawNew);
                      //               });
                      //         },
                      //         selector: (s) => s.isSameVersion)
                      //   ])
                      // else
                      //   Row(children: [
                      //     SelectorCustom<SettingViewModel, bool>(
                      //         builder: (value) {
                      //           return _WalletItem(
                      //               hideButton: value,
                      //               buttonTitle: "${intl.withdraw}",
                      //               subTitle: "${intl.totalAssets}",
                      //               backgroundImage:
                      //                   AppImages.mineAnchorWithdraw,
                      //               width: this.width,
                      //               height: 65,
                      //               // width: 343,
                      //               child: SelectorCustom<AppUser, double?>(
                      //                 builder: (value) {
                      //                   return CustomText("$value",
                      //                       fontSize: 14.pt,
                      //                       fontWeight: w_bold,
                      //                       color: Color.fromARGB(
                      //                           255, 230, 196, 132));
                      //                 },
                      //                 selector: (a) => a.lockMoney ?? 0,
                      //               ),
                      //               onTap: () {
                      //                 pushViewControllerWithName(
                      //                     AppRoutes.withdrawNew);
                      //               }).expanded();
                      //         },
                      //         selector: (s) => s.isSameVersion)
                      //   ])
                    ]))
              ], marginTop: 0, height: 0),
            ),
            SizedBox(height: 16).sliverToBoxAdapter,
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  //钱包、提现等
                  Container(
                      decoration: BoxDecoration(
                          color: AppMainColors.separaLineColor6,
                          borderRadius: BorderRadius.circular(8.pt)),
                      child: Row(children: [
                        _FuncItem(
                          title: "${intl.accountDetail}",
                          image: AppImages.ic_wallet,
                          onTap: () {
                            pushViewControllerWithName(AppRoutes.accountDetail);
                          },
                        ).expanded(),
                        SelectorCustom<SettingViewModel, bool>(
                            builder: (value) {
                              if (value) return SizedBox();
                              return _FuncItem(
                                title: "${intl.withdraw}",
                                image: AppImages.ic_withdraw,
                                onTap: () {
                                  pushViewControllerWithName(
                                      AppRoutes.withdrawNew);
                                },
                              ).expanded();
                            },
                            selector: (s) => s.isSameVersion),
                        _FuncItem(
                            title: "${intl.noble}",
                            image: AppImages.ic_noble,
                            onTap: () {
                              pushViewControllerWithName(AppRoutes.betRecord);
                            }).expanded(),
                        if (!isAnchor)
                          SelectorCustom<SettingViewModel, bool>(
                              builder: (value) {
                                if (value) return SizedBox();
                                return _FuncItem(
                                  title: "${intl.bobiWallet}",
                                  image: AppImages.ic_bobi_wallet,
                                  onTap: () {
                                    pushViewControllerWithName(
                                        AppRoutes.chargeRecord);
                                  },
                                ).expanded();
                              },
                              selector: (s) => s.isSameVersion)
                      ])),
                  SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                          color: AppMainColors.separaLineColor6,
                          borderRadius: BorderRadius.circular(8.pt)),
                      width: 343.pt,
                      child: Column(children: [
                        if (!isAnchor)
                          _CellItem(
                              image: AppImages.ic_balance,
                              title: "${intl.balanceDetail}",
                              onTap: () {
                                pushViewControllerWithName(
                                    AppRoutes.accountDetail);
                              }),
                        _CellItem(
                            image: AppImages.ic_game_record,
                            title: "${intl.gameRecord}",
                            hasDivider: false,
                            onTap: () {
                              pushViewControllerWithName(
                                  AppRoutes.modifyLogInPassword);
                            }),
                      ])),
                  SizedBox(height: 8),
                  Container(
                      decoration: BoxDecoration(
                          color: AppMainColors.separaLineColor6,
                          borderRadius: BorderRadius.circular(8.pt)),
                      width: 343.pt,
                      child: Column(children: [
                        if (!isAnchor)
                          _CellItem(
                              image: AppImages.ic_edit_profile,
                              title: "${intl.editProfile}",
                              onTap: () {
                                var user = AppManager.getInstance<AppUser>();
                                Navigator.of(context)
                                    .pushNamed(
                                        AppRoutes.editPersonalInformation,
                                        arguments: user.toJson())
                                    .then((value) {
                                  if (value != null &&
                                      value is Map<String, dynamic>) {
                                    user.updateData(value);
                                  }
                                });
                              }),
                        _CellItem(
                            image: AppImages.ic_phone_verify,
                            title: "${intl.phoneVerify}",
                            onTap: () {
                              pushViewControllerWithName(
                                  AppRoutes.vipGradePage);
                            }),
                        _CellItem(
                            image: AppImages.ic_bag,
                            title: "${intl.myBag}",
                            onTap: () {
                              pushViewControllerWithName(AppRoutes.switchWay);
                            }),
                        _CellItem(
                            image: AppImages.ic_diamond,
                            title: "${intl.grade}",
                            onTap: () {
                              pushViewControllerWithName(
                                  AppRoutes.modifyPayPassword);
                            }),
                        _CellItem(
                            image: AppImages.ic_customer_service,
                            title: "${intl.customerService}",
                            hasDivider: false,
                            onTap: () {
                              pushViewControllerWithName(
                                  AppRoutes.modifyLogInPassword);
                            }),
                      ])),
                  SizedBox(height: 12),

                  /// todo 退出登录
                  CupertinoButton(
                          minSize: 44.pt,
                          onPressed: () {
                            alertViewController(LogOutWidget(onCancel: () {
                              popViewController();
                            }, onLogOut: () async {
                              popViewController();
                              try {
                                // true: 是否解除deviceToken绑定。
                                await EMClient.getInstance.logout(true);
                              } on EMError catch (e) {
                                print('操作失败，原因是: $e');
                              }
                              HttpChannel.channel.logOut();
                              // await trtcLogOut();
                              // await trtcVoiceRoomLogOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRoutes.logInNew, (route) => false);
                              EventBus.instance.removeAllListener();
                              AppManager.getInstance<AppUser>().logOut();
                            }));
                            // alertViewController(AlertDialog(
                            //   content: Text(intl.isLogOut),
                            //   title: Text(intl.notice, style: AppStyles.f14w400c0_0_0),
                            //   actions: [
                            //     GestureDetector(
                            //       onTap: (){
                            //         popViewController();
                            //       },
                            //       child: Text(intl.cancel),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () async{
                            //         popViewController();
                            //         try {
                            //           // true: 是否解除deviceToken绑定。
                            //           await EMClient.getInstance.logout(true);
                            //         } on EMError catch (e) {
                            //           print('操作失败，原因是: $e');
                            //         }
                            //
                            //         // await trtcLogOut();
                            //         // await trtcVoiceRoomLogOut();
                            //         Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.logInNew, (route) => false);
                            //         AppManager.getInstance<AppUser>().logOut();
                            //       },
                            //       child: Text(intl.confirm),
                            //     ),
                            //   ],
                            // ));
                          },
                          child: CustomText("${intl.logOut}",
                              fontSize: 14.pt,
                              fontWeight: w_400,
                              color: Color.fromARGB(255, 95, 95, 95)),
                          //.center.sizedBox(width: 343.pt, height: 44.pt),
                          color: Color.fromARGB(255, 228, 228, 235))
                      .sizedBox(width: 343.pt),
                  SizedBox(height: 16)
                ])).sliverToBoxAdapter
            //singleScrollView(physics: BouncingScrollPhysics()).expanded()
          ]),
          onRefresh: () async {
            await HttpChannel.channel.userInfo().then((value) => value.finalize(
                wrapper: WrapperModel(),
                success: (data) {
                  AppManager.getInstance<AppUser>().fromJson(data, false);
                }));
            return;
          }));

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => Color.fromARGB(255, 240, 240, 244);
}

class _CellItem extends StatelessWidget {
  _CellItem(
      {required this.onTap,
      required this.title,
      required this.image,
      this.subTitle,
      this.hasDivider = true});

  final VoidCallback onTap;
  final String title;
  final String image;
  final Widget? subTitle;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWellRow(children: [
              Image.asset(
                image,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 16),
              CustomText("$title",
                  fontSize: 14.pt,
                  fontWeight: w_400,
                  color: AppMainColors.whiteColor100),
              Spacer(),
              subTitle ?? Image.asset(AppImages.forward)
            ], onTap: onTap),
            if (hasDivider)
              CustomDivider(
                color: AppMainColors.separaLineColor6,
              ).position(left: 32, bottom: 0, right: 0),
          ],
        ),
        height: 50.pt);
  }
}

class _FuncItem extends StatelessWidget {
  _FuncItem({required this.image, required this.title, required this.onTap});

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        image,
        width: 48,
        height: 48,
      ),
      SizedBox(height: 4),
      CustomText("$title",
          fontWeight: w_400,
          fontSize: 14.pt,
          textAlign: TextAlign.center,
          color: AppMainColors.whiteColor100)
    ])).gestureDetector(onTap: onTap);
  }
}

class _FansItemBase extends StatelessWidget {
  _FansItemBase(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: [
      selector,
      SizedBox(height: 4),
      CustomText("$title",
          fontSize: 14.pt, fontWeight: w_400, color: AppMainColors.whiteColor40)
    ]).gestureDetector(onTap: _onTap));
  }

  int? get num => null;

  Widget get selector => SizedBox();

  Widget get numberWidget => CustomText("$num",
      fontSize: 16.pt, fontWeight: w_bold, color: AppMainColors.whiteColor100);

  void _onTap() {}
}

class _Fans extends _FansItemBase {
  _Fans(String title, this.onTap) : super(title);
  final VoidCallback onTap;

  @override
  int? get num => AppManager.getInstance<AppUser>().fansNum;

  @override
  Widget get selector => SelectorCustom<AppUser, int?>(
      builder: (_) {
        return numberWidget;
      },
      selector: (a) => a.fansNum);

  @override
  void _onTap() => onTap();
}

class _Attention extends _FansItemBase {
  _Attention(String title, this.onTap) : super(title);

  final VoidCallback onTap;

  @override
  int? get num => AppManager.getInstance<AppUser>().attentionNum;

  @override
  Widget get selector => SelectorCustom<AppUser, int?>(
      builder: (_) {
        return numberWidget;
      },
      selector: (a) => a.attentionNum);

  @override
  void _onTap() => onTap();
}

class _WalletItem extends StatelessWidget {
  _WalletItem(
      {required this.buttonTitle,
      required this.subTitle,
      required this.child,
      required this.onTap,
      this.width,
      this.height,
      this.backgroundImage,
      this.hideButton: false});

  final String buttonTitle;
  final String subTitle;
  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final String? backgroundImage;
  final bool hideButton;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(alignment: Alignment.center, children: [
      Image.asset(backgroundImage ?? AppImages.mineWalletItemBackground,
          fit: BoxFit.fill, width: width ?? 165.pt, height: this.height),
      Row(children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              SizedBox(height: 8),
              CustomText("$subTitle",
                  fontSize: 12.pt,
                  fontWeight: w_500,
                  color: Color.fromARGB(255, 161, 165, 181))
            ]).expanded(),
        if (!hideButton)
          Container(
                  height: 28.pt,
                  width: 60.pt,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.pt),
                      gradient: LinearGradient(
                          colors: AppColors.buttonGradientColors)),
                  child: CustomText("$buttonTitle",
                      fontSize: 14.pt, fontWeight: w_500, color: Colors.white))
              .cupertinoButton(onTap: onTap)
      ]).padding(padding: EdgeInsets.symmetric(horizontal: 8))
    ]).sizedBox(width: 165.pt);
  }
}

class _UserCard extends StatelessWidget with Toast {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Stack(children: [
        SelectorCustom<AppUser, String?>(
            builder: (value) {
              return ExtendedImage.network(value ?? "",
                      enableLoadState: false,
                      width: 66.pt,
                      height: 66.pt,
                      fit: BoxFit.cover)
                  .clipRRect(radius: BorderRadius.circular(33.pt))
                  .padding(padding: EdgeInsets.only(bottom: 4));
            },
            selector: (a) => a.header),
        Positioned(
            child: Image.asset(AppImages.personalInfoModify).gestureDetector(
                onTap: () {
              var user = AppManager.getInstance<AppUser>();
              Navigator.of(context)
                  .pushNamed(AppRoutes.editPersonalInformation,
                      arguments: user.toJson())
                  .then((value) {
                if (value != null && value is Map<String, dynamic>) {
                  user.updateData(value);
                }
              });
            }),
            right: 4,
            bottom: 0)
      ]),
      SizedBox(width: 16),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        [
          SelectorCustom<AppUser, String?>(
              builder: (value) {
                if (value.toString().length > 8) {
                  value = value.toString().substring(0, 8) + "...";
                }
                return CustomText("$value",
                    fontSize: 22.pt,
                    fontWeight: w_bold,
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 25, 29, 36));
              },
              selector: (a) => a.name),
          SizedBox(width: 8),
          SelectorCustom<AppUser, int?>(
              builder: (value) {
                return GradeImageWidget(value ?? 1);
              },
              selector: (a) => a.rank)
          // Image.asset(AppImages.vipTestIcon)
        ].row(),
        SizedBox(height: 8),
        SelectorCustom<AppUser, String?>(
            builder: (value) {
              return CustomText("ID: $value",
                  fontWeight: w_500,
                  fontSize: 14.pt,
                  color: Color.fromARGB(255, 134, 141, 154));
            },
            selector: (a) => a.memberId)
      ]).expanded()
    ]);
  }
}

class _ImageCacheSizeWidget extends StatefulWidget {
  @override
  createState() => _ImageCacheSizeWidgetState();
}

class _ImageCacheSizeWidgetState extends State<_ImageCacheSizeWidget>
    with Toast {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _CellItem(
        image: AppImages.clean,
        title: "${AppInternational.of(context).clean}",
        subTitle: FutureBuilder<int>(
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return SizedBox();
              var e =
                  AppCacheManager.cache.renderSize(snapshot.data?.toDouble());
              return CustomText("${e.cacheSize}${e.unit}",
                  fontSize: 12.pt, fontWeight: w_400);
            },
            future: getCachedSizeBytes()),
        onTap: () async {
          show();
          await clearDiskCachedImages();
          clearMemoryImageCache();
          dismiss();
          setState(() {});
        });
  }
}

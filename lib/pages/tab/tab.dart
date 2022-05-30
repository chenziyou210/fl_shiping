import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/pages/live/live_new.dart';
import 'package:hjnzb/pages/my_mine/my_mine_view.dart';
import 'package:hjnzb/pages/wallet/wallet.dart';
import 'package:provider/provider.dart';

import '../../common/toast.dart';
import '../../config/app_colors.dart';
import '../../http/cache.dart';
import '../game/jump_game_view.dart';
import '../live_room/view/game_view/game_table/game_table_view.dart';
import '../recharge/recharge_manager_view.dart';
import 'tab_model.dart';

/*
*
* Tab界面
*
 */
class TabContainer extends StatefulWidget {
  @override
  createState() => _TabContainerState();
}

class _TabContainerState extends AppStateBase<TabContainer> with Toast {
  /// 偏移量
  final EdgeInsets padding = EdgeInsets.only(top: 4);
  var lastPopTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus.instance.addListener(_indexChange, name: homeHotGameMoreTaped);
    (model as TabModel).getSystemParam();
    bool? isguest = AppCacheManager.cache.getisGuest();
    if (isguest == true) {
      Future.delayed(Duration(seconds: 1), () {
        showLoginDialog(context);
      });
    }
  }

  void _indexChange(index) {
    (model as TabModel).model.updateIndex(index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventBus.instance.removeListener(_indexChange, name: homeHotGameMoreTaped);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: ChangeNotifierProvider.value(
            value: (model! as TabModel).model,
            child: Scaffold(
                body: Consumer<TabModelNotifier>(builder: (_, model, __) {
              return IndexedStack(index: model.index, children: [
                LiveListPageNew(),
                JumpGamePage(),
                RechargeManagerPage(),
                WalletPage(),
                MyMinePage()
              ]);
            }), bottomNavigationBar:
                    Consumer<TabModelNotifier>(builder: (_, model, __) {
              int index = model.index;
              Widget live, game, wallet, msg, mine;

              if (index == 0) {
                live = Image.asset(AppImages.homeSelected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              } else {
                live = Image.asset(AppImages.homeUnselected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              }

              if (index == 1) {
                game = Image.asset(AppImages.tab1Selected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              } else {
                game = Image.asset(AppImages.tab1Unselected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              }

              if (index == 2) {
                wallet = Image.asset(AppImages.tab2Selected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              } else {
                wallet = Image.asset(AppImages.tab2Unselected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              }

              if (index == 3) {
                msg = Image.asset(AppImages.msgSelected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              } else {
                msg = Image.asset(AppImages.msgUnselected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              }

              if (index == 4) {
                mine = Image.asset(AppImages.mineSelected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              } else {
                mine = Image.asset(AppImages.mineUnselected,
                    width: 26.pt, height: 26.pt, fit: BoxFit.fill);
              }

              return BottomAppBar(
                  color: AppMainColors.string2Color('#242424'),
                  child: Container(
                      height: 60.pt,
                      child: Stack(
                        children: [
                          Container(
                            height: 1.pt,
                            color: AppMainColors.separaLineColor10,
                          ),
                          Row(
                            children: [
                              BottomNavigationItem(
                                alignment: MainAxisAlignment.start,
                                padding: padding,
                                title: "${intl.home}",
                                txtStyle: TextStyle(
                                    fontSize: 12.pt,
                                    color: index == 0
                                        ? AppMainColors.mainColor
                                        : AppMainColors.whiteColor40),
                                icon: live,
                                onTap: () {
                                  model.updateIndex(0);
                                  customShowModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        // return GameViewPage(_anchorId!);
                                        // return GameK3Page("");
                                        return GameTablePage();
                                      },
                                      fixedOffsetHeight: 400.pt,
                                      isScrollControlled: false,
                                      barrierColor: Colors.transparent,
                                      backgroundColor: Colors.transparent);
                                },
                              ),
                              BottomNavigationItem(
                                alignment: MainAxisAlignment.start,
                                padding: padding,
                                title: "${intl.tab1}",
                                txtStyle: TextStyle(
                                    fontSize: 12.pt,
                                    color: index == 1
                                        ? AppMainColors.mainColor
                                        : AppMainColors.whiteColor40),
                                icon: game,
                                onTap: () {
                                  model.updateIndex(1);
                                },
                              ),
                              BottomNavigationItem(
                                alignment: MainAxisAlignment.start,
                                padding: padding,
                                title: "${intl.tab2}",
                                txtStyle: TextStyle(
                                    fontSize: 12.pt,
                                    color: index == 2
                                        ? AppMainColors.mainColor
                                        : AppMainColors.whiteColor40),
                                icon: wallet,
                                onTap: () {
                                  model.updateIndex(2);
                                },
                              ),
                              BottomNavigationItem(
                                alignment: MainAxisAlignment.start,
                                padding: padding,
                                title: "${intl.userMessage}",
                                txtStyle: TextStyle(
                                    fontSize: 12.pt,
                                    color: index == 3
                                        ? AppMainColors.mainColor
                                        : AppMainColors.whiteColor40),
                                icon: msg,
                                onTap: () {
                                  model.updateIndex(3);
                                },
                              ),
                              BottomNavigationItem(
                                alignment: MainAxisAlignment.start,
                                padding: padding,
                                txtStyle: TextStyle(
                                    fontSize: 12.pt,
                                    color: index == 4
                                        ? AppMainColors.mainColor
                                        : AppMainColors.whiteColor40),
                                title: "${intl.mine}",
                                icon: mine,
                                onTap: () {
                                  model.updateIndex(4);
                                },
                              )
                            ],
                          )
                        ],
                      )));
            }))),
        onWillPop: () {
          // if (Platform.isAndroid){
          //   AndroidBackDesktop.backToDesktop();
          // }
          if (DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            showToast("${intl.exitApp}");
            return Future.value(false);
          } else {
            // 退出app
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return Future.value(true);
          }

          return Future.value(false);
        });
  }

  @override
  TabModel initializeModel() {
    // TODO: implement initializeModel
    return TabModel();
  }

  Future<dynamic> showLoginDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text('${intl.selectPaymentChannel}'),
                content: Text("${intl.selectDetailsLogin}"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("${intl.guestLogin}"),
                    onPressed: () {
                      // guestLogin();
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                        AppCacheManager.cache.setisGuest(false);
                      });
                    },
                  ),
                  new FlatButton(
                    child: new Text("${intl.mobileLoginRegistration}"),
                    onPressed: () {
                      pushViewControllerWithName(AppRoutes.logInNew);
                    },
                  ),
                ],
              ),
            ));
  }
}

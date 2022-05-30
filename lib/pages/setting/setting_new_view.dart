import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';

import 'setting_new_logic.dart';

class SettingNewPage extends StatefulWidget {

  @override
  createState()=> _SettingNewPageState();
}

class _SettingNewPageState extends State<SettingNewPage> {

  final SettingNewLogic _controller = SettingNewLogic();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<SettingNewLogic>();
  }

  @override
  Widget build(BuildContext context) {
    var intl = AppInternational.of(context);
    final state = _controller.state;
    return Scaffold(
      appBar: DefaultAppBar(
        title: CustomText(intl.setting,
          fontSize: 16,
          color: Color.fromARGB(255, 34, 40, 49),
          fontWeight: w_500
        )
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16) + EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(4) + EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx((){
              return _ItemRow(
                title: intl.nobleStealthSwitch,
                isOpen: state.nobleOffstage.value,
                onValueChange: (value)  {
                  _controller.changeNoble(value);
                }
              );
            }),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Obx((){
              return _ItemRow(
                title: intl.enterIncognito,
                isOpen: state.enterOffstage.value,
                onValueChange: (value)  {
                  _controller.changeEnterOffstage(value);
                }
              );
            }),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Obx((){
              return _ItemRow(
                title: intl.giftEffectSwitch,
                isOpen: state.giftEffect.value,
                onValueChange: (value)  {
                  _controller.changeGiftEffect(value);
                }
              );
            }),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Obx((){
              return _ItemRow(
                title: intl.carSpecialEffectSwitch,
                isOpen: state.carEffect.value,
                onValueChange: (value)  {
                  _controller.changeCarEffect(value);
                }
              );
            }),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Obx((){
              return _ItemRow(
                title: intl.soundSwitch,
                isOpen: state.soundEffect.value,
                onValueChange: (value)  {
                  _controller.changeSoundEffect(value);
                }
              );
            }),
            SizedBox(height: 8),
            CustomDivider(),
            SizedBox(height: 8),
            Obx((){
              return _ItemRow(
                title: intl.smallWindowSwitch,
                isOpen: state.smallWindow.value,
                onValueChange: (value)  {
                  _controller.changeSmallWindow(value);
                }
              );
            })
          ]
        ),
      )
    );
  }
}

class _ItemRow extends StatelessWidget {
  _ItemRow({required this.title, required this.isOpen, required this.onValueChange});
  final String title;
  final bool isOpen;
  final void Function(bool) onValueChange;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        CustomText("$title",
          fontSize: 14,
          fontWeight: w_400,
          color: Color.fromARGB(255, 50, 50, 50)
        ),
        Spacer(),
        CupertinoSwitchWidget(
          activeColor: Color.fromARGB(255, 222, 77, 89),
          onChanged: onValueChange,
          value: isOpen)
      ]
    );
  }
}
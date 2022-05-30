import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart';
import 'package:hjnzb/config/app_layout.dart';
import 'package:hjnzb/pages/my_mine/mine_edit_info/mine_edit_info_state.dart';
import '../../../app_images/app_images.dart';
import '../../../common/app_common_widget.dart';
import '../../../config/app_colors.dart';
import 'mine_edit_info_logic.dart';

class MineEditInfoPage extends StatelessWidget {
  final logic = Get.put(MineEditInfoLogic());
  final state = Get.find<MineEditInfoLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: Text('编辑资料', style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 18)),
      ),
      body: Obx(() {
        return ListView(
            children: [
              buildEditInfoItem('头像', state.editInfoModel().avatar, infoTypes.avatar, () => _editAvatar(context)),
              buildEditInfoItem('昵称', state.editInfoModel().nickname, infoTypes.nickname, () => null),
              buildEditInfoItem('账号', state.editInfoModel().account, infoTypes.account, () => null),
              buildEditInfoItem('性别', state.editInfoModel().sex == 0 ? '男' : '女', infoTypes.sex, () => _editSex(context)),
              buildEditInfoItem('生日', state.editInfoModel().birthday, infoTypes.birthday, () => _editBirthday(context)),
              buildEditInfoItem('情感', state.editInfoModel().feeling, infoTypes.feeling, () => _editFeeling(context)),
              buildEditInfoItem('家乡', state.editInfoModel().hometown, infoTypes.hometown, () => _editHometown(context)),
              buildEditInfoItem('职业', state.editInfoModel().profession, infoTypes.profession, () => _editProfession(context)),
              buildEditInfoItem('签名', state.editInfoModel().signature, infoTypes.signature, () => logic.editSignature(context)),
            ]
        );
      })
    );
  }

  /// item样式
  Widget buildEditInfoItem(String title, String subtitle, infoTypes type, Function() tapEvent) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: space24),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, space24, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100)).expanded(),
                  type == infoTypes.avatar ?  _buildAvatar() : Text(subtitle, style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100), textAlign: TextAlign.right),
                  type == infoTypes.account ? Container() : Image.asset(AppImages.com_arrow_right, width: 16, height: 16)
                ],
              ),
            ),
            Container(
              height: 1.pt,
              color: AppMainColors.separaLineColor4,
            )
          ],
        ),
      ),
      onTap: tapEvent,
    );
  }

  /// 头像
  Widget _buildAvatar() {
    return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
                image: NetworkImage(
                  state.editInfoModel().avatar
                )
            )
        )
    );
  }

  /// 编辑头像
  void _editAvatar(BuildContext context)  {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppMainColors.blackColor70,
        builder: (BuildContext context) {
          return Container(
            color: AppMainColors.string2Color('#2A4155'),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSelectItem('拍照', () => logic.selectAvatarWithCamera()),
                Container(height: 1, color: AppMainColors.whiteColor6),
                _buildSelectItem('从相册选择', () => logic.selectAvatarWithPhoto()),
                Container(height: 4, color: AppMainColors.whiteColor6),
                _buildSelectItem('取消', () => logic.dismissBottomSelector(context))
              ]
            )
          );
        }
    );
  }

  /// 底部选择item样式
  Widget _buildSelectItem(String title, Function() itemEvent) {
    return GestureDetector(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 16)),
      ),
      onTap: itemEvent,
    );
  }

  /// 编辑性别
  void _editSex(BuildContext context) {
    Pickers.showSinglePicker(
        context,
        data: state.sexList,
        selectData: state.editInfoModel().sex == 0 ? '男' : '女',
        pickerStyle: _getPickerStyle(),
        onConfirm: (sex,int index) {
          logic.updateSex(sex, index);
        }
    );
  }

  /// 编辑生日
  void _editBirthday(BuildContext context) {
    Pickers.showDatePicker(
      context,
      maxDate: PDuration.now(),
      minDate: PDuration(year: 1997, month: 1, day: 1),
      pickerStyle: _getPickerStyle(),
      onConfirm: (PDuration date) {
        logic.updateBirthday(date);
      }
    );
  }

  /// 编辑情感
  void _editFeeling(BuildContext context) {
    Pickers.showSinglePicker(
        context,
        data: state.feelings,
        selectData: '单身',
        pickerStyle: _getPickerStyle(),
        onConfirm: (feeling, index) {
          logic.updateFeeling(feeling);
        }
    );
  }

  /// 编辑家乡
  void _editHometown(BuildContext context) {
    Pickers.showAddressPicker(
      context,
      addAllItem: false,
      pickerStyle: _getPickerStyle(),
      onConfirm: (province, opacity, town) {
        logic.updateHometown(province, opacity);
      }
    );
  }

  /// 编辑职业
  void _editProfession(BuildContext context) {
    Pickers.showSinglePicker(
        context,
        data: state.professions,
        selectData: state.editInfoModel().profession,
        pickerStyle: _getPickerStyle(),
        onConfirm: (profession, index) {
          logic.updateProfession(profession);
        }
    );
  }

  /// 选择器公用样式
  PickerStyle _getPickerStyle() {
    return PickerStyle(
        title: Text('选择', textAlign: TextAlign.center, style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 16)),
        backgroundColor: AppMainColors.string2Color('#2A4155'),
        textColor: AppMainColors.whiteColor100,
        textSize: 16,
        cancelButton: SizedBox(width: 96),
        commitButton: Container(
          child: Text('确定', textAlign: TextAlign.right, style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 16)),
          padding: EdgeInsets.only(right: pageSpace),
          width: 80,
        ),
        pickerHeight: 170,
        headDecoration: BoxDecoration(
          color: AppMainColors.string2Color('#2A4155'),
        ),
        itemOverlay: Container()
    );
  }
}


/// 编辑资料页面
class EditSignaturePage extends StatelessWidget {
   EditSignaturePage({dynamic arguments}) : this.state = arguments["state"], this.logic = arguments["logic"];

   final MineEditInfoState state;
   final MineEditInfoLogic logic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: Text('设置签名', style: TextStyle(color: AppMainColors.whiteColor100, fontSize: 18))
      ),
      body: Container(
        height: 88,
        color: AppMainColors.whiteColor6,
        child: Column(
          children: [
            CustomTextField(
              controller: state.signatureTEC,
              textAlign: TextAlign.start,
              hintText: '留下你的签名吧~',
              hintTextStyle: TextStyle(fontSize: 16, color: AppMainColors.whiteColor20),
              style: TextStyle(fontSize: 16, color: AppMainColors.whiteColor100),
              maxLength: state.signMaxCount,
              onEditComplete: () {
                print('调用了=======');
              },
              onChange: (text) {
                logic.updateSignature();
              },
            ),
          ]
        )
      ),
    );
  }
}


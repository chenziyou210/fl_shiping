import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/toast.dart';
import '../../../http/http_channel.dart';
import '../../../manager/app_manager.dart';
import '../../../page_config/page_config.dart';
import 'mine_edit_info_state.dart';

class MineEditInfoLogic extends GetxController with Toast {
  final MineEditInfoState state = MineEditInfoState();

  void dismissBottomSelector(BuildContext context) {
    Navigator.pop(context);
  }

  void updateFeeling(String feeling) {
    state.editInfoModel.value = EditInfoModel(feeling: feeling);
  }

  void updateSex(String sexText, int index) {
    state.editInfoModel.value = EditInfoModel(sex: index);
  }

  void updateBirthday(PDuration date) {
    state.editInfoModel.value =
        EditInfoModel(birthday: '${date.year}-${date.month}-${date.day}');
  }

  void updateHometown(String province, String opacity) {
    state.editInfoModel.value = EditInfoModel(hometown: '$province-$opacity');
  }

  void updateProfession(String profession) {
    state.editInfoModel.value = EditInfoModel(profession: profession);
  }

  void editSignature(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.editSignaturePage,
        arguments: {'state': state, 'logic': this}).then((value) {

    });
  }

  void updateSignature() {
    state.editInfoModel.value = EditInfoModel(signature: state.signatureTEC.text);
  }

  void selectAvatarWithCamera() async {
    _getPermission();
    final value = await ImagePicker().pickImage(source: ImageSource.camera);
    if (value != null) {
      _updateAvatar(value.path);
    }
  }

  void selectAvatarWithPhoto() async {
    _getPermission();
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      _updateAvatar(value.path);
    }
  }

  void _getPermission() async {
    final result = await Permission.photos.request();
    if (!result.isGranted) {
      return;
    }
  }

  void _updateAvatar(String filePath){
    state.editInfoModel.value = EditInfoModel(avatar: filePath);
    // HttpChannel.channel.uploadImage(filePath).then((value) =>
    //     value.finalize(
    //         wrapper: WrapperModel(),
    //         failure: (e)=> showToast(e),
    //         success: (url) {
    //           print(url);
    //           state.editInfoModel.value = EditInfoModel(avatar: url);
    //         }
    //     ));
  }

  void saveUserInfo() {
    final model = state.editInfoModel.value;
    show();
    HttpChannel.channel.editUserInfo(
        name: model.nickname,
        profession: model.profession,
        emotion: model.feeling,
        birthday: model.birthday,
        sex: model.sex,
        signature: model.signature,
        city: model.hometown,
        avatar: model.avatar
    ).then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e) => showToast(e),
        success: (_){
          dismiss();
          var value = {
            "birthday": model.birthday,
            "city": model.hometown,
            "emotion": model.feeling,
            "header": model.avatar,
            "name": model.nickname,
            "profession": model.profession,
            "sex": model.sex,
            "signature": model.signature
          };
          AppManager.getInstance<AppUser>().userUpdate(value);
        }));
  }

}
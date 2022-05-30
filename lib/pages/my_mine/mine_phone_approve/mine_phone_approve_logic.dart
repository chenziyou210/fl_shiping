import 'dart:async';
import 'package:get/get.dart';
import '../../../common/toast.dart';
import '../../../http/http_channel.dart';
import 'mine_phone_approve_state.dart';

class MinePhoneApproveLogic extends GetxController with Toast {
  final MinePhoneApproveState state = MinePhoneApproveState();
  late Timer _timer;

  void codeEvent() {
    final phoneText = state.phoneTEC.text;
    if (phoneText.isEmpty) {
      showToast("请输入手机号");
      return ;
    }
    int count = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        count = count - 1;
        state.codeText.value = '$count S';
        state.codeStatus.value = false;
        if (count <= 0) {
          state.codeText.value = '点击发送';
          state.codeStatus.value = true;
          timer.cancel();
        }
        update();
    });
    smsSend();
  }

  void approveEvent() {
    final phoneText = state.phoneTEC.text;
    final codeText = state.codeTEC.text;
    if (phoneText.isEmpty) {
      showToast("请输入手机号");
      return ;
    }
    if (codeText.isEmpty) {
      showToast("请输入验证码");
      return ;
    }
    bindPhone();
  }

  void smsSend() {
    show();
    HttpChannel.channel.smsSend(phone: state.phoneTEC.text).then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e)=> showToast(e),
            success: (data) {
              state.codeId = data['codeId'];
              update();
              dismiss();
            }
        ));
  }

  void bindPhone() {
    show();
    HttpChannel.channel.bindPhone(
        phone: state.phoneTEC.text,
        verifyCode: state.codeTEC.text,
        codeId: state.codeId).then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e)=> showToast(e),
            success: (data) {
              showToast('认证成功');
              dismiss();
            }
        ));
  }

}

import 'package:get/get.dart';
import '../../../common/toast.dart';
import '../../../generated/car_list_entity.dart';
import '../../../generated/package_gift_entity.dart';
import '../../../http/http_channel.dart';
import 'mine_backpack_state.dart';

class MineBackpackLogic extends GetxController with Toast {
  final MineBackpackState state = MineBackpackState();
/// 座驾
  void loadCarList(){
    show();
    HttpChannel.channel.carList().then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e)=> showToast(e),
            success: (data) {
              List lst = data ?? [];
              List<CarListEntity> d = lst.map((e) => CarListEntity.fromJson(e)).toList();
              state.carList.value = d;
              dismiss();
            }
        ));
  }

  void use(int id){
    show();
    HttpChannel.channel.useCar(id: id).then((value) {
      value.finalize(wrapper: WrapperModel(),
          failure: (e)=> showToast(e),
          success: (_) {
            dismiss();
            loadCarList();
          }
      );
    });
  }

  void play(int index) {
    String gifUrl = state.carList[index].carGifUrl;
    state.gifUrl.value = gifUrl;
  }

  void playComplete(){
    state.gifUrl.value = "";
  }

  String getCarBuyText(int index) {
    final model = state.carList[index];
    if (model.carBuyState == 0)
      return '购买';
    if (model.carBuyState == 1)
      return '使用';
    if (model.carBuyState == 2)
      return '使用中';
    return '';
  }

  void updateAnimationStatus(bool status) {
    state.isAnimation = status;
  }

/// 背包
  void loadPackageList() {
    HttpChannel.channel.userPackageList().then((value) =>
        value.finalize(
            wrapper: WrapperModel(),
            failure: (e)=> showToast(e),
            success: (data) {
              List lst = data ?? [];
              List<PackageGiftEntity> d = lst.map((e) => PackageGiftEntity.fromJson(e)).toList();
              state.bagList.value = d;
              print(data);
            }
        ));
  }

}

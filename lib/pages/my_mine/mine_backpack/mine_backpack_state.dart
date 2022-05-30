import 'package:get/get.dart';
import '../../../generated/car_list_entity.dart';
import '../../../generated/package_gift_entity.dart';

class MineBackpackState {
  final List<String> titles = ["座驾", "背包"];
  RxList<CarListEntity> carList = RxList();
  RxList<PackageGiftEntity> bagList = RxList();
  Rx<String> gifUrl = "".obs;
  bool isAnimation = true;

  MineBackpackState() {
    ///Initialize variables
  }

}

import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/points_redemption_entity.dart';
import 'package:hjnzb/http/http_channel.dart';

class PointsRedemptionRecordLogic extends GetxController with Toast, PagingMixin {
  final PointsRedemptionRecordState state = PointsRedemptionRecordState();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    show();
    await dataRefresh();
    dismiss();
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return _getData(page, (data){
      state._loadData(data);
      page ++;
    });
  }

  @override
  Future dataRefresh() {
    // TODO: implement dataRefresh
    page = 1;
    return _getData(page, (data) {
      state._setData(data);
      page ++;
    });
  }

  Future _getData(int page, void Function(List<PointsRedemptionEntity>) success){
    return HttpChannel.channel.exchangeRecord(page: page)
      .then((value) => value.finalize(
        wrapper: WrapperModel(),
      failure: (e)=> showToast(e),
      success: (data) {
        Map dic = data ?? {};
        List lst = dic["data"] ?? [];
        success(lst.map((e) => PointsRedemptionEntity.fromJson(e)).toList());
      }
    ));
  }

  @override
  // TODO: implement data
  List get data => state._data;
}


class PointsRedemptionRecordState {
  RxList<PointsRedemptionEntity> _data = <PointsRedemptionEntity>[].obs;
  RxList<PointsRedemptionEntity> get data => _data;

  void _setData(List<PointsRedemptionEntity> value){
    _data.value = value;
  }

  void _loadData(List<PointsRedemptionEntity> value){
    _data.value += value;
  }
}
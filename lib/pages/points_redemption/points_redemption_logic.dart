import 'package:get/get.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/generated/exchange_gift_list_entity.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';

class PointsRedemptionLogic extends GetxController with PagingMixin, Toast {
  final PointsRedemptionState state = PointsRedemptionState();

  @override
  // TODO: implement data
  List get data => state._data;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    show();
    await Future.wait([
      HttpChannel.channel.userRemainPoints().then((value) => value.finalize(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          Map dic = data ?? {};
          state._setRemainPoint(double.tryParse((dic["remainRewardPoint"]
            ?? 0).toString()) ?? 0);
        }
      )),
      dataRefresh()
    ]);
    dismiss();
  }

  @override
  Future loadMore() {
    return _getData(page, (data) {
      state._moreData(data);
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


  Future _getData(int page, void Function(List<ExchangeGiftListEntity>) success){
    return HttpChannel.channel.exchangeGiftList(page: page).then((value) {
      value.finalize(
        wrapper: WrapperModel(),
        failure: (e)=> showToast(e),
        success: (data) {
          List lst = data["data"] ?? [];
          success(lst.map((e) => ExchangeGiftListEntity.fromJson(e)).toList());
        }
      );
    });
  }

  /// 兑换礼物
  Future exchangeGift(int index){
    var model = state.data[index];
    show();
    return HttpChannel.channel.exchangeGift(count: 1,
      giftId: model.id!).then((value) {
        return value.finalize(wrapper: WrapperModel(),
          failure: (e)=> showToast(e),
          success: (data) {
            Map dic = data;
            state._setRemainPoint(double.tryParse("${dic["remainRewardPoint"]}") ?? 0);
            showToast(AppInternational.current.exchange + AppInternational.current.success);
          }
        );
    });
  }
}

class PointsRedemptionState{
  RxDouble _remainPoint = 0.0.obs;
  RxDouble get remainPoint => _remainPoint;

  RxList<ExchangeGiftListEntity> _data = <ExchangeGiftListEntity>[].obs;
  RxList<ExchangeGiftListEntity> get data => _data;

  void _setData(List<ExchangeGiftListEntity> value){
    _data.value = value;
  }

  void _moreData(List<ExchangeGiftListEntity> value){
    _data.value += value;
  }

  void _setRemainPoint(double point){
    _remainPoint.value = point;
  }
}
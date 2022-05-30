import 'package:get/get.dart';


class SettingNewLogic extends GetxController {
  final SettingNewState state = SettingNewState();

  void changeNoble(bool value){
    state._changeNoble(value);
  }

  void changeSmallWindow(bool value){
    state._changeSmallWindow(value);
  }

  void changeSoundEffect(bool value){
    state._changeSoundEffect(value);
  }

  void changeCarEffect(bool value){
    state._changeCarEffect(value);
  }

  void changeGiftEffect(bool value){
    state._changeGiftEffect(value);
  }

  void changeEnterOffstage(bool value){
    state._changeEnterOffstage(value);
  }
}

class SettingNewState {
  RxBool _nobleOffstage = true.obs;
  RxBool get nobleOffstage => _nobleOffstage;

  RxBool _enterOffstage = false.obs;
  RxBool get enterOffstage => _enterOffstage;

  RxBool _giftEffect = true.obs;
  RxBool get giftEffect => _giftEffect;

  RxBool _carEffect = true.obs;
  RxBool get carEffect => _carEffect;

  RxBool _soundEffect = true.obs;
  RxBool get soundEffect => _soundEffect;

  RxBool _smallWindow = true.obs;
  RxBool get smallWindow => _smallWindow;

  void _changeNoble(bool value){
    _nobleOffstage.value = value;
  }

  void _changeSmallWindow(bool value){
    _smallWindow.value = value;
  }

  void _changeSoundEffect(bool value){
    _soundEffect.value = value;
  }

  void _changeCarEffect(bool value){
    _carEffect.value = value;
  }

  void _changeGiftEffect(bool value){
    _giftEffect.value = value;
  }

  void _changeEnterOffstage(bool value){
    _enterOffstage.value = value;
  }
}


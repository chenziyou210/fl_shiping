


import 'package:get/get.dart';
import 'package:hjnzb/http/http_channel.dart';

class CustomServiceListLogic extends GetxController {
  final _CustomServiceListLogic state = _CustomServiceListLogic();

  Future loadList(){
    return HttpChannel.channel.customServicesList()
      ..then((value) {

    });
  }
}

class _CustomServiceListLogic {

}
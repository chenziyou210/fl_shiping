/*
 *  Copyright (C), 2015-2021
 *  FileName: type
 *  Author: Tonight丶相拥
 *  Date: 2021/10/18
 *  Description: 
 **/

import 'package:hjnzb/page_config/page_config.dart';

enum InitializePage{
  logIn,
  tab,
  advertising
}

extension InitializeType on InitializePage {
  String? get rawValue {
    String? value;
    switch(this){
      case InitializePage.logIn:
        value = AppRoutes.logInNew;
        break;
      case InitializePage.tab:
        value = AppRoutes.tab;
        break;
      case InitializePage.advertising:
        // value = AppRoutes.advertising;
        break;
    }
    // value = AppRoutes.changeLogInPassword;
    return value;
  }
}
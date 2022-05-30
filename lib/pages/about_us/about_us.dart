/*
 *  Copyright (C), 2015-2021
 *  FileName: about_us
 *  Author: Tonight丶相拥
 *  Date: 2021/12/15
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';

class AboutUSPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Scaffold(
      appBar: DefaultAppBar(
        title: CustomText("${intl.aboutUS}",
          fontWeight: w_500,
          color: Color.fromARGB(255, 34, 40, 49),
          fontSize: 16.pt
        )
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                SizedBox(height: 33.pt),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                SizedBox(height: 16),
                CustomText("HJNLIVING-1.0.0",
                  fontSize: 16.pt,
                  fontWeight: w_500,
                  color: Color.fromARGB(255, 34, 40, 49)
                ),
                SizedBox(height: 16),
                CustomText("${intl.updateContent}",
                  fontSize: 12.pt,
                  fontWeight: w_500,
                  color: Color.fromARGB(255, 67, 75, 87)
                ),
                SizedBox(height: 117.pt)
              ]
            ),
          )
        ]
      )
    );
  }
}
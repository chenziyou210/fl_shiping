/*
 *  Copyright (C), 2015-2021
 *  FileName: feedback
 *  Author: Tonight丶相拥
 *  Date: 2021/12/15
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/toast.dart';
import 'package:hjnzb/http/http_channel.dart';

class AnchorFeedbackPage extends StatefulWidget {
  @override
  createState()=> _AnchorFeedbackPageState();
}

class _AnchorFeedbackPageState extends AppStateBase<AnchorFeedbackPage> with Toast {

  final TextEditingController _controller = TextEditingController();

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.helpAndFeedback}",
      fontSize: 16.pt,
      fontWeight: w_500,
      color: Color.fromARGB(255, 34, 40, 49)
    )
  );

  @override
  // TODO: implement body
  Widget get body => Column(
    children: [
      SizedBox(height: 16),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            TextFormField(
              maxLines: 9,
              controller: _controller,
              style: TextStyle(
                  fontSize: 14.pt,
                  fontWeight: w_400,
                  color: Colors.black
              ),
              decoration: InputDecoration.collapsed(
                  hintText: "${intl.pleaseEnter}",
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 196, 196, 196),
                      fontSize: 14.pt,
                      fontWeight: w_400
                  )
              ),
            ).container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 246, 246),
                    borderRadius: BorderRadius.circular(4)
                )
            ),
            SizedBox(height: 16),
            Container(
              height: 46.pt,
              width: 300.pt,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23.pt),
                gradient: LinearGradient(
                  colors: AppColors.buttonGradientColors
                )
              ),
              alignment: Alignment.center,
              child: CustomText("${intl.submitFeedback}",
                fontSize: 16.pt,
                fontWeight: w_500,
                color: Colors.white
              ),
            ).cupertinoButton(
              miniSize: 46.pt,
              onTap: (){
                var text = _controller.text;
                if (text.isEmpty) {
                  showToast("${intl.pleaseEnter}");
                  return;
                }
                show();
                HttpChannel.channel.anchorFeedback(text).then((value) {
                  return value.finalize(
                    wrapper: WrapperModel(),
                    failure: (e)=> showToast(e),
                    success: (_) {
                      showToast("${intl.submitSuccess}");
                      _controller.clear();
                      popViewController();
                      // dismiss();
                    }
                  );
                });
              }
            )
          ]
        )
      )
    ]
  );
}
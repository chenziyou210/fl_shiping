/*
 *  Copyright (C), 2015-2021
 *  FileName: invitation_code
 *  Author: Tonight丶相拥
 *  Date: 2021/12/31
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/toast.dart';

class InvitationCodePage extends StatefulWidget {
  @override
  createState()=> _InvitationCodePageState();
}

class _InvitationCodePageState extends AppStateBase<InvitationCodePage> with Toast {

  final TextEditingController _controller = TextEditingController();

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: CustomText("${intl.invitationCode}",
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
      Row(
        children: [
          Container(
            height: 58.pt,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CustomTextField(
              controller: _controller,
              hintTextStyle: TextStyle(
                fontSize: 16.pt,
                fontWeight: w_500,
                color: Color.fromARGB(255, 187, 187, 200)
              ),
              style: TextStyle(
                fontSize: 16.pt,
                fontWeight: w_500,
                color: Colors.black
              ),
              hintText: "${intl.enterInvitationCodeForReward}",
            ),
          ).expanded(),
          SizedBox(width: 8),
          Container(
            height: 58.pt,
            width: 74.pt,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 72, 79, 98),
                Color.fromARGB(255, 41, 39, 52)
              ]),
              borderRadius: BorderRadius.circular(10)
            ),
            alignment: Alignment.center,
            child: CustomText("${intl.submit}",
              fontSize: 16.pt,
              fontWeight: w_500,
              color: Colors.white
            )
          ).cupertinoButton(onTap: (){
            
          })
        ]
      ).offstage,
      SizedBox(height: 16),
      Stack(
        children: [
          Image.asset(AppImages.invitationCode, width: 343.pt,
              height: 422.pt,
              fit: BoxFit.fill),
          Column(
            children: [
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      CustomText("OO.Live", fontSize: 22.pt,
                        fontWeight: w_600,
                        color: Colors.white
                      ),
                      CustomText("${intl.exclusiveDownloadLine}",
                        fontSize: 22.pt, fontWeight: w_600,
                        color: Colors.white)
                    ]
                  ),
                  Spacer(),
                  Image.asset(AppImages.invitationCodeLogo).padding(padding: EdgeInsets.only(right: 16))
                ]
              ).padding(padding: EdgeInsets.only(left: 32, right: 8)),
              SizedBox(height: 79.pt),
              Row(
                children: [
                  CustomDivider(
                    color: Color.fromARGB(255, 123, 127, 139)
                  ).expanded(),
                  SizedBox(width: 16),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 123, 127, 139),
                      borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                  SizedBox(width: 16),
                  CustomText("${intl.your}${intl.exclusiveDownloadLine}",
                    fontSize: 12.pt, fontWeight: w_500,
                    color: Color.fromARGB(255, 123, 127, 139)
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 123, 127, 139),
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                  SizedBox(width: 16),
                  CustomDivider(color: Color.fromARGB(255, 123, 127, 139)).expanded()
                ]
              ).padding(padding: EdgeInsets.symmetric(horizontal: 32)),
              SizedBox(height: 16),
              CustomText("http://crm.oolive.live",
                fontSize: 30.pt, fontWeight: w_600,
                color: Colors.white
              ),
              SizedBox(height: 32),
              Container(
                width: 66.pt,
                height: 31.pt,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 44, 46, 61),
                  borderRadius: BorderRadius.circular(4)
                ),
                alignment: Alignment.center,
                child: CustomText("${intl.copy}",
                  fontSize: 12.pt,
                  fontWeight: w_500,
                  color: Colors.white
                )
              ).cupertinoButton(onTap: (){
                Clipboard.setData(ClipboardData(text: "http://crm.oolive.live"));
                showToast("${intl.copySuccess}");
              }),
              SizedBox(height: 32),
              CustomText("${intl.copyExclusiveDownloadLine}",
                fontSize: 12.pt,
                textAlign: TextAlign.center,
                fontWeight: w_500,
                color: Color.fromARGB(255, 123, 127, 139)
              ).padding(padding: EdgeInsets.symmetric(horizontal: 32))
            ]
          ).padding(padding: EdgeInsets.symmetric(
              vertical: 8))
        ],
      )
    ]
  ).padding(padding: EdgeInsets.symmetric(horizontal: 16));
}
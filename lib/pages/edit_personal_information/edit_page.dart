/*
 *  Copyright (C), 2015-2021
 *  FileName: edit_page
 *  Author: Tonight丶相拥
 *  Date: 2021/8/3
 *  Description: 
 **/


import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/i18n/i18n.dart';

class EditPage extends StatelessWidget {
  EditPage({dynamic arguments}): this.title = arguments["title"] ?? "",
        this.hintText = arguments["hintText"],
        this.isTextForm = arguments["sign"] ?? false,
        this.maxLength = arguments["maxLength"],
        this._controller = TextEditingController(text: arguments["text"]);
  // 输入控制
  final TextEditingController _controller;
  final String title;
  final String hintText;
  final bool isTextForm;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text("$title", style: AppStyles.f17w400c0_0_0),
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.of(context).pop(_controller.text);
              },
              child: Padding(padding: EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(AppInternational.of(context).done, style: AppStyles.f14w400c0_0_0)
                ))
          )
        ]
      ),
      backgroundColor: AppColors.c255_255_255,
      body: Column(
        children: [
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.c125_125_125,
                width: 1
              ),
              borderRadius: BorderRadius.circular(4)
            ),
            child: this.isTextForm ? TextFormField(
              controller: _controller,
              maxLength: 100,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.hintText,
                hintStyle: AppStyles.f14w400c125_125_125
              ),
              style: AppStyles.f14w400c0_0_0,
              maxLines: 3
            ) :
            CustomTextField(
                controller: _controller,
                maxLength: maxLength,
                hintTextStyle: AppStyles.f14w400c125_125_125,
                hintText: this.hintText,
                style: AppStyles.f14w400c0_0_0
            )
          )
        ]
      )
    );
  }
}
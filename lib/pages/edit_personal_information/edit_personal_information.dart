/*
 *  Copyright (C), 2015-2021
 *  FileName: edit_personal_information
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:hjnzb/page_config/page_config.dart';
import 'package:hjnzb/util_tool/util_tool.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/base/app_base.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'edit_user_model.dart';

class EditPersonalInformation extends StatefulWidget {
  EditPersonalInformation({dynamic arguments}): this.json = arguments ?? {};
  @override
  createState() => _EditPersonalInformationState();
  final Map<String, dynamic> json;
}

class _EditPersonalInformationState extends AppStateBase<EditPersonalInformation> {

  final EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 15);

  @override
  // TODO: implement model
  EditUserModel get model => super.model as EditUserModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // TODO: implement appBar
  PreferredSizeWidget? get appBar => DefaultAppBar(
    title: Text(intl.edit, style: AppStyles.f17w400c0_0_0),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 8),
        child: Center(
          child: GestureDetector(
            onTap: (){
              model.save(onSuccess: (data){
                popViewController(data);
              });
            },
            child: Text(intl.save, style: AppStyles.f14w400c0_0_0)
          ),
        )
      )
    ]
  );

  @override
  // TODO: implement bodyColor
  Color? get bodyColor => AppColors.c243_243_243;

  @override
  // TODO: implement scaffold
  Widget get scaffold => ChangeNotifierProvider.value(
    value: model.user,
    child: super.scaffold
  );

  @override
  // TODO: implement body
  Widget get body => SingleChildScrollView(
    child: Column(
        children: [
          SizedBox(height: 1),
          Container(
            color: Colors.white,
            padding: _padding,
            child: Column(
              children: [
                _RowItem(
                   children: [
                     Text(intl.avatar, style: AppStyles.f14w400c0_0_0),
                     Spacer(),
                     InkWell(
                       onTap: () async{
                          var result = await Permission.photos.request();
                          if (!result.isGranted) {
                            return;
                          }
                          var value = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (value != null)
                            model.updateAvatar(value.path);
                       },
                       child: Selector(builder: (_, String? avatar, __) {
                         if (avatar != null) {
                           Widget child;
                           avatar = avatar.replaceAll(" ", "");
                           if (avatar.startsWith("http")) {
                             child = ExtendedImage.network(avatar, fit: BoxFit.cover,
                                 width: 36,
                                 enableLoadState: false,
                                 height: 36);
                           }else if(avatar.isNotEmpty){
                             child = Image.file(File(avatar), fit: BoxFit.cover,
                                 width: 36,
                                 height: 36);
                           }else{
                             child = SizedBox(width: 36, height: 36);
                           }
                           return ClipRRect(
                             borderRadius: BorderRadius.circular(18),
                             child: child
                           );
                         }
                         return SizedBox(
                             width: 20,
                             height: 20
                         );
                       }, selector: (_, UserModel u) => u.avatar)
                     )
                   ]
                ),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(
                   children: [
                     Text(intl.name, style: AppStyles.f14w400c0_0_0),
                     ExpandInkWellRow(children: [
                       Selector(builder: (_, String? name, __) {
                         return NullWidget<String>(name, builder: (_, n) {
                           return Text("$n", style: AppStyles.f14w400c0_0_0);
                         });
                       }, selector: (_, UserModel u) => u.name),
                       SizedBox(width: 15),
                       Image.asset(AppImages.forwardGray)
                     ], onTap: (){
                       pushViewControllerWithName(AppRoutes.editPage, arguments: {
                         "title": intl.name,
                         "hintText": intl.pleaseEnter,
                         "maxLength": 8,
                         "sign": false,
                         "text": model.user.name
                       }).then((value) {
                         if (value != null)
                           model.updateName(value);
                       });
                     }, constraints: constraints)
                   ]
                ),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(
                  children: [
                    Text(intl.account, style: AppStyles.f14w400c0_0_0),
                    Spacer(),
                    Text("${model.user.account}", style: AppStyles.f14w400c125_125_125)
                  ]
                ),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.gender, style: AppStyles.f14w400c0_0_0),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, int?>(builder: (gender) {
                      return NullWidget<int>(gender,
                          builder: (_, gender) {
                            var value = [intl.female, intl.male, intl.unknown][gender];
                            return Text("$value",
                                style: AppStyles.f14w400c125_125_125);
                          });
                    }, selector: (u) => u.gender),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    Pickers.showSinglePicker(context,
                      data: [intl.female, intl.male, intl.unknown],
                      onConfirm: (value, index) {
                        model.updateGender(index);
                      },
                      pickerStyle: PickerStyle(
                          commitButton: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 22, right: 12),
                            child: Text('${intl.confirm1}',
                                style: TextStyle(
                                    color: Theme.of(context).unselectedWidgetColor,
                                    fontSize: 16.0)),
                          ),
                          cancelButton: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 22, right: 12),
                            child: Text('${intl.cancel}',
                                style: TextStyle(
                                    color: Theme.of(context).unselectedWidgetColor,
                                    fontSize: 16.0)),
                          )
                      ),
                    );
                  }, constraints: constraints)
                ]),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.birthday, style: AppStyles.f14w400c0_0_0),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, String?>(builder: (value) {
                      return NullWidget(value, builder: (_, birthday) {
                        return Text("$birthday",
                            style: AppStyles.f14w400c125_125_125);
                      });
                    }, selector: (u) => u.birthday),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    PDuration? d;
                    if (model.user.birthday != null && model.user.birthday!.isNotEmpty) {
                      List<String> l = model.user.birthday!.split("-");
                      DateTime t = DateTime(int.parse(l[0]),
                          int.parse(l[1]), int.parse(l[2]));
                      d = PDuration.parse(t);
                    }
                    Pickers.showDatePicker(context, onConfirm: (duration){
                      model.updateBirthday("${duration.year}-${duration.month}-${duration.day}");
                    },
                        pickerStyle: PickerStyle(
                            commitButton: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 22, right: 12),
                              child: Text('${intl.confirm1}',
                                  style: TextStyle(
                                      color: Theme.of(context).unselectedWidgetColor,
                                      fontSize: 16.0)),
                            ),
                            cancelButton: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 22, right: 12),
                              child: Text('${intl.cancel}',
                                  style: TextStyle(
                                      color: Theme.of(context).unselectedWidgetColor,
                                      fontSize: 16.0)),
                            )
                        ),
                        suffix: Suffix(
                      years: intl.year,
                      month: intl.month,
                      days: intl.day
                    ), selectDate: d);
                  }, constraints: constraints)
                ]),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.constellation, style: AppStyles.f14w400c0_0_0),
                  Spacer(),
                  Selector(builder: (_, birthday, __) {
                    String constellation = "";
                    if(model.user.birthdayTime != null) {
                      constellation = getConstellation(model.user.birthdayTime!, intl);
                    }
                    return Text("$constellation", style: AppStyles.f14w400c125_125_125);
                  }, selector: (_, UserModel u) => u.birthday)
                ])
              ]
            )
          ),
          SizedBox(height: 10),
          Container(
            padding: _padding,
            color: Colors.white,
            child: Column(
              children: [
                _RowItem(children: [
                  Text(intl.homeTown, style: AppStyles.f14w400c0_0_0),
                  SizedBox(width: 8),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, String?>(builder: (hometown) {
                      return NullWidget<String>(hometown, builder: (_, value) {
                        return Wrap(
                          children: [
                            Text(value, style: AppStyles.f14w400c125_125_125)
                          ]
                        ).expanded();
                      });
                    }, selector: (u) => u.hometown),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    pushViewControllerWithName(AppRoutes.editPage, arguments: {
                      "title": intl.homeTown,
                      "hintText": intl.pleaseEnter,
                      "sign": false,
                      "maxLength": 20,
                      "text": model.user.hometown
                    }).then((value) {
                      if (value != null)
                        model.updateHomeTown(value);
                    });
                  }, constraints: constraints)
                ]),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.profession, style: AppStyles.f14w400c0_0_0),
                  SizedBox(width: 8),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, String?>(builder: (profession) {
                      return NullWidget<String>(profession, builder: (_, value) {
                        return Wrap(
                          children: [
                            Text(value, style: AppStyles.f14w400c125_125_125)
                          ]
                        ).expanded();
                      });
                    }, selector: (u) => u.profession),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    pushViewControllerWithName(AppRoutes.editPage, arguments: {
                      "title": intl.profession,
                      "hintText": intl.pleaseEnter,
                      "sign": false,
                      "maxLength": 10,
                      "text": model.user.profession
                    }).then((value) {
                      if (value != null)
                        model.updateProfession(value);
                    });
                  }, constraints: constraints)
                ]),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.feeling, style: AppStyles.f14w400c0_0_0),
                  SizedBox(width: 8),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, String?>(builder: (feeling) {
                      return NullWidget<String>(feeling, builder: (_, value) {
                        return Wrap(
                          children: [
                            Text(value, style: AppStyles.f14w400c125_125_125)
                          ]
                        ).expanded();
                      });
                    }, selector: (u) => u.feeling),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    pushViewControllerWithName(AppRoutes.editPage, arguments: {
                      "title": intl.feeling,
                      "hintText": intl.pleaseEnter,
                      "maxLength": 20,
                      "sign": false,
                      "text": model.user.feeling
                    }).then((value) {
                      if (value != null)
                        model.updateFeeling(value);
                    });
                  }, constraints: constraints)
                ]),
                CustomDivider(
                  height: 1,
                  color: AppColors.c239_239_239
                ),
                _RowItem(children: [
                  Text(intl.signature, style: AppStyles.f14w400c0_0_0),
                  SizedBox(width: 8),
                  ExpandInkWellRow(children: [
                    SelectorCustom<UserModel, String?>(builder: (signature) {
                      return NullWidget<String>(signature, builder: (_, value) {
                        return Wrap(
                          children: [
                            Text(value, style: AppStyles.f14w400c125_125_125)
                          ]
                        ).expanded();
                      });
                    }, selector: (u) => u.signature),
                    SizedBox(width: 15),
                    Image.asset(AppImages.forwardGray)
                  ], onTap: (){
                    pushViewControllerWithName(AppRoutes.editPage, arguments: {
                      "title": intl.signature,
                      "hintText": intl.pleaseEnter,
                      "sign": true,
                      "text": model.user.signature
                    }).then((value) {
                      if (value != null)
                        model.updateSignature(value);
                    });
                  }, constraints: constraints)
                ])
              ]
            )
          )
        ]
    )
  );

  @override
  EditUserModel? initializeModel() {
    return EditUserModel()..user.fromJson(widget.json);
  }
}
final double _rowHeight = 63;
final constraints = BoxConstraints(minHeight: _rowHeight);
class _RowItem extends StatelessWidget {
  _RowItem({required this.children});

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        constraints: constraints,
        // height: _rowHeight,
        child: Row(
          children: this.children
        )
    );
  }
}
/*
 *  Copyright (C), 2015-2021
 *  FileName: bind_bank
 *  Author: Tonight丶相拥
 *  Date: 2021/11/29
 *  Description: 
 **/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'bind_bank_logic.dart';
class BindBank extends StatefulWidget {
 @override
 createState() => _BindBankState();
}

class _BindBankState extends State<BindBank> {

  final TextEditingController _cardController = TextEditingController();
  final FocusNode _cardNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _controllerNode = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final FocusNode _controller1Node = FocusNode();
  final BindBankLogic _stateController = BindBankLogic();
  final TextStyle _style = TextStyle(
    color: Color.fromARGB(255, 34, 40, 49),
    fontSize: 16,
    fontWeight: w_400
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(_stateController);
    _stateController.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<BindBankLogic>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var intl = AppInternational.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(
        title: CustomText("${intl.bindingBank}", fontSize: 16,
          fontWeight: w_500,
          color: Color.fromARGB(255, 34, 40, 49),
        ),
      ),
      body: VisibleSingleScrollView(
        needBounds: false,
        children: [
          SizedBox(height: 38),
          CustomText("${intl.cardHolder}",
            style: _style),
          SizedBox(height: 4),
          _BorderContainer(
            child: CustomTextField(
              node: _cardNode,
              // inputFormatter: [OnlyInputInt()],
              controller: _cardController,
              style: TextStyle(
                fontWeight: w_400,
                fontSize: 17
              ),
              hintTextStyle: TextStyle(
                color: Color.fromARGB(255, 196, 196, 196),
                fontWeight: w_400,
                fontSize: 17
              ),
            ).sampleVisibleEnsure(_cardNode)
          ),
          SizedBox(height: 16),
          CustomText("${intl.openingBank}", style: _style),
          SizedBox(height: 4),
          _BorderContainer(
            child: Obx((){
              return DropdownButton<String>(
                  isExpanded: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  items: _stateController.state.data.map((element) {
                    return DropdownMenuItem<String>(
                      child: CustomText("${element.bankName}"),
                      //     .container(
                      //   // height: 30,
                      //   decoration: BoxDecoration(
                      //     border: Border(
                      //       bottom: BorderSide(
                      //         color: Colors.black12
                      //       )
                      //     )
                      //   )
                      // ),
                      value: element.thirdBankId ?? "",
                    );
                  }).toList(),
                  value: _stateController.state.value.value,
                  onChanged: (String? value){
                    _stateController.setValue(value ?? "");
                  },
                  underline: SizedBox(), style: TextStyle(
                  fontSize: 17, fontWeight: w_400,
                  color: Colors.black
                  // color: Color.fromARGB(255, 196, 196, 196)
              ));
            }).sizedBox(width: context.width)
          ),
          SizedBox(height: 16),
          CustomText("${intl.onlineBankAccount}", style: _style),
          SizedBox(height: 4),
          _BorderContainer(
            child: CustomTextField(
              controller: _controller,
              node: _controllerNode,
              inputFormatter: [OnlyInputInt()],
              hintText: "${intl.enterAccount}",
              style: TextStyle(
                fontWeight: w_400,
                fontSize: 17
              ),
              hintTextStyle: TextStyle(
                color: Color.fromARGB(255, 196, 196, 196),
                fontWeight: w_400,
                fontSize: 17
              ),
            ).sampleVisibleEnsure(_controllerNode)
          ),
          SizedBox(height: 16),
          CustomText("${intl.confirm}", style: _style),
          SizedBox(height: 4),
          _BorderContainer(
            child: CustomTextField(
              controller: _controller1,
              node: _controller1Node,
              inputFormatter: [OnlyInputInt()],
              hintText: "${intl.confirmAccount}",
              style: TextStyle(
                fontWeight: w_400,
                fontSize: 17
              ),
              hintTextStyle: TextStyle(
                color: Color.fromARGB(255, 196, 196, 196),
                fontWeight: w_400,
                fontSize: 17
              )
            ).sampleVisibleEnsure(_controller1Node)
          ),
          SizedBox(height: 65),
          Container(
            width: 148,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Color.fromARGB(255, 34, 40, 49),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 34, 40, 49).withOpacity(0.2),
                  offset: Offset(0, 9),
                  blurRadius: 26
                )
              ]
            ),
            child: CustomText("${intl.bindingNow}",
              fontSize: 13,
              fontWeight: w_500,
              color: Colors.white
            ),
          ).gestureDetector(onTap: (){
            _stateController.onSubmit(_cardController.text,
              _controller.text,
              _controller1.text, (){
                  _clear();
                  Navigator.of(context).pop();
                });
          }).center
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        scrollPhysics: ClampingScrollPhysics()
      ).paddingSymmetric(horizontal: 16)
    );
  }

  void _clear(){
    _cardController.clear();
    _controller.clear();
    _controller1.clear();
  }
}


class _BorderContainer extends StatelessWidget {
  _BorderContainer({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 231, 231, 231))
      ),
      child: child
    );
  }
}
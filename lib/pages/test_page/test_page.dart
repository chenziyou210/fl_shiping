/*
 *  Copyright (C), 2015-2021
 *  FileName: test_page
 *  Author: Tonight丶相拥
 *  Date: 2021/12/1
 *  Description: 
 **/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:hjnzb/common/app_common_widget.dart';

class TestPage extends StatefulWidget {
  @override
  createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  final PageController _controller = PageController();
  final PageController _controller1 = PageController(
    initialPage: 1
  );
  Drag? _drag;

  /// 远程id 集合
  /// key: index , value: remoteUid
  /// 如果remoteUid 为空则显示gif 图标
  final Map<int, int?> remoteMap = {

  };

  final List<Color> _colors = [
    Colors.black12,
    Colors.orange,
    Colors.teal,
    Colors.deepOrange
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_pixelsListener);
  }

  void _pixelsListener(){
    // print("${_controller.position.pixels} !!!~~~~ ${(_controller.page ?? 0) % 1}");
  }

  void _dragDispose(){
    _drag = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dragDispose();
    _controller.removeListener(_pixelsListener);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: DefaultAppBar(),
      body: GestureDetector(
        onHorizontalDragStart: (details){
          _drag = _controller1.position.drag(details, _dragDispose);
        },
        onHorizontalDragCancel: (){
          _dragDispose();
        },
        onHorizontalDragUpdate: (details) {
          _drag?.update(details);
        },
        onHorizontalDragEnd: (details){
          _drag?.end(details);
        },
        onVerticalDragStart: (details){
          _drag = _controller.position.drag(details, _dragDispose);
        },
        onVerticalDragCancel: (){
          _dragDispose();
        },
        onVerticalDragUpdate: (details) {
          _drag?.update(details);
        },
        onVerticalDragEnd: (details){
          _drag?.end(details);
          // todo-- 检查page是否有变动 作出操作
        },
        child: Container(
          color: Colors.transparent,
            child: Stack(
                children: [
                  PageView.builder(
                      controller: _controller,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) {
                        return _TestStatefulWidget(index, _colors[index]);
                        // return Container(
                        //     alignment: Alignment.center,
                        //     color: _colors[index],
                        //     child: CustomText("im page $index", fontSize: 26,
                        //         fontWeight: w_bold,
                        //         color: Colors.white)
                        // );
                      }, itemCount: _colors.length).ignorePointer,
                  PageView.builder(
                      controller: _controller1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return SizedBox();
                        }
                        return Stack(
                            children: [
                              Positioned(child: Container(
                                  width: 100, height: 40,
                                  color: Colors.deepPurpleAccent
                              ), left: 10, top: 10),
                              Positioned(child: Container(
                                  width: 200,
                                  height: 200,
                                  color:Colors.white ,
                                  child: ListView.builder(itemBuilder: (_, index) {
                                    return CustomText("index :$index ~~~").sizedBox(height: 40);
                                  })
                              ), left: 10, bottom: 100),
                              Positioned(child: Container(
                                  height: 40,
                                  width: 300,
                                  color: Colors.blueAccent
                              ), bottom: 0)
                            ]
                        );
                      }, itemCount: 2)//.ignorePointer
                ]
            )
        )
      )
    );
  }
}


class _TestStatefulWidget extends StatefulWidget {
  _TestStatefulWidget(this.index, this.color);
  final int index;
  final Color color;
  @override
  createState()=> _TestStatefulWidgetState();
}

class _TestStatefulWidgetState extends State<_TestStatefulWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("state initState at index ${widget.index}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        alignment: Alignment.center,
        color: widget.color,//_colors[index],
        child: CustomText("im page ${widget.index}", fontSize: 26,
            fontWeight: w_bold,
            color: Colors.white)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("state dispose at index ${widget.index}");
  }
}
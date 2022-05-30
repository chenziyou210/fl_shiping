/*
 *  Copyright (C), 2015-2021
 *  FileName: upload_widget
 *  Author: Tonight丶相拥
 *  Date: 2021/9/22
 *  Description: 
 **/

// import 'package:flutter/material.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:hjnzb/common/app_common_widget.dart';
// import 'package:hjnzb/http/http_channel.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
part of appcommon;

class UploadWidget extends StatefulWidget {
  UploadWidget({this.width,
    this.height,
    this.url,
    this.selectWidget,
    this.fit,
    this.uploadSuccess,
    UploadModel? controller,
    this.color: Colors.black12,
    this.onPercent
  }): this.controller = controller ?? UploadModel();
  @override
  createState() => _UploadWidgetState(url);
  final double? width;
  final double? height;
  final String? url;
  final Widget? selectWidget;
  final BoxFit? fit;
  final void Function(String)? uploadSuccess;
  final Color color;
  final UploadModel controller;
  final void Function(int percent)? onPercent;
}

class _UploadWidgetState extends State<UploadWidget> {
  _UploadWidgetState(this.url);
  String? url;
  int? token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget? w;
    if (url != null && url!.replaceAll(" ", "").isNotEmpty) {
      if (url!.startsWith("http")) {
        w = ExtendedImage.network(url!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit);
      }else {
        var file = File(url!);
        if (file.existsSync()) {
          w = Image.file(file, width: widget.width,
              height: widget.height,
              fit: widget.fit);
        }
      }
    }
    if (w == null) {
      w = widget.selectWidget ?? Icon(Icons.add_outlined);
      w = Align(
        child: w,
        alignment: Alignment.center
      );
    }

    return GestureDetector(
      onTap: () async{
        var result = await Permission.photos.request();
        if (!result.isGranted) {
          return;
        }
        var value = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (value != null) {
          this.url = value.path;
          widget.onPercent?.call(0);
          widget.controller.controller._show();
          setState(() {});
          if (this.token != null) {
            HttpChannel.channel.cancelRequest(this.token!);
          }
          HttpChannel.channel.uploadImage(value.path, process: (int count, int amount) {
            widget.controller.controller._onProcessChange(count, amount);
            widget.onPercent?.call((count / amount * 100).floor());
            // print("----- process success --- count: $count , --- amount: $amount");
          }, cancelToken: (token) {
            this.token = token;
          }).then((value) =>
              value.finalize(
                  wrapper: WrapperModel(),
                  failure: (e) {
                    widget.controller.controller._hide();
                    widget.controller.controller._failure();
                    widget.onPercent?.call(0);
                  },
                  success: (url) {
                    if (widget.uploadSuccess != null) {
                      widget.uploadSuccess!(url);
                      // this.url = url;
                    }
                    widget.controller.controller._hide();
                    this.token = null;
                  }
              ));
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color
            ),
            child: Stack(
                children: [
                  w,
                  ProcessMaskWidget(controller: widget.controller.controller,
                      width: widget.width,
                      height: widget.height)
                ]
            )
        )
      )
    );
  }
}

class UploadModel {
  final ProcessMaskController controller = ProcessMaskController();
  // bool get isUploading => controller._percent != 0 && !controller._isFailure;
  bool get isUploadingComplete => controller._percent == 100 && !controller._isFailure;
  bool get isUploading => controller._isUploading;
  bool get isFailure => controller._isFailure;
}
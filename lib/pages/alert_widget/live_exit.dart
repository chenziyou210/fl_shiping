import 'package:flutter/material.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:extended_image/extended_image.dart';
import 'package:hjnzb/common/app_common_widget.dart';
import 'package:hjnzb/common/app_styles.dart';
import 'package:hjnzb/common/colors.dart';
import 'package:hjnzb/config/app_colors.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'package:hjnzb/manager/app_manager.dart';

class LiveExit extends StatelessWidget {
  const LiveExit(
      {Key? key,
      this.onPop,
      required this.url,
      required this.anchorId,
      required this.userId})
      : super(key: key);
  final VoidCallback? onPop;
  final String url;
  final String anchorId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    var intl = AppInternational.of(context);
    return Stack(
        alignment:Alignment.center,
        fit: StackFit.expand,
        children: [
      // CircleAvatar(
      //   radius: 64,
      //   backgroundImage: NetworkImage(url),
      //   child: Container(
      //     alignment: Alignment(0, .5),
      //   ),
      // ),
      ClipRRect(
        child: ExtendedImage.network(url,
            width: 64, height: 64, fit: BoxFit.cover, enableLoadState: false),
        borderRadius: BorderRadius.circular(64 / 2),
      ).container(),
      Container(
        decoration: BoxDecoration(
          color: Color(0xE5161722),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
        ),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(height: 41),
          Text(intl.followTheAnchor,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          SizedBox(height: 16),
          Container(
            width: 110,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient:
                    LinearGradient(colors: AppMainColors.gameLabelGradient)),
            child:
                Text(intl.followAndExit, style: AppStyles.f12w400c255_255_255),
          ).gestureDetector(onTap: () {
            Navigator.of(context).pop(true);
            HttpChannel.channel
                .audienceExitRoom(roomId: userId, follow: true)
                .then((value) => value.finalize(
                    wrapper: WrapperModel(),
                    success: (_) {
                      AppManager.getInstance<AppUser>().addAttention();
                    }));
          }),
          SizedBox(height: 11),
          Container(
                  width: 110,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10)),
                  child: CustomText(intl.dropOut,
                      style: AppStyles.f12w400c255_255_255
                          .copyWith(color: Colors.white70)))
              .gestureDetector(onTap: () {
            Navigator.of(context).pop(false);
          }),
        ]),
      ).position(top:100),
    ]);
  }
}

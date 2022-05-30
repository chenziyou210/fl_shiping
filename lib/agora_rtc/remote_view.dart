/*
 *  Copyright (C), 2015-2021
 *  FileName: remote_view
 *  Author: Tonight丶相拥
 *  Date: 2021/7/28
 *  Description: 
 **/

part of agora_rtc;

class RemoteView extends StatelessWidget {
  RemoteView({
    required this.uid,
    required this.channel
  });
  final int uid;
  final String channel;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RemoteRtc.SurfaceView(
      uid: uid,
      channelId: channel
    );
  }
}
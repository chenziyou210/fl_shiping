import 'dart:async';

import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hjnzb/common/app_common_widget.dart';

class ContactServicePage extends StatefulWidget {
  ContactServicePage({dynamic arguments})
      : this.url = arguments["url"],
        this.title = arguments["title"];
  final String url;
  final String title;

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<ContactServicePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController _controll;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var instanceWebController;
    _controller.future.then((data) {
      instanceWebController = data;
    });
    return Scaffold(
      appBar: DefaultAppBar(
          title: CustomText(widget.title,
              fontSize: 16, color: Color.fromARGB(255, 15, 15, 15))),
      resizeToAvoidBottomInset: false,
      body: new WillPopScope(onWillPop: () async {
        _controll.canGoBack().then((value) {
          if (value) {
            _controll.goBack();
          } else {
            Navigator.of(context).pop();
          }
          return value;
        });
        return instanceWebController.goBack();
      }, child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controll = webViewController;
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              if (!request.url.startsWith(new RegExp(r'http[s]:\/\/'))) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
          );
        }),
      )),
    );
  }
}

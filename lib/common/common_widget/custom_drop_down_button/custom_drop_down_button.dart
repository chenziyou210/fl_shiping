/*
 *  Copyright (C), 2015-2022
 *  FileName: custom_drop_down_button
 *  Author: Tonight丶相拥
 *  Date: 2022/4/20
 *  Description: 
 **/

part of appcommon;

class CustomDropDownButton extends StatelessWidget {
  CustomDropDownButton(this.text, {required this.popChildBuilder,
    this.ancestorContext, this.onPop,
    this.isBottom: true,
    this.iconColor,
    this.decoration,
    this.textColor,
    this.margin: 0
  });

  final double margin;
  final String text;
  final Color? iconColor;
  final Widget Function() popChildBuilder;
  final Decoration? decoration;
  final bool isBottom;
  final Color? textColor;
  final BuildContext? ancestorContext;
  final void Function(dynamic)? onPop;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: decoration ?? BoxDecoration(
            color: Color.fromARGB(255, 234, 237, 240)
        ),
        padding: EdgeInsets.symmetric(vertical: 1) + EdgeInsets.only(left: 1),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  // color: Colors.white,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(minWidth: 60, minHeight: 30),
                  child: CustomText(text,
                    fontSize: 11,
                    color: textColor ?? Color.fromARGB(255, 25, 28, 36).withOpacity(0.5),
                    fontWeight: w_bold,
                  )//].column(mainAxisAlignment: MainAxisAlignment.center),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, color: iconColor),
              SizedBox(width: 4)
            ]
        )
    ).cupertinoButton(onTap: (){
      var box = context.findRenderObject() as RenderBox;
      var rect = box.localToGlobal(Offset.zero, ancestor: ancestorContext?.findRenderObject()) & box.size;
      Navigator.of(context).push(_CustomRoute(builder: (_, __, ___) {
        return _PopView(rect, popChildBuilder, isBottom, margin);
      })).then((value) => this.onPop?.call(value));
    });
  }
}

class _CustomRoute extends PopupRoute {
  _CustomRoute({required this.builder});
  final Widget Function(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation) builder;

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => null;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => "";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return builder(context, animation, secondaryAnimation);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration.zero;
}


class _PopView extends StatelessWidget {
  _PopView(this.rect, this.child, this.isBottom, this.margin);
  final Rect rect;
  final Widget Function() child;
  final bool isBottom;
  final double margin;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
        children: [
          if (isBottom)
            child().container(constraints: BoxConstraints(
                minWidth: rect.width
            )).position(
              left: rect.left,
              top: rect.bottom + 8 + margin,
              // width: rect.width
            )
          else
            child().container(constraints: BoxConstraints(
              minWidth: rect.width
            )).position(
              left: rect.left,
              bottom: MediaQuery.of(context).size.height - rect.top + 12 + margin,
              // width:  rect.width
            )
        ]
    );
  }
}
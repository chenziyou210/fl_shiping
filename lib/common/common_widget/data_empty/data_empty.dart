/*
 *  Copyright (C), 2015-2021
 *  FileName: data_empty
 *  Author: Tonight丶相拥
 *  Date: 2021/12/17
 *  Description: 
 **/

part of appcommon;

class DataEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppImages.dataEmpty),
        SizedBox(height: 16.pt),
        CustomText("${AppInternational.of(context).dataEmpty}",
          fontSize: 16.pt,
          fontWeight: w_500,
          color: AppMainColors.whiteColor100
        )
      ]
    );
  }
}
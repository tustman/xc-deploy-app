import 'package:flutter/material.dart';
import 'package:xc_deploy_app/common/style/GSYStyle.dart';

/**
 * 头像Icon
 * Created by guoshuyu
 * Date: 2018-07-30
 */

class GSYUserIconWidget extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  GSYUserIconWidget({this.image, this.onPressed, this.width = 30.0, this.height = 30.0, this.padding});

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
        padding: padding ?? const EdgeInsets.only(top: 4.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipOval(
          child: new FadeInImage.assetNetwork(
            placeholder: GSYICons.DEFAULT_USER_ICON,
            //预览图
            fit: BoxFit.fitWidth,
            image: image,
            width: width,
            height: height,
          ),
        ),
        onPressed: onPressed);
  }
}

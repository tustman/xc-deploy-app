import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xc_deploy_app/common/style/GSYStyle.dart';
import 'package:xc_deploy_app/widget/GSYCommonOptionWidget.dart';
import 'package:xc_deploy_app/widget/GSYTitleBar.dart';
import 'package:photo_view/photo_view.dart';

/**
 * 图片预览
 * Created by guoshuyu
 * Date: 2018-08-09
 */

class PhotoViewPage extends StatelessWidget {
  final String url;

  PhotoViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    OptionControl optionControl = new OptionControl();
    optionControl.url = url;
    return new Scaffold(
        appBar: new AppBar(
          title: GSYTitleBar("", rightWidget: new GSYCommonOptionWidget(optionControl)),
        ),
        body: new Container(
          color: Colors.black,
          child: new PhotoView(
            imageProvider: new NetworkImage(url ?? GSYICons.DEFAULT_REMOTE_PIC),
            loadingChild: Container(
              child: new Stack(
                children: <Widget>[
                  new Center(child: new Image.asset(GSYICons.DEFAULT_IMAGE, height: 150.0, width: 150.0)),
                  new Center(child: new SpinKitFoldingCube(color: Colors.white30, size: 60.0)),
                ],
              ),
            ),
          ),
        ));
  }
}

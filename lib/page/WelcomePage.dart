import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xc_deploy_app/common/dao/UserDao.dart';
import 'package:xc_deploy_app/common/redux/GSYState.dart';
import 'package:xc_deploy_app/common/style/GSYStyle.dart';
import 'package:xc_deploy_app/common/utils/CommonUtils.dart';
import 'package:xc_deploy_app/common/utils/NavigatorUtils.dart';
import 'package:redux/redux.dart';

/**
 * 欢迎页
 * Created by guoshuyu
 * Date: 2018-07-16
 */

class WelcomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<GSYState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    new Future.delayed(const Duration(seconds: 2), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        return new Container(
          color: Color(GSYColors.white),
          child: new Center(
            child:
                new Image(image: new AssetImage('static/images/welcome.png')),
          ),
        );
      },
    );
  }
}

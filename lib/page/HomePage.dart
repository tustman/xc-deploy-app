import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xc_deploy_app/common/localization/DefaultLocalizations.dart';
import 'package:xc_deploy_app/common/style/GSYStyle.dart';
import 'package:xc_deploy_app/common/utils/CommonUtils.dart';
import 'package:xc_deploy_app/common/utils/NavigatorUtils.dart';

import 'package:xc_deploy_app/page/DynamicPage.dart';
import 'package:xc_deploy_app/page/MyPage.dart';
import 'package:xc_deploy_app/page/TrendPage.dart';
import 'package:xc_deploy_app/widget/GSYTabBarWidget.dart';
import 'package:xc_deploy_app/widget/GSYTitleBar.dart';
import 'package:xc_deploy_app/widget/HomeDrawer.dart';

/**
 * 主页
 * Created by guoshuyu
 * Date: 2018-07-16
 */
class HomePage extends StatelessWidget {
  static final String sName = "home";

  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text(CommonUtils.getLocale(context).app_back_tip),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(CommonUtils.getLocale(context).app_cancel)),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(CommonUtils.getLocale(context).app_ok))
              ],
            ));
  }

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Icon(icon, size: 16.0), new Text(text)],
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
      _renderTab(GSYICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
      _renderTab(GSYICons.MAIN_MY, CommonUtils.getLocale(context).home_my),
    ];
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new GSYTabBarWidget(
        drawer: new HomeDrawer(),
        type: GSYTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: [
          new DynamicPage(),
          new TrendPage(),
          new MyPage(),
        ],
        backgroundColor: GSYColors.primarySwatch,
        indicatorColor: Color(GSYColors.white),
        title: GSYTitleBar(
          GSYLocalizations.of(context).currentLocalized.app_name,
          iconData: GSYICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onPressed: () {
            NavigatorUtils.goSearchPage(context);
          },
        ),
      ),
    );
  }
}

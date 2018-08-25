import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xc_deploy_app/common/dao/EventDao.dart';
import 'package:xc_deploy_app/common/dao/ReposDao.dart';
import 'package:xc_deploy_app/common/dao/UserDao.dart';
import 'package:xc_deploy_app/common/model/Event.dart';
import 'package:xc_deploy_app/common/model/User.dart';
import 'package:xc_deploy_app/common/model/UserOrg.dart';
import 'package:xc_deploy_app/common/style/GSYStyle.dart';
import 'package:xc_deploy_app/common/utils/CommonUtils.dart';
import 'package:xc_deploy_app/common/utils/EventUtils.dart';
import 'package:xc_deploy_app/common/utils/NavigatorUtils.dart';
import 'package:xc_deploy_app/widget/EventItem.dart';
import 'package:xc_deploy_app/widget/GSYCommonOptionWidget.dart';
import 'package:xc_deploy_app/widget/GSYListState.dart';
import 'package:xc_deploy_app/widget/GSYPullLoadWidget.dart';
import 'package:xc_deploy_app/widget/GSYTitleBar.dart';
import 'package:xc_deploy_app/widget/UserHeader.dart';
import 'package:xc_deploy_app/widget/UserItem.dart';

/**
 * 个人详情
 * Created by guoshuyu
 * Date: 2018-07-18
 */
class PersonPage extends StatefulWidget {
  static final String sName = "person";

  final String userName;

  PersonPage(this.userName, {Key key}) : super(key: key);

  @override
  _PersonState createState() => _PersonState(userName);
}

class _PersonState extends GSYListState<PersonPage> {
  final String userName;

  String beStaredCount = "---";

  bool focusStatus = false;

  String focus = "";

  User userInfo = User.empty();

  final List<UserOrg> orgList = new List();

  final OptionControl titleOptionControl = new OptionControl();

  _PersonState(this.userName);

  _resolveUserInfo(res) {
    if (isShow) {
      setState(() {
        userInfo = res.data;
        titleOptionControl.url = res.data.html_url;
      });
    }
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;

    ///从Dao中获取数据
    ///如果第一次返回的是网络数据，next为空
    ///如果返回的是数据库数据，next不为空
    ///这样数据库返回数据较快，马上显示
    ///next异步再请求后，再更新
    var userResult = await UserDao.getUserInfo(userName, needDb: true);
    if (userResult != null && userResult.result) {
      _resolveUserInfo(userResult);
      if (userResult.next != null) {
        userResult.next.then((resNext) {
          _resolveUserInfo(resNext);
        });
      }
    } else {
      return null;
    }
    var res = await _getDataLogic();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    _getFocusStatus();
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            beStaredCount = res.data.toString();
          });
        }
      }
    });
    return null;
  }

  _getFocusStatus() async {
    var focusRes = await UserDao.checkFollowDao(userName);
    if (isShow) {
      setState(() {
        focus = (focusRes != null && focusRes.result) ? CommonUtils.getLocale(context).user_focus : CommonUtils.getLocale(context).user_un_focus;
        focusStatus = (focusRes != null && focusRes.result);
      });
    }
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beStaredCount, Theme.of(context).primaryColor, orgList: orgList);
    }
    if (userInfo.type == "Organization") {
      return new UserItem(UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]), onPressed: () {
        NavigatorUtils.goPerson(context, UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]).userName);
      });
    } else {
      Event event = pullLoadWidgetControl.dataList[index - 1];
      return new EventItem(EventViewModel.fromEventMap(event), onPressed: () {
        EventUtils.ActionUtils(context, event, "");
      });
    }
  }

  _getUserName() {
    if (userInfo == null) {
      return new User.empty();
    }
    return userInfo.login;
  }

  _getUserOrg() {
    if (page <= 1) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next;
        }
        return new Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

  _getDataLogic() async {
    if (userInfo.type == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    _getUserOrg();
    return await EventDao.getEventDao(_getUserName(), page: page, needDb: page <= 1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {}

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: GSYTitleBar(
          (userInfo != null && userInfo.login != null) ? userInfo.login : "",
          rightWidget: GSYCommonOptionWidget(titleOptionControl),
        )),
        floatingActionButton: new FloatingActionButton(
            child: new Text(focus),
            onPressed: () {
              if (focus == '') {
                return;
              }
              if (userInfo.type == "Organization") {
                Fluttertoast.showToast(msg: CommonUtils.getLocale(context).user_focus_no_support);
                return;
              }
              CommonUtils.showLoadingDialog(context);
              UserDao.doFollowDao(userName, focusStatus).then((res) {
                Navigator.pop(context);
                _getFocusStatus();
              });
            }),
        body: GSYPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) => _renderEventItem(index),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
        ));
  }
}

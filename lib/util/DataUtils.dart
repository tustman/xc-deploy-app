import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../model/UserInfo.dart';

class DataUtils {
  static final String TOKEN = "xc-token";
  static final String APPID = "appId";
  static final String UDID = "udid";
  static final String IS_LOGIN = "isLogin";

  static final String USER_PHONE = "phone";

  // 保存用户登录信息，data中包含了token等信息
  static saveLoginInfo(Map data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String accessToken = data[TOKEN];
      String udid = data[UDID];
      await sp.setString(TOKEN, accessToken);
      await sp.setString(UDID, udid);
      await sp.setBool(IS_LOGIN, true);
    }
  }

  static saveClientInfo(Map data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString("clientId", data['clientId']);
      await sp.setString("clientKey", data['clientKey']);
      print("============>clientId保存成功");
    }
  }

  static clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(TOKEN, "");
    await sp.setString(UDID, "");
    await sp.setBool(IS_LOGIN, false);
  }

  // 保存用户个人信息
  static Future<UserInfo> saveUserInfo(Map data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String phone = data['phone'];
      await sp.setString(USER_PHONE, phone);
      UserInfo userInfo = new UserInfo(phone: phone);
      return userInfo;
    }
    return null;
  }

  // 获取用户信息
  static Future<UserInfo> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool(IS_LOGIN);
    if (isLogin == null || !isLogin) {
      return null;
    }
    UserInfo userInfo = new UserInfo();
    userInfo.phone = sp.getString(USER_PHONE);
    return userInfo;
  }

  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool b = sp.getBool(IS_LOGIN);
    return b != null && b;
  }

  static Future<String> getAccessToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(TOKEN);
  }
}

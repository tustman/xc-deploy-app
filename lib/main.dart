import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/Api.dart';
import 'util/NetUtils.dart';
import 'util/DataUtils.dart';
import 'dart:convert';
import 'page/work_order_list.dart';
import 'page/tabs_demo.dart';
import 'page/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new DeployClient());
}

class DeployClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DeployClientState();
}

class _DeployClientState extends State<DeployClient> {
  Widget finalWidget = new Login();

  @override
  initState() {
    super.initState();

    DataUtils.isLogin().then((isLogin) {
      if (isLogin) {
        setState(() {
          finalWidget = new TabsDemo();
        });
      } else {
        setState(() {
          finalWidget = new Login();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("========================>========>");
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: finalWidget,
    );
  }
}

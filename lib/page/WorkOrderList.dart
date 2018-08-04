import 'package:flutter/material.dart';

class WorkOrderList extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return new _WorkOrderListState();
  }
}

class _WorkOrderListState extends State<WorkOrderList> {

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('工单列表'),
      ),
      body: new Center(
        child: new Text("工单列表页"),
      ),
    );
  }
}

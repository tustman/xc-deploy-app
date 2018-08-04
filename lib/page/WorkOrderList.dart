import 'package:flutter/material.dart';

class WorkOrderList extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return new _WorkOrderListState();
  }
}

class _WorkOrderListState extends State<WorkOrderList> {

  List<String> titles = const <String>["处理中", "已完成"];

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() {}

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: choices.length,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('工单列表'),
          bottom: new TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return new Tab(
                text: choice.title,
                icon: new Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: new Center(
          child: new Text("工单列表页"),
        ),
      ),
    );
  }
}
class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '处理中', icon: Icons.directions_car),
  const Choice(title: '已完成', icon: Icons.directions_walk),
];

// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:async';

// Each TabBarView contains a _Page and for each _Page there is a list
// of _CardData objects. Each _CardData object is displayed by a _CardItem.

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class _Page {
  _Page({ this.label });
  final String label;
  String get id => label[0];
  @override
  String toString() => '$runtimeType("$label")';
}

class _CardData {
  const _CardData({ this.orderNum, this.address, this.deviceCount});

  final String orderNum;
  final String address;
  final num deviceCount;
}

final Map<_Page, List<_CardData>> _allPages = <_Page, List<_CardData>>{
  new _Page(label: '处理中'): <_CardData>[
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 昌平区 华龙苑南里 22号楼 1单元 203室',
      deviceCount: 5,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 朝阳区 华龙苑南里 23号楼 2单元 203室',
      deviceCount: 14,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 海淀区 华龙苑南里 24号楼 3单元 203室',
      deviceCount: 2,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 东城区 华龙苑南里 25号楼 4单元 203室',
      deviceCount: 18,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 朝阳区 华龙苑南里 23号楼 2单元 203室',
      deviceCount: 14,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 海淀区 华龙苑南里 24号楼 3单元 203室',
      deviceCount: 2,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 东城区 华龙苑南里 25号楼 4单元 203室',
      deviceCount: 18,
    ),
  ],
  new _Page(label: '已完成'): <_CardData>[
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 东城区 华龙苑南里 25号楼 4单元 203室',
      deviceCount: 18,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 朝阳区 华龙苑南里 23号楼 2单元 203室',
      deviceCount: 14,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 海淀区 华龙苑南里 24号楼 3单元 203室',
      deviceCount: 2,
    ),
    const _CardData(
      orderNum: '201884210715',
      address: '北京市 东城区 华龙苑南里 25号楼 4单元 203室',
      deviceCount: 18,
    ),
  ],
};

class _CardDataItem extends StatelessWidget {
  const _CardDataItem({ this.page, this.data });

  static const double height = 170.0;
  final _Page page;
  final _CardData data;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          children: [
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      "工单号: " + data.orderNum,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  new Text(
                    "地址: " + data.address,
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  new Text(
                    "设备数: " + data.deviceCount.toString(),
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  new Text(
                    "创建时间: 2018-8-4 21:18",
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TabsDemo extends StatelessWidget {
  static const String routeName = '/material/tabs';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();

    new Timer(const Duration(seconds: 3), () { completer.complete(null); });
    return completer.future.then((_) {
      _scaffoldKey.currentState?.showSnackBar(new SnackBar(
          content: const Text('没有更新数据了~'),
          action: new SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              }
          )
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _allPages.length,
      child: new Scaffold(
        key: _scaffoldKey,
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: new SliverAppBar(
                  title: const Text('我的工单'),
                  actions: <Widget>[
                    new IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        onPressed: () {
                          _refreshIndicatorKey.currentState.show();
                        }
                    ),
                  ],
                  pinned: true,
                  expandedHeight: 150.0,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    tabs: _allPages.keys.map(
                      (_Page page) => new Tab(text: page.label),
                    ).toList(),
                    labelStyle: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: new RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new TabBarView(
              children: _allPages.keys.map((_Page page) {
                return new SafeArea(
                  top: false,
                  bottom: false,
                  child: new Builder(
                    builder: (BuildContext context) {
                      return new CustomScrollView(
                        key: new PageStorageKey<_Page>(page),
                        slivers: <Widget>[
                          new SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          new SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            sliver: new SliverFixedExtentList(
                              itemExtent: _CardDataItem.height,
                              delegate: new SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  final _CardData data = _allPages[page][index];
                                  return new Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: new _CardDataItem(
                                      page: page,
                                      data: data,
                                    ),
                                  );
                                },
                                childCount: _allPages[page].length,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

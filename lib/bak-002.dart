import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget phoneInputSection = new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      filled: true,
                      hintText: '手机号',
                      icon: new Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone),
              ],
            ),
          ),
        ],
      ),
    );
    Widget passwordInputSection = new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new TextFormField(
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      filled: true,
                      hintText: '验证码',
                      icon: new Icon(Icons.sms),
                    ),
                    keyboardType: TextInputType.phone),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: new RaisedButton(
              color: Colors.blue,
              child:
                  new Text('发送验证码', style: new TextStyle(color: Colors.white)),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );

    Widget loginButton = new Container(
      padding: const EdgeInsets.all(20.0),
      child: new RaisedButton(
        padding: const EdgeInsets.all(10.0),
        color: Colors.blue,
        child: new Text(
          '登录',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () {},
      ),
    );

    return new MaterialApp(
      home: Scaffold(
        body: new SafeArea(
          child: new SingleChildScrollView(
            child: ListView(
              children: [
                new SizedBox(height: 100.0),
                Image.asset(
                  'images/login-logo.png',
                  width: 332.0 / 3,
                  height: 308.0 / 3,
                  fit: BoxFit.scaleDown,
                ),
                new SizedBox(height: 50.0),
                phoneInputSection,
                passwordInputSection,
                loginButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}

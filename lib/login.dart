import 'package:flutter/material.dart';
import 'api/Api.dart';
import 'util/NetUtils.dart';
import 'util/DataUtils.dart';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyHomePage(title: '登录页'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  PersonData person = new PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() {
    print("===================>初始化...");
    String url = Api.CLIENT_CONFIG;
    NetUtils.post(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          var data = map['data'];
          print(data);
          DataUtils.saveClientInfo(data);
        }
      }
    });
  }
  void _handleLogin() {
    final FormState form = _formKey.currentState;
    form.save();
    showInSnackBar('登录中...');
  }
  void _handleSendCode() {
    showInSnackBar('验证码已发送');
    String url = Api.CLIENT_CONFIG;
    NetUtils.post(url).then((data) {
      if (data != null) {
        print(data);
        Map<String, dynamic> map = json.decode(data);
        print(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new Center(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Center(
                    child: Image.asset(
                      'images/login-logo.png',
                      width: 300 / 3,
                      height: 300 / 3,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                                keyboardType: TextInputType.phone,
                                onSaved: (String value) {
                                  person.phoneNumber = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                                      borderRadius: BorderRadius.circular(
                                          5.0)),
                                  filled: true,
                                  hintText: '验证码',
                                  icon: new Icon(Icons.sms),
                                ),
                                keyboardType: TextInputType.phone,
                                onSaved: (String value) {
                                  person.code = value;
                                },
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          padding: const EdgeInsets.fromLTRB(
                              10.0, 0.0, 0.0, 0.0),
                          child: new RaisedButton(
                            color: Colors.blueGrey,
                            child:
                            new Text('获取验证码',
                                style: new TextStyle(color: Colors.white)),
                            onPressed: _handleSendCode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(20.0),
                    child: new RaisedButton(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.blueGrey,
                      child: new Text(
                        '登录',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: _handleLogin,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonData {
  String phoneNumber = '';
  String code = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child:
              new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

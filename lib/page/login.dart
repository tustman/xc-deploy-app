import 'package:flutter/material.dart';
import '../api/Api.dart';
import '../util/NetUtils.dart';
import '../util/DataUtils.dart';
import 'dart:convert';
import '../page/work_order_list.dart';
import '../page/tabs_demo.dart';

class Login extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  PersonData person = new PersonData();

  void showInfoSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value), backgroundColor: Colors.blue));
  }

  void showWarnSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value), backgroundColor: Colors.orange));
  }

  void showSuccessSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value), backgroundColor: Colors.green));
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  void initConfig() {
    print("===================>初始化client...");
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
    if (person.code.length != 6) {
      showWarnSnackBar('请输入正确的验证码~');
      return;
    }
    print("phone=" + person.phoneNumber + ",code=" + person.code);
    showInfoSnackBar('登录中...');
    String url = Api.LOGIN;
    NetUtils.post(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          var dataMap = map['data'];
          DataUtils.saveLoginInfo(dataMap);
          showSuccessSnackBar('登录成功~');
          Navigator.of(context).push(new MaterialPageRoute(
                builder: (ctx) => new TabsDemo(),
              ));
        }
      }
    });
  }

  void _handleSendCode() {
    final FormState form = _formKey.currentState;
    form.save();
    if (person.phoneNumber.length != 11) {
      showWarnSnackBar('请输入正确的手机号~');
      return;
    }
    String url = Api.SMS_END;
    NetUtils.post(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          print(map);
          showSuccessSnackBar('验证码已发送~');
        }
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
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  filled: true,
                                  hintText: '手机号',
                                  icon: new Icon(Icons.phone),
                                ),
                                keyboardType: TextInputType.phone,
                                onSaved: (String value) {
                                  person.phoneNumber = value;
                                  print("=========>" + value);
                                  print(person.phoneNumber);
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
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
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
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: new RaisedButton(
                            color: Colors.blue,
                            child: new Text('获取验证码',
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
                      color: Colors.blue,
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

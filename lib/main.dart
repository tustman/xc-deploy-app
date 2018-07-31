import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyHomePage(title: '智能家居'),
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
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  bool _autovalidate = false;

  PersonData person = new PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('登录'),
      ),
      body: new Center(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Center(
                    child: new Text("智能家居",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0)),
                  ),
                  const SizedBox(height: 24.0),
                  new TextFormField(
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        filled: true,
                        hintText: '手机号',
                        icon: new Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      onSaved: (String value) {
                        person.phoneNumber = value;
                      }),
                  const SizedBox(height: 24.0),
                  new TextField(
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      filled: true,
                      hintText: '验证码',
                      icon: new Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      person.email = value;
                    }
                  ),
                  const SizedBox(height: 24.0),
                  new Center(
                    child: new SizedBox(
                      width: 400.0,
                      height: 50.0,
                      child: new RaisedButton(
                        color: Colors.blueGrey,
                        child: new Text('登录',
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                        onPressed: _handleSubmitted,
                      ),
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
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
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

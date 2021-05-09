import 'package:coronadetector/models/persons.dart';
import 'package:coronadetector/screens/loggedscreen.dart';
import 'package:coronadetector/utils/dateformation.dart';
import 'package:coronadetector/utils/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

var db = new DBHelper();

main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona App',
      home: new CoronaHome(),
    );
  }
}

class CoronaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CoronaState();
  }
}

class CoronaState extends State<CoronaHome> {
  TextEditingController _inemailcontrol = new TextEditingController();
  TextEditingController _inpasscontrol = new TextEditingController();
  TextEditingController _upnamecontrol = new TextEditingController();
  TextEditingController _uppassword1control = new TextEditingController();
  TextEditingController _upemailcontrol = new TextEditingController();
  TextEditingController _forgotemail=new TextEditingController();
  TextEditingController _forgotname=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: new Center(
          child: new ListView(
            children: [
              new Padding(padding: const EdgeInsets.only(top: 10)),
              new Image.asset(
                'images/person.png',
                height: 200,
                width: 200,
                color: Colors.teal,
              ),
              new Padding(padding: const EdgeInsets.only(top: 40)),
              new ListTile(
                leading: new Icon(
                  Icons.email,
                  color: Colors.teal,
                ),
                title: new TextField(
                    controller: _inemailcontrol,
                    decoration: new InputDecoration(
                      hintText: 'e.g. someone@gmail.com',
                      labelText: 'Email',
                    )),
              ),
              new ListTile(
                leading: new Icon(
                  Icons.lock,
                  color: Colors.teal,
                ),
                title: new TextField(
                  controller: _inpasscontrol,
                  decoration: new InputDecoration(
                    hintText: 'e.g. user452@1',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
              new Padding(padding: const EdgeInsets.all(5)),
              new Center(
                child: new FlatButton(
                  onPressed: () {
                    login(context);
                  },
                  child: new Text(
                    'Login',
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.teal,
                ),
              ),
              new TextButton(
                onPressed: _forgotpassword,
                child: new Text(
                  'Forgot Password?',
                  style: new TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              new Padding(padding: const EdgeInsets.only(top: 50)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 80),
                    child: new FlatButton(
                      onPressed: () {
                        signup();
                      },
                      child: new Text(
                        'Signup',
                        style: new TextStyle(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                    ),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    //margin: EdgeInsets.only(right: 200),
                    child: new FlatButton(
                      onPressed: () {
                        skip();
                      },
                      child: new Text(
                        'Skip',
                        style: new TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Future login(BuildContext context) async {
    bool flag=false;
    Person person = await db.getPerson(_inemailcontrol.text);
    try {
      if (_inemailcontrol.text == person.email &&
          _inpasscontrol.text == person.password) {
        Map result = await Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) {
            return new LoggedScreen(name: person.name,);
          }),
        );
        flag = true;
      } else if (_inemailcontrol.text == person.email &&
          _inpasscontrol.text != person.password) {
        flag = true;
        var alert1 = new AlertDialog(
          scrollable: true,
          title: new Text('Error'),
          content: new Text(
            'Email ID or Password is incorrect!',
            style: new TextStyle(color: Colors.red, fontSize: 14),
          ),
          actions: [
            new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text('Retry!')),
          ],
        );
        showDialog(context: context, builder: (context) => alert1);
      }
    }
    catch(e){
      if(flag==false){
      print('I am here');
      _nopersonexist(_inemailcontrol.text);
    }}
    _inpasscontrol.clear();
  }

  signup() {
    var alert = new AlertDialog(
      scrollable: true,
      title: new Text('Sign up!'),
      content: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new ListTile(
            //          leading: new Icon(Icons.person,color: Colors.teal,),
            title: new TextField(
              controller: _upnamecontrol,
              decoration: new InputDecoration(
                hintText: 'e.g. Faiz Aalam',
                labelText: 'Name',
              ),
            ),
          ),
          new ListTile(
            //         leading: new Icon(Icons.email,color: Colors.teal,),
            title: new TextField(
              controller: _upemailcontrol,
              decoration: new InputDecoration(
                hintText: 'e.g. someone@gmail.com',
                labelText: 'Email',
              ),
            ),
          ),
          new ListTile(
            //           leading: new Icon(Icons.lock,color: Colors.teal,),
            title: new TextField(
              controller: _uppassword1control,
              decoration: new InputDecoration(
                hintText: 'e.g. user243@3',
                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ),
        ],
      ),
      actions: [
        new FlatButton(
          onPressed: (){_submitsignup();Navigator.pop(context);},
          child: new Text(
            'SignUp',
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.teal,
        ),
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text(
            'Cancel',
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.blueGrey,
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  skip() async{
    Map data=await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
      return new LoggedScreen(name: "Guest",);
    })
    );
  }

  void _submitsignup() async {
    Person person = new Person(_upnamecontrol.text, _upemailcontrol.text,
        _uppassword1control.text, dateFormatted());
    int Saved = await db.AddPerson(person);
//    print('Total $Saved accounts have been saved');
    _uppassword1control.clear();
    var alert2=new AlertDialog(
      title: new Text('Process Successful'),
      content: new Text('Thank you ${_upnamecontrol.text} for signing up.',style: new TextStyle(color:Colors.teal),),
      actions: [
        new FlatButton(onPressed: (){Navigator.pop(context);}, child:new Text('Proceed forward!')),
      ],
    );
    _inemailcontrol.text=_upemailcontrol.text;
    showDialog(context: context, builder: (context)=>alert2);
    _upnamecontrol.clear();
    _uppassword1control.clear();
  }

  void _forgotpassword() {
    var alert=new AlertDialog(
      scrollable: true,
      title: Text('Forgot Password'),
      content: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new TextField(controller: _forgotname,
            decoration: new InputDecoration(hintText: 'e.g. Faiz Aalam',labelText: 'Name'),),
          new TextField(controller: _forgotemail,
          decoration: new InputDecoration(hintText: 'e.g. someone@gmail.com',labelText: 'Email'),),
        ],
      ),
      actions: [new FlatButton(onPressed: (){Navigator.pop(context);_fetchpass();}, child: new Text('Fetch Password',style: new TextStyle(color: Colors.white),),color: Colors.teal,),],
    );
    showDialog(context: context, builder: (context)=>alert);
  }

  void _fetchpass() async{
    bool flag=false;
    Person person = await db.getPerson(_forgotemail.text);
    try {
      if (_forgotemail.text == person.email &&
          _forgotname.text == person.name) {
        int _id = person.id;
        var alert = new AlertDialog(
            scrollable: true,
            title: Text('Retrieved Password:'),
            content: new Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                new Text(
                    "${_forgotname.text} your password is ${person.password}"),
              ],),
            actions: [new FlatButton(onPressed: () {
              Navigator.pop(context);
              _inemailcontrol.text = _forgotemail.text;
              _inpasscontrol.text = person.password;
              _forgotemail.clear();
              _forgotname.clear();
            },
              child: new Text(
                'Use it', style: new TextStyle(color: Colors.white),),
              color: Colors.teal,),
            ]);
        showDialog(context: context, builder: (context) => alert);flag=true;
      }
    }
    catch(e){
      if(flag==false)
        {
          _nopersonexist(_forgotemail.text);
          _forgotemail.clear();_forgotname.clear();
        }
    }
  }
  void _nopersonexist(String text) {
    var alert=new AlertDialog(
      scrollable: true,
      title: new Text('No account'),
      content: Text('There is no account with \n\nemail: $text'),
      actions: [new FlatButton(onPressed: (){Navigator.pop(context);signup();}, child: new Text('Signup')),
        new FlatButton(onPressed: (){Navigator.pop(context);_inemailcontrol.clear();}, child: new Text('Leave'))],
    );
    showDialog(context: context, builder: (context)=>alert);
  }
}
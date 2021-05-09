import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
var location=new Location();
Geolocator geolocator=new Geolocator();
class LoggedScreen extends StatefulWidget {
  String name;
  @override
  LoggedScreen({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new LoggedState(name);
  }
}
class LoggedState extends State<LoggedScreen> {
  String name;
  TextEditingController _bmicontrol = new TextEditingController();

  bool allwell=false;

  double totalchances=0;

  @override
  void initState() {
    super.initState();
  }

  @override
  LoggedState(this.name);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Welcome $name'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
      ),
      body: new Container(
        alignment: Alignment.topCenter,
        child: new Stack(children: [
          new Column(
            children: [
              new Padding(padding: const EdgeInsets.all(10)),
              new Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(right: 50),
                child: new Image.asset(
                  'images/corona.png',
                  height: 200,
                  width: 200,
                ),
              ),
              // new Padding(padding: const EdgeInsets.all(25)),
              new Center(
                child: new Text(
                  'Corona Checker',
                  style: new TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            ],
          ),
          new Center(
            child: new ListView(
              padding: const EdgeInsets.fromLTRB(30, 130, 30, 0),
              children: [
                new Padding(padding: const EdgeInsets.all(80)),
                new Container(
                  alignment: Alignment.bottomLeft,
                  height: 230,
                  width: 320,
                  child: new Scrollbar(
                    thickness: 4,
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    child: ListView(
                      children: [
                        new ListTile(
                          title: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              new Padding(padding: const EdgeInsets.all(5)),
                              new Text(bmival == -1?'BMI?':'BMI'),
                              new Padding(padding: const EdgeInsets.all(5))
                            ],
                          ),
                          onTap: () {
                            _bmichecker();
                          },
                          subtitle: Text(bmival == -1? "*must fill it": 'You\'r BMI is $bmival'),
                        ),
                        new Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        new ListTile(
                          title: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              new Padding(padding: const EdgeInsets.all(5)),
                              new Text(fevgroupval == -1 ?'Fever?':'Fever'),
                              new Padding(padding: const EdgeInsets.all(5))
                            ],
                          ),
                          onTap: () {
                            _feverchecker();
                          },
                          subtitle: Text(fevgroupval == -1 ? "*must fill it" : fevgroupval == 1 ? 'You are experiencing fever':'You don\'t have fever' ),
                        ),
                        new Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        new ListTile(
                          title: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              new Padding(padding: const EdgeInsets.all(5)),
                              new Text(flugroupval ==-1? 'Flu?':'Flu'),
                              new Padding(padding: const EdgeInsets.all(5))
                            ],
                          ),
                          onTap: () {
                            _fluchecker();
                          },
                          subtitle: Text(flugroupval ==-1? "*must fill it": flugroupval == 1? 'You are experiencing flu': 'You don\'t have flue'),
                        ),
                        new Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        new ListTile(
                          title: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              new Padding(padding: const EdgeInsets.all(5)),
                              new Text(paingroupval == -1? 'Pain?':'Pain'),
                              new Padding(padding: const EdgeInsets.all(5))
                            ],
                          ),
                          onTap: () {
                            _painchecker();
                          },
                          subtitle: Text(paingroupval == -1? "*must fill it": paingroupval == 1 ? 'You\'r body is paining':'You don\'t have bodypain'),
                        ),
                        new Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        new ListTile(
                          title: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              new Padding(padding: const EdgeInsets.all(5)),
                              new Text(weakgroupval == -1 ? 'Weakness?':'Weakness'),
                              new Padding(padding: const EdgeInsets.all(5))
                            ],
                          ),
                          onTap: () {
                            _weakchecker();
                          },
                          subtitle: Text(weakgroupval == -1 ? "*must fill it" : weakgroupval == 1 ? 'You are experincing weakness':'You don\'t have weakness'),
                        ),
                        new Divider(
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(padding: const EdgeInsets.all(5)),
              ],
            ),
          ),
          new Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(80),
            child: new FlatButton(
              onPressed: () {
                check_fields();
                if(allwell==true) {
                  _result();
                }
              },
              child: new Text(
                'Check',
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
          )
        ]),
      ),
    );
  }

  double bmival = -1;

  _bmichecker() {
    var alert2 = new AlertDialog(
      scrollable: true,
      title: new Text('BMI'),
      content: new TextField(
        autofocus: true,
        keyboardType: TextInputType.number,
        controller: _bmicontrol,
        decoration: new InputDecoration(
          hintText: 'e.g.23.4',
          labelText: 'BMI',
        ),
      ),
      actions: [
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              bmival = double.parse(_bmicontrol.text);
              _bmicontrol.clear();
            });
          },
          child: new Text(
            'Submit',
            style: new TextStyle(color: Colors.white),
          ),
          color: Colors.teal,
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert2);
  }

  var fevgroupval=-1;

  _feverchecker() {
    var alert2 = new AlertDialog(
      scrollable: true,
      title: new Text('Fever'),
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            children: [
              new Radio<int>(
                  value: 0,
                  groupValue: fevgroupval,
                  onChanged: handlefeverradio),
              new Text("No")
            ],
          ),
          new Row(
            children: [
              new Radio<int>(
                  value: 1,
                  groupValue: fevgroupval,
                  onChanged: handlefeverradio),
              new Text("Yes")
            ],
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (context) => alert2);
  }

  void handlefeverradio(int value) {
    setState(() {
      fevgroupval = value;
      Navigator.pop(context);
    });
  }

  var flugroupval=-1;

  _fluchecker() {
    var alert2 = new AlertDialog(
      scrollable: true,
      title: new Text('Flu'),
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            children: [
              new Radio<int>(
                  value: 0, groupValue: flugroupval, onChanged: handlefluradio),
              new Text("No")
            ],
          ),
          new Row(
            children: [
              new Radio<int>(
                  value: 1, groupValue: flugroupval, onChanged: handlefluradio),
              new Text("Yes")
            ],
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (context) => alert2);
  }

  void handlefluradio(int value) {
    setState(() {
      flugroupval = value;
      Navigator.pop(context);
    });
  }

  var paingroupval=-1;

  _painchecker() {
    var alert2 = new AlertDialog(
      scrollable: true,
      title: new Text('Pain'),
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            children: [
              new Radio<int>(
                  value: 0,
                  groupValue: paingroupval,
                  onChanged: handlepainradio),
              new Text("No"),
            ],
          ),
          new Row(
            children: [
              new Radio<int>(
                  value: 1,
                  groupValue: paingroupval,
                  onChanged: handlepainradio),
              new Text("Yes"),
            ],
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (context) => alert2);
  }

  void handlepainradio(int value) {
    setState(() {
      paingroupval = value;
      Navigator.pop(context);
    });
  }

  var weakgroupval=-1;

  _weakchecker() {
    var alert2 = new AlertDialog(
      scrollable: true,
      title: new Text('Weakness'),
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Row(
            children: [
              new Radio<int>(
                  value: 0,
                  groupValue: weakgroupval,
                  onChanged: handleweakradio),
              new Text("No")
            ],
          ),
          new Row(
            children: [
              new Radio<int>(
                  value: 1,
                  groupValue: weakgroupval,
                  onChanged: handleweakradio),
              new Text("Yes")
            ],
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (context) => alert2);
  }

  void handleweakradio(int value) {
    setState(() {
      weakgroupval = value;
      Navigator.pop(context);
    });
  }

  _result() async {
    Address currentaddress;
    ProgressDialog progressDialog = ProgressDialog(
        context, type: ProgressDialogType.Normal);
    progressDialog.show();
    Future.delayed(Duration(seconds: 2)).then((value) async {
      progressDialog.update(message: 'Calculating Results',messageTextStyle: new TextStyle(fontSize: 14));
      currentaddress=await getUserLocation();
      progressDialog.hide();
      _finalresult(currentaddress);
    });
  }

  void _finalresult(Address currentaddress) {
    var alert = new AlertDialog(
        scrollable: true,
        elevation: 2,
        title: Text("Results:"),
        content: new ListTile(
          title: new Center(child: new Text(totalchances<=40?'Good State':totalchances>40 && totalchances<=60?'Precautionary State':
          totalchances>60&& totalchances<=80?'Alert State':'Harmful State',style: new TextStyle(fontWeight: FontWeight.bold,
            color: totalchances<=40?Colors.teal:totalchances>40&&totalchances<=60?Colors.deepOrangeAccent:Colors.red.shade600,),)),
          subtitle:
              new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                new Padding(padding: const EdgeInsets.all(7)),
                new Text('Name:',style: new TextStyle(fontWeight: FontWeight.bold),),
                new Padding(padding: const EdgeInsets.all(1)),
                new Text(name,style: new TextStyle(color: Colors.black54,fontSize: 12),),
                new Padding(padding: const EdgeInsets.all(3)),
                new Text('Corona Chances:',style: new TextStyle(fontWeight: FontWeight.bold),),
                new Padding(padding: const EdgeInsets.all(1)),
                new Text('There are  $totalchances  chances of corona',style: new TextStyle(color: Colors.black54,fontSize: 12),),
                new Padding(padding: const EdgeInsets.all(3)),
                new Text('Suggestions:',style: new TextStyle(fontWeight: FontWeight.bold),),
                new Padding(padding: const EdgeInsets.all(3)),
                new Text(totalchances<=40? "Avoid Gatherings": totalchances>40 && totalchances<60? "Get Quarantine for some days, Take Good Food":
                "Admit yourself in hospital, your partners must take corona test.",style: new TextStyle(color: Colors.black54,fontSize: 12),),
                new Padding(padding: const EdgeInsets.all(3)),
                new Text('Location:',style: new TextStyle(fontWeight: FontWeight.bold),),
                new Padding(padding: const EdgeInsets.all(1)),
                new Text('${currentaddress.subAdminArea}, ${currentaddress.adminArea}, ${currentaddress.countryName}',style: new TextStyle(color: Colors.black54,fontSize: 12),),
              ],
            ),
          ),
      actions: [new FlatButton(onPressed:()=>Navigator.pop(context), child: new Text('ok',style: new TextStyle(color: Colors.white),),
      color: totalchances<=40?Colors.teal:totalchances>40&&totalchances<=60?Colors.deepOrangeAccent:Colors.red.shade600,),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }
  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    var currentLocation = myLocation;
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    return first;
  }
  void check_fields() {
    bool fail=false;
    if(bmival==-1 && fail==false) {
      _erroralert('BMI');
      fail=true;
    }
    if(fevgroupval==-1 && fail==false) {
      _erroralert('Fever');
      fail=true;
    }
    if(flugroupval==-1 && fail==false) {
      _erroralert('Flu');
      fail=true;
    }
    if(paingroupval==-1 && fail==false) {
      _erroralert('Pain');
      fail=true;
    }
    if(weakgroupval==-1 && fail==false) {
      _erroralert('Weakness');
      fail=true;
    }
    if(bmival!=-1 && fevgroupval!=-1 && flugroupval!=-1 && paingroupval!=-1 && weakgroupval!=-1) {allwell=true;
    setState(() {
      totalchances=(38-bmival)+((fevgroupval)*14.5)+((flugroupval)*16.6)+((paingroupval)*17.4)+((weakgroupval)*13.5);
    });
    }
  }
  _erroralert(String s) {
    var alert=new AlertDialog(
      title: Text('Error:'),
      content: new ListTile(title: Text('$s field is empty.'),subtitle: Text('Please Fill it out and try again'),),
      actions: [new FlatButton(onPressed: ()=>Navigator.pop(context), child: new Text('Try Again',style: new TextStyle(color: Colors.white),),color: Colors.red,)],
    );
    showDialog(context: context, builder:(context)=>alert);
  }
}
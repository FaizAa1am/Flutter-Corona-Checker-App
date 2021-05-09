class Person {
  String _name;
  String _email;
  String _password;
  String _date;
  int _id;
  Person(this._name,this._email,this._password,this._date);
  Person.map(dynamic obj){
    this._name=obj['name'];
    this._email=obj['email'];
    this._password=obj['password'];
    this._date=obj['date'];
    this._id=obj['id'];
  }
  String get name=>_name;
  String get email=>_email;
  String get password=>_password;
  String get date=>_date;
  int get id=>_id;
  Map<String,dynamic> toMap(){
    var map=new Map<String, dynamic>();
    map['name']=_name;
    map['email']=_email;
    map['password']=_password;
    map['date']=_date;
    if(_id!=null)
    {
      map['id']=_id;
    }
    return map;
  }
  Person.frommap(Map<String , dynamic>map)
  {
    this._name=map['name'];
    this._password=map['password'];
    this._email=map['email'];
    this._date=map['date'];
    this._id=map['id'];
  }
}

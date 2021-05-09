import 'dart:async';
import 'dart:io';
import 'package:coronadetector/models/persons.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class DBHelper{
  String _table='PersonTable';
  String _name='name';
  String _password='password';
  String _date='date';
  String _id='id';
  String _email='email';

  static final DBHelper _instance=new DBHelper.internal();
  factory DBHelper()=>_instance;
  static Database _db;
  Future<Database> get db async{
    if(_db!=null)
    {
      return _db;
    }
    _db=await initDB();
    return _db;
  }
  DBHelper.internal();

  initDB() async{
    Directory DocumentDirectory= await getApplicationDocumentsDirectory();
    String path=join(DocumentDirectory.path,"DBPERSON.db");
    var ourDB=await openDatabase(path,version: 1,onCreate: _onCreate);
    return ourDB;
  }

  _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE $_table($_id INTEGER PRIMARY KEY,$_name TEXT,$_email TEXT,$_password TEXT,$_date TEXT)');
  }
  Future<int> AddPerson(Person person)async{
    var dbClient=await db;
    int res=await dbClient.insert('$_table', person.toMap());
    return res;
  }
  Future<List> getAllPersons()async{
    var dbClient=await db;
    var result=await dbClient.rawQuery("SELECT * FROM $_table ORDER BY $_name ASC");
    return result.toList();
  }
  Future<int>getCount()async{
    var dbClient=await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT * FROM $_table"));
  }
  Future<Person>getPerson(String email)async{
    var dbClient=await db;
    var result=await dbClient.query(_table, where: "$_email LIKE ?",whereArgs: [email]);
    if(result.length==0)return null;
    return new Person.frommap(result.first);
  }
  Future<int> deletePerson(int id)async{
    var dbClient=await db;
    return await dbClient.delete(_table, where: "$_id=?",whereArgs: [id]);
  }
  Future<int> updatePerson(Person person)async{
    var dbClient=await db;
    return await dbClient.update(_table, person.toMap(),where: "$_id=?",whereArgs: [person.id]);
  }
  Future close()async{
    var dbClient=await db;
    return dbClient.close();
  }
}
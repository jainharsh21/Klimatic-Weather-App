import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper 
{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async{
    if(_db!=null){
      return _db;
    }else{
      _db = await initDb();
            return _db;
          }
        } 
      
        DatabaseHelper.internal();
      
        initDb() async{
          Directory documentDirectory = await getApplicationDocumentsDirectory();
          String path = join(documentDirectory.path,"maindb.db");
          print(path);
        } 

}
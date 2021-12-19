import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toodoo/modules/done/done_screen.dart';
import 'package:toodoo/modules/postponed/postponed_screen.dart';
import 'package:toodoo/modules/tasks/tasks_screen.dart';
import 'package:toodoo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitalState());
  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  List screens = [
    TasksScreen(),
    DoneScreen(),
    PostponedScreen(),
  ];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Map> newTasks = [];
  List<String> appbarTitles = ['Tasks', 'Done', 'Postponed'];
  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  Database database;
  bool showBottomsheetStatus = false;
  IconData iconStatus = Icons.edit;

  //create database
  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title Text , date TEXT , status TEXT , time TEXT)')
          .then((value) => print('table created'))
          .catchError((error) {
        print('this error happened when table created ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('database opened');
    }).then((value){database = value ; emit(DatabaseCreatedState());});
  }

  //insert to database
   insertIntoDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date ,status ,time)  VALUES("${title}" , "${date}" ,"new" ,"${time}")')
          .then((value) {
        print('$value is created');
        emit(InsertIntoDatabaseState());
        // myRandomColor();
        getDataFromDataBase(database);
      }).catchError((error) {
        print(' this error happened during insert :${error.toString()}');
      });
      return null ;
    });
  }

  void changeBottomSheet(
      {@required bool isShowen, @required IconData iconData}) {
    showBottomsheetStatus = isShowen;
    iconStatus = iconData;
    emit(changeBottomSheetState());
  }

  //get data from database
  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetDataFromDataBaseLoadingState());
    database.rawQuery('SELECT * FROM TASKS').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(GetDataFromDataBaseSuccessState());
    });
  }

  //update data
  void updateDataBase({int id, @required String status}) {
    database.rawUpdate('UPDATE tasks SET status = ? Where id =?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database);
      emit(UpdateDataFromDataBaseState());
    });
  }

//delete database
  void deleteDataBase({int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(DeletDataFromDataBaseState());
    });
  }


  List colors = [
    0xff828181 ,
    0xffA5D6A7 ,
    0xffBCAAA4 ,
    0xffF7F7F7,
  ];
  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
  var randomColor;
 dynamic myRandomColor(){
   return randomColor = getRandomElement(colors);
  }


}

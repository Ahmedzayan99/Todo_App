// ignore_for_file: avoid_print, must_be_immutable



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/modules/archivedTask.dart';
import 'package:todo_app/modules/doneTask.dart';
import 'package:todo_app/modules/newTask.dart';
import 'package:todo_app/shared/cubit/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);
  int current = 0;
  List<Widget> screen =
  [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];
  List<String> title =
  [
    'NewTask',
    'DoneTask',
    'ArchivedTask',
  ];

  void changeIndex(int index) {
    current = index;
    emit(TodoChangeBottomNavBarState());
  }

  bool isBottomSheet = false;
  IconData iconShow = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheet = isShow;
    iconShow = icon;
    emit(TodoChangeBottomSheetState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    print('Start **********************************');
    openDatabase(
      'TodoApp.db',
      version: 1,
      onCreate: (database, version) {
        print('DataBase Created ------------------------------------');
        database.execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        )
            .then((value) {
          print('Table Created ====================================');
        }).catchError((error) {
          print('error when ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDatabase(database);
        print('DataBase Opened ________________________________________');
      },
    ).then((value) {
      database = value;
      emit(TodoCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async
    {
      await txn
          .rawInsert(
              'INSERT INTO task (title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      )
          .then((value) {
        print(' insert successfully');
        emit(TodoInsertDatabaseState());
        getFromDatabase(database);
      })
          .catchError((error) {
        print('when error${error.toString()}');
      });
    });
  }

 getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(TodoGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new'){
          newTasks.add(element);

        }

        else if (element['status'] == 'done'){
          doneTasks.add(element);

        }

        else archiveTasks.add(element);

      });
      emit(TodoGetDatabaseState());
    });
  }
  void updateToDatabase({
    required String status,
    required int id,
  })  {
    database.rawUpdate(
        'UPDATE task SET status = ? WHERE id = ?',
        [status, id])
        .then((value) {
      getFromDatabase(database);
      emit(TodoUpdateDatabaseState());
    });
  }

  void deleteFromDatabase(
  {
  required id ,
}
      ) {
        database
        .rawDelete('DELETE FROM task WHERE id = ?', [id])
        .then((value) {
      getFromDatabase(database);
      emit(TodoDeleteDatabaseState());
    });
  }
}
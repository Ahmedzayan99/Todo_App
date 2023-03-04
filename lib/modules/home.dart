// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';

import 'package:todo_app/shared/cubit/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;
  var titleController = TextEditingController();
  var timeController =TextEditingController();
  var dateController = TextEditingController();



//_____________start build Widget____________________________________________________________
  @override
  Widget build(BuildContext context)
  {
  //  TodoCubit cubit = BlocProvider.of(context);
  //  var c = TodoCubit.get(context);
    //----------Start the  bloc
    return BlocProvider(
      create:(BuildContext context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit,TodoStates>(
        listener:(context, state) {
          if(state is TodoInsertDatabaseState){
            Navigator.pop(context);
          }
        } ,
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            // ------appBer -----------
            appBar:
            AppBar(
              elevation: 0.0,
              title:  Text(
               '${cubit.title[cubit.current]}',
                        style: TextStyle(color: Colors.black),
                         ),
            ),
            body:ConditionalBuilder(
                condition: state is! TodoGetDatabaseLoadingState,
                builder:(context) => cubit.screen[cubit.current],
                fallback:(context) => const Center(
                    child: CircularProgressIndicator()
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet ) {
                  if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
              /*then((value) {
                      cubit.getFromDatabase(cubit.database).then((value) {
                        Navigator.pop(context);
                        cubit.changeBottomSheetState(
                            isShow:false ,
                            icon: Icons.edit,);
                        cubit.tasks =value;
                        print("is----------------------------------------------------------");
                        print(cubit.tasks);
                      });
                    });*/

                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>Container(
                      color:Colors.grey[300],
                      padding: const EdgeInsets.all(20.0,),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Title task';
                                }
                                return null;
                              },
                              controller: titleController,
                              onTap: () {
                                print('Email taping');
                              },
                              type: TextInputType.emailAddress,
                              text: 'Task Title',
                              prefix: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20.0,),
                            defaultFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter time task';
                                }
                                return null;
                              },
                              controller: timeController,
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value){
                                  timeController.text = value!.format(context).toString();
                                });
                                print('timing taping');
                              },
                              type: TextInputType.datetime,
                              text: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            const SizedBox(height: 20.0,),
                            defaultFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter date task';
                                }
                                return null;
                              },
                              controller: dateController,
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2025-05-05')
                                ).then((value) {
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                  print('dating taping');
                                });
                              },
                              type: TextInputType.datetime,
                              text: 'Task Time',
                              prefix: Icons.calendar_today,
                            ),

                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,

                  ).closed.then((value) =>
                  {
                    cubit.changeBottomSheetState(
                        isShow:false ,
                        icon: Icons.edit)
                  });
                  cubit.changeBottomSheetState(
                      isShow:true ,
                      icon: Icons.add,);
                }
              },
              child: Icon(cubit.iconShow),),

            bottomNavigationBar: BottomNavigationBar(

                type: BottomNavigationBarType.fixed,
                currentIndex:  cubit.current,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.line_weight_outlined,
                      ),
                      label: 'New tasks'),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline_outlined,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }

}
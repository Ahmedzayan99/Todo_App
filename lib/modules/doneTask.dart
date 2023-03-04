
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import '../shared/cubit/cubit/cubit.dart';
import '../shared/cubit/cubit/states.dart';
class DoneTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener:(context, state) {} ,
      builder: (context, state)
      {
        var tasks =TodoCubit.get(context).doneTasks;
        return taskBuilder(
          tasks:tasks
        );
      },
    );
  }
}

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit/cubit.dart';
Widget defaultFormField({
  required   String? Function(String?)? validator,
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onChanged,
  void Function()? onTap,
  bool enabled =true,
  void Function(String)? onSubmit,
  bool isPassword =false,
  required String text,
  required IconData prefix,
  IconData? suffix ,
  void Function()?suffixPressed,
}) => TextFormField(
    validator: validator,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onChanged:onChanged,
      onFieldSubmitted:onSubmit,
      onTap:onTap ,
      enabled:enabled ,
      decoration:InputDecoration(
      labelText: text,
      prefixIcon: Icon(prefix),
      suffixIcon:suffix!=null?IconButton(
          onPressed:suffixPressed,
            icon:Icon(suffix)):null,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0,))),
  ),);
Widget done(Map model,context)=> IconButton(
    onPressed:(){
      TodoCubit.get(context).updateToDatabase(
        status: 'done',id: model['id'],

      );
    },
    icon: const Icon(Icons.check_circle_outline_outlined));
Widget archive(Map model,context)=>IconButton(
onPressed:(){
TodoCubit.get(context).updateToDatabase(
status: 'archive', id: model['id'],
);
},
icon: const Icon(Icons.archive_outlined));
Widget buildTaskItem(Map model,context) => Dismissible(
      key: Key(
        model['id'].toString(),
      ),
     direction: DismissDirection.horizontal,
  onDismissed: (direction) {
           TodoCubit.get(context).deleteFromDatabase(id: model['id']);
  },
           child:   Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Row(
                       children: [
                            CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          maxRadius: 40.0,
                          child:Text('${model['time']}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),),
                          ),
                          const SizedBox(
                          width: 15.0,
                          ),
                          Expanded(
                            child:   Column(
                            mainAxisSize: MainAxisSize.min,
                            children:  [
                            Text(
                              '${model['title']}',
                            style: const TextStyle(
                            fontSize:18.0,
                            fontWeight: FontWeight.bold,
                            ),),
                            Text('${model['date']}',
                            style: const TextStyle(
                            color: Colors.grey,
                            ),)
                            ],
                            ),
                          ),
                            const SizedBox(
                              width: 15.0,
                            ),

                         model['status']=='done'?const SizedBox():IconButton(
                                onPressed:(){
                                  TodoCubit.get(context).updateToDatabase(
                                    status: 'done',id: model['id'],
                                  );
                                },
                                icon: const Icon(Icons.check_circle_outline_outlined),),
                         model['status']=='archive'?const SizedBox(): IconButton(
                                onPressed:(){
                                  TodoCubit.get(context).updateToDatabase(
                                    status: 'archive', id: model['id'],
                                  );
                                },
                                icon: const Icon(Icons.archive_outlined)),
                          ],
                          ),
                          ),
);
Widget taskBuilder({
  required List<Map> tasks
}) => ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder:(BuildContext context)=> ListView.separated(
      itemBuilder: (context, index) {
        print('task status ${tasks[index]['status']}');
        return buildTaskItem(tasks[index],context);
      },
      separatorBuilder:(context, index) => Container(
        width: double.infinity,
        height: 0.2,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length,
    ),
    fallback:(BuildContext context)=> Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.menu,
              size: 100.0,
              color: Colors.white),
          Text('لا يوجد مهام,.اضف مهمه جديده',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),)
        ],
      ),
    ));

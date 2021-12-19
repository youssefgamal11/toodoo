import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toodoo/shared/components/components.dart';
import 'package:toodoo/shared/cubit/cubit.dart';
import 'package:toodoo/shared/cubit/states.dart';
class PostponedScreen extends StatelessWidget {
  const PostponedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var tasks = AppCubit.get(context).archivedTasks;
          return conditionalWidget(tasks: tasks);
        },
        listener: (context, state) {});
  }
}

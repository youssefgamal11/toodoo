import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:toodoo/shared/components/components.dart';
import 'package:toodoo/shared/components/constants.dart';
import 'package:toodoo/shared/cubit/cubit.dart';
import 'package:toodoo/shared/cubit/states.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is InsertIntoDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(cubit.appbarTitles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit.screens[cubit.currentIndex],
              condition: state is! GetDataFromDataBaseLoadingState,
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.showBottomsheetStatus) {
                  if (formKey.currentState.validate()) {
                    cubit.insertIntoDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) => Container(
                            color: kbackgroundColor,
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  formField(
                                    // isEnabled: true,
                                      label: 'name of the task',
                                      type: TextInputType.text,
                                      prefix: Icons.title,
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return 'name must not be null';
                                        }
                                        return null;
                                      },
                                      controller: titleController),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10),
                                    child: formField(
                                      // isEnabled: false,
                                        label: 'time of the task',
                                        type: TextInputType.text,
                                        prefix: Icons.access_time,
                                        tap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) =>
                                                  timeController.text = value
                                                      .format(context)
                                                      .toString());
                                        },
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'time must not be null';
                                          }
                                          return null;
                                        },
                                        controller: timeController),
                                  ),
                                  formField(
                                    // isEnabled: false,
                                      label: 'date of the task',
                                      type: TextInputType.datetime,
                                      prefix: Icons.date_range,
                                      tap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2021-12-12'))
                                            .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value)
                                                  .toString();
                                        });
                                      },
                                      validate: (String value) {
                                        if (value.isEmpty) {
                                          return 'date must not be null';
                                        }
                                        return null;
                                      },
                                      controller: dateController),
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(
                        isShowen: false, iconData: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShowen: true, iconData: Icons.add);
                }
              },
              child: Icon(cubit.iconStatus),
              backgroundColor: kselectedItemColor,
            ),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                SalomonBottomBarItem(
                    icon: Icon(Icons.home_filled),
                    title: Text('Home'),
                    selectedColor: kselectedItemColor),
                SalomonBottomBarItem(
                    icon: Icon(Icons.done),
                    title: Text('done'),
                    selectedColor: kselectedItemColor),
                SalomonBottomBarItem(
                    icon: Icon(Icons.assignment_late_outlined),
                    title: Text('postponed'),
                    selectedColor: kselectedItemColor),
              ],
            ),
          );
        },
      ),
    );
  }
}

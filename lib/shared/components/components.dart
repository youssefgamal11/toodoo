import 'dart:math';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toodoo/shared/cubit/cubit.dart';

Widget formField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData subffix,
  Function suffixPressed,
  Function tap,
  // bool isEnabled = true ,
}) {
  return TextFormField(
    // enabled: isEnabled ,
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    validator: validate,
    onTap: tap,
    decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: subffix != null
            ? IconButton(icon: Icon(subffix), onPressed: suffixPressed)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )),
  );
}



Widget builTaskItem(Map model, context  , var color) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color:color , borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CupertinoButton(
                  minSize: double.minPositive,
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.checkmark_alt_circle,
                      color: Colors.white, size: 25),
                  onPressed: () {
                    AppCubit.get(context)
                        .updateDataBase(status: 'done', id: model['id']);
                  },
                ),
                SizedBox(width: 5),
                CupertinoButton(
                  minSize: double.minPositive,
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.clear_circled,
                      color: Colors.white, size: 25),
                  onPressed: () {
                    AppCubit.get(context)
                        .updateDataBase(status: 'archive', id: model['id']);
                  },
                )
              ]),
              Text(
                '${model['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Time :',
                      style: TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: '  ${model['time']}',
                        style: TextStyle(color: Colors.grey.shade700))
                  ])),
              // Text('Time : this is time'),
              SizedBox(
                height: 5,
              ),
              RichText(
                  text: TextSpan(
                      text: 'Date :',
                      style: TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: '  ${model['date']}',
                        style: TextStyle(color: Colors.grey.shade700))
                  ])),
            ],
          ),
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDataBase(id: model['id']);
    },
  );
}

Widget conditionalWidget({@required var tasks}) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) {
      return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 8,
            mainAxisExtent: 135),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return builTaskItem(tasks[index], context, RandomColorModel().getColor() );
        },
      );
    },
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "there is no tasks ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 25,
            ),
          )
        ],
      ),
    ),
  );
}
class RandomColorModel {
  Random random = Random();
  Color getColor() {
    return Color.fromARGB(random.nextInt(300), random.nextInt(300),
        random.nextInt(300), random.nextInt(300));
  }
}


void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
          (Route<dynamic> route) => false);
}
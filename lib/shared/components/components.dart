import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
Widget defaultButton({
  double width = double.infinity,
  bool isUpperCase = true,
  required Function() function, required String text,
}) =>
    Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15.0)),
      width: width,
      child: MaterialButton(
       textColor: Colors.white,
        onPressed: function,
        child: Text(text,style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold,fontSize: 17.0),),
      ),
    );

Future<bool?> defaultToast({required String text,Color color=Colors.red})=> Fluttertoast.showToast(
    msg:text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0
);
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CustomDate extends StatefulWidget {
  const CustomDate(
      {Key? key,
        required this.controller,
        required this.validator,
        required this.labelText,
        required this.initialDate,
        required this.firstDate,
        required this.lastDate,
      })
      : super(key: key);
  final controller;
  final validator;
  final labelText;
  final initialDate;
  final firstDate;
  final lastDate;

  @override
  State<CustomDate> createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: widget.controller,
      style: TextStyle(color: Colors.white70,fontSize: 16),
      //editable: false,
      validator: widget.validator,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
         contentPadding:EdgeInsets.only(left: 10.0,bottom: 10),
        // suffixIcon: Icon(Icons.cancel,color: Colors.black45,),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: .3, color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.cyan),
        ),
        // border: const OutlineInputBorder(),
        labelText: widget.labelText,
        errorStyle: TextStyle(
          color: Colors.white70,
        ),
        labelStyle: const TextStyle(color: Colors.grey),
      ),
      format: DateFormat("yyyy-MM-dd"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate

          //     initialDate: DateTime(2000),
          // firstDate: DateTime(1960),
          // lastDate: DateTime(2010),
          // initialDate: DateTime.now(),
          // firstDate: DateTime.now().subtract(const Duration(days: 0)),
          // lastDate: DateTime.now().add(const Duration(days: 240)),
        );
      },
      onChanged: (dt) {
        // _endDateController.text =
        //     new DateFormat("yyyy-MM-dd").format(dt?.add(new Duration(days: 354)) ?? DateTime.now());
      },
    );
  }
}

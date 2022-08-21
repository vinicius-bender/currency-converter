import 'package:flutter/material.dart';

Widget customTextField (String labelText, String prefixText, TextEditingController textController, Function f) {
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: TextField(
          decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          prefixText: prefixText,
        ),
        controller: textController,
        onChanged: (texto){
          f(texto);
        },
        keyboardType: TextInputType.number,
      ),
  );
}
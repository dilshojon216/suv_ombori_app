import 'package:flutter/material.dart';

import '../models/tabel_model.dart';

Future<T?> showTextDialog<T>(BuildContext context, {Tabel? tabel}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(
        tabel: tabel,
      ),
    );

class TextDialogWidget extends StatefulWidget {
  final Tabel? tabel;

  const TextDialogWidget({
    Key? key,
    this.tabel,
  }) : super(key: key);

  @override
  _TextDialogWidgetState createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.tabel!.tabelValue);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.tabel!.tabelNumber.toString() + " ni o'zgartirish"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text('Saqlash'),
            onPressed: () => Navigator.of(context).pop(controller!.text),
          )
        ],
      );
}

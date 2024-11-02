import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SingleChildScrollView(child: content),
      actions: actions,
    );
  }
}

import 'package:flutter/material.dart';

class CustomListItem<T> extends StatelessWidget {
  final T item;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final Future<bool> Function() confirmDismiss;
  final VoidCallback onDismiss;

  const CustomListItem({
    Key? key,
    required this.item,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.onEdit,
    required this.confirmDismiss,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => confirmDismiss(),
      onDismissed: (direction) => onDismiss(),
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
        onTap: onTap,
      ),
    );
  }
}

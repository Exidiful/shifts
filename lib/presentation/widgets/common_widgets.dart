// TODO: Move all reusable widgets here from various files

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme.dart';

// Example of a common widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(text),
    );
  }
}

// Add more common widgets here as needed

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
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return AlertDialog(
      backgroundColor: customTheme?.cardBackgroundColor,
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      content: content,
      actions: actions,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class CustomListItem<T> extends StatefulWidget {
  final T item;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final Future<bool> Function() confirmDismiss;
  final VoidCallback onDismiss;

  const CustomListItem({
    Key? key,
    required this.item,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onEdit,
    required this.confirmDismiss,
    required this.onDismiss,
  }) : super(key: key);

  @override
  _CustomListItemState<T> createState() => _CustomListItemState<T>();
}

class _CustomListItemState<T> extends State<CustomListItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered
              ? customTheme?.listTileColor?.withOpacity(0.7)
              : customTheme?.listTileColor?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 2)]
              : [],
        ),
        child: Dismissible(
          key: Key(widget.item.hashCode.toString()),
          background: Container(
            color: Theme.of(context).colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) => widget.confirmDismiss(),
          onDismissed: (direction) => widget.onDismiss(),
          child: ListTile(
            title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(widget.subtitle, style: Theme.of(context).textTheme.bodyMedium),
            onTap: widget.onTap,
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
              onPressed: widget.onEdit,
            ),
          ),
        ),
      ),
    );
  }
}

// Add any other existing common widgets here

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const BlurredAppBar({Key? key, required this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          elevation: 0,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

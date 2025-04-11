import 'package:flutter/material.dart';

class SliverAppbarSelectionMode extends StatelessWidget {
  final bool onSelectionMode;
  final Widget title;
  final Widget titleOnSelectionMode;
  final Widget? leading;
  final Widget? leadingOnSelectionMode;
  final List<Widget>? actions;
  final List<Widget>? actionsOnSelectionMode;

  const SliverAppbarSelectionMode({
    super.key,
    required this.onSelectionMode,
    required this.title,
    required this.titleOnSelectionMode,
    this.leading,
    this.leadingOnSelectionMode,
    this.actions,
    this.actionsOnSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    if (!onSelectionMode) {
      return SliverAppBar(
        snap: true,
        floating: true,
        centerTitle: true,
        leading: leading,
        title: title,
        backgroundColor: Theme.of(context).primaryColor,
        actions: actions,
      );
    } else {
      return SliverAppBar(
        snap: true,
        floating: true,
        centerTitle: true,
        leading: leadingOnSelectionMode,
        title: titleOnSelectionMode,
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        iconTheme: Theme.of(context).iconTheme,
        actions: actionsOnSelectionMode,
      );
    }
  }
}

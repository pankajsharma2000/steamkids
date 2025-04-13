import 'package:flutter/material.dart';

class CommonPageScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final bool withPadding;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Widget? leading;


  const CommonPageScaffold({
    super.key,
    required this.child,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.withPadding = true,
    this.bottomNavigationBar,
    this.actions,
    this.leading,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: child,
    );
  }
}
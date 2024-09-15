import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final FontWeight fontWeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.titleColor = Colors.white,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: titleColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: backgroundColor != Colors.transparent
              ? LinearGradient(
                  colors: [backgroundColor.withOpacity(0.9), backgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
        ),
      ),
      automaticallyImplyLeading: false,
      foregroundColor: titleColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

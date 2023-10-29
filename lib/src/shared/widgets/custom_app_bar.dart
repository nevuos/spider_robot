import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTextColor = _getTextColor(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: appBarTextColor,
          fontWeight: appBarTextColor == Colors.white
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      backgroundColor: Colors.transparent,  
      flexibleSpace: _getAppBarGradient(context),
      iconTheme: IconThemeData(color: appBarTextColor),
    );
  }

  Container _getAppBarGradient(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.greenAccent[400]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context) {
    return Colors.white;  
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

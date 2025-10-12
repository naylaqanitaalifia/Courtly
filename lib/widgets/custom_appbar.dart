import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final bool centerTitle;
  final double? toolbarHeight;
  final List<Widget>? actions;
  final bool showBottomLine;
  final bool automaticallyImplyLeading;
  final EdgeInsetsGeometry? titlePadding;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.fontSize = 20,
    this.fontWeight = FontWeight.w700,
    this.centerTitle = false,
    this.toolbarHeight = 75,
    this.actions,
    this.showBottomLine = false,
    this.automaticallyImplyLeading = true,
    this.titlePadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      titleSpacing: 0,
      title: Padding(
        padding: titlePadding ?? EdgeInsets.zero,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
      actions: actions,
      bottom: showBottomLine
          ? PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color(0xFFFC9CDCF),
          height: 1,
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((toolbarHeight ?? kToolbarHeight) + (showBottomLine ? 1 : 0));
}

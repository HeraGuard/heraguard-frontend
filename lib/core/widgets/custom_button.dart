import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.padding,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthLink extends StatelessWidget {
  final String title;
  final String titleLink;
  final VoidCallback onTap;

  const AuthLink({
    super.key,
    required this.onTap,
    required this.title,
    required this.titleLink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            titleLink,
            style: TextStyle(
              color: const Color(0xFF0040FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

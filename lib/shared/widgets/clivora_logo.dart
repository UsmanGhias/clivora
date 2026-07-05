import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/clivora_colors.dart';

class ClivoraLogo extends StatelessWidget {
  const ClivoraLogo({super.key, this.size = 48, this.borderRadius = 14});

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        'assets/images/clivora_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ClivoraColors.primaryPurple, const Color(0xFF4F46E5)],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          alignment: Alignment.center,
          child: Text(
            'C',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.45,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.photoPath,
    this.name,
    this.radius = 24,
    this.onTap,
  });

  final String? photoPath;
  final String? name;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (photoPath != null && photoPath!.isNotEmpty && File(photoPath!).existsSync()) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(photoPath!)),
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: ClivoraColors.primaryPurple.withValues(alpha: 0.2),
        child: Text(
          (name != null && name!.isNotEmpty) ? name![0].toUpperCase() : '?',
          style: TextStyle(
            color: ClivoraColors.primaryPurple,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.7,
          ),
        ),
      );
    }

    if (onTap == null) return avatar;
    return GestureDetector(onTap: onTap, child: avatar);
  }
}

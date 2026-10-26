// Autor: Davi de Assis Fabricio
import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class FocusQuestLogo extends StatelessWidget {
  const FocusQuestLogo({this.size = 80, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.text,
                size: size * .52,
              ),
            ),
            Positioned(
              right: -3,
              top: -3,
              child: Icon(
                Icons.star_rounded,
                color: AppColors.reward,
                size: size * .36,
              ),
            ),
          ],
        ),
      );
}

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class PhoneIllustration extends StatelessWidget {
  const PhoneIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Phone body
          Center(
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.phoneDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.phoneBorder, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.25 * 255).round()),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    decoration: const BoxDecoration(
                      color: AppColors.phoneBorder,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.brandRed,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 80,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.phoneLines,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.phoneLines,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User badge (right)
          Positioned(
            right: 0,
            top: 60,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.brandRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x55CC0000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person_outline_rounded,
                  color: Colors.white, size: 24),
            ),
          ),

          // Pie chart badge (left-bottom)
          Positioned(
            left: 4,
            bottom: 20,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.12 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.pie_chart_outline_rounded,
                  color: AppColors.brandRed, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
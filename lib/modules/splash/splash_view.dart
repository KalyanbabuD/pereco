import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(
                begin: const Offset(-50, 0),
                end: Offset.zero,
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              builder: (context, offset, child) {
                return Transform.translate(offset: offset, child: child);
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeIn,
                builder: (context, opacity, child) {
                  return Opacity(opacity: opacity, child: child);
                },
                child: Image.asset(
                  'assets/images/pocketbizWithIcon.png',
                  width: 320, // Increased size significantly
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(
                begin: const Offset(0, 50),
                end: Offset.zero,
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              builder: (context, offset, child) {
                return Transform.translate(offset: offset, child: child);
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeIn,
                builder: (context, opacity, child) {
                  return Opacity(opacity: opacity, child: child);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 3,
                      height: 56, // Increased height to match larger text
                      color: AppColors.primaryRed,
                      margin: const EdgeInsets.only(right: 16),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seamless Growth',
                          style: TextStyle(
                            fontSize: 26, // Increased size
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Possible',
                          style: TextStyle(
                            fontSize: 26, // Increased size
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

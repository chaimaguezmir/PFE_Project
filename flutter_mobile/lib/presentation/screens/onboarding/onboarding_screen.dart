import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/auth/onboarding/auth_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/theme/theme_data_config.dart';
import '../../../injection_container.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const _OnBoardingForm(),
          ),
        ),
      ),
    );
  }
}

class _OnBoardingForm extends StatelessWidget {
  const _OnBoardingForm();

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (index) {
            context.read<AuthCubit>().setPage(index);
          },
          children: const [
            _IntroScreen(
              imagePath: 'lib/config/assets/images/intro.png',
              description:
                  'Prenez le contrôle de votre santé.. Tout à portée de main !',
            ),
            _IntroScreen(
              imagePath: 'lib/config/assets/images/intro.png',
              description: 'Ajoutez vos \nmédicaments en toute \nsimplicité.',
            ),
            _IntroScreen(
              imagePath: 'lib/config/assets/images/intro.png',
              description: 'Suivez vos doses, \nrestez informé',
            ),
          ],
        ),

        Container(
          alignment: const Alignment(0, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SmoothPageIndicator(pageController: pageController),
              _NextButton(pageController: pageController),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmoothPageIndicator extends StatelessWidget {
  const _SmoothPageIndicator({required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: 3,
      effect: WormEffect(
        dotHeight: 10.w,
        dotWidth: 40.w,
        activeDotColor: theme().colorScheme.primary,
        dotColor: Colors.grey,
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.currentPage != current.currentPage,
      builder: (context, state) {
        return IconButton(
          color: theme().colorScheme.onSecondary,
          style: IconButton.styleFrom(
            backgroundColor: theme().colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          onPressed: () {
            if (state.currentPage < 2) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              );
              return;
            }
            context.read<AuthCubit>().setOnboardingDone(context);
          },
          icon: state.currentPage != 2
              ? const Icon(Icons.arrow_forward)
              : const Icon(Icons.check),
        );
      },
    );
  }
}

class _IntroScreen extends StatelessWidget {
  const _IntroScreen({required this.imagePath, required this.description});

  final String imagePath;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: const Alignment(0.75, 0.25),
            child: GestureDetector(
              onTap: () {
                context.read<AuthCubit>().setOnboardingDone(context);
              },
              child: Text(
                "skip",
                style: TextStyle(fontSize: 40.sp, color: Colors.green),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'lib/config/assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: 1000.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80.r),
              gradient: appGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                maxLines: 3,
                description,
                style: TextStyle(
                  color: theme().colorScheme.onPrimary,
                  fontSize: 70.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

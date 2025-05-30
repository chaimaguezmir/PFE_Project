import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/onboarding/pages/intro_screen1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../bloc/OnboardingCubit.dart';
import '../widgets/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final List<OnboardingItem> items = [
    OnboardingItem(
      image: 'lib/config/assets/images/intro.png',
      description:
          'Prenez le contrôle de votre santé.. Tout à portée de main !',
    ),
    OnboardingItem(
      image: 'lib/config/assets/images/intro.png',
      description: 'Ajoutez vos \nmédicaments en toute \nsimplicité.',
    ),
    OnboardingItem(
      image: 'lib/config/assets/images/intro.png',
      description: 'Suivez vos doses, \nrestez informé',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Controller to control the PageView
    PageController _controller = PageController();

    Future<void> _onNextTap(bool isLast) async {
      if (!isLast) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenOnboarding', true);
        GoRouter.of(context).go('/login');
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (index) {
              context.read<OnboardingCubit>().setPage(index);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return IntroScreen1(item: item);
            },
          ),
          //dot indicator
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //page indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: items.length,
                  effect: WormEffect(
                    dotHeight: 10.w,
                    dotWidth: 24.w,
                    activeDotColor: theme().colorScheme.primary,
                    dotColor: Colors.grey,
                  ),
                ),

                //next button
                BlocBuilder<OnboardingCubit, int>(
                  builder: (context, state) {
                    final isLast = state == items.length - 1;
                    return GestureDetector(
                      onTap: () => _onNextTap(isLast),
                      child: CircleAvatar(
                        radius: 60.sp,
                        backgroundColor: theme().colorScheme.primary,
                        child: Icon(
                          isLast ? Icons.check : Icons.arrow_forward,
                          color: Colors.white,
                          size: 60.sp,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

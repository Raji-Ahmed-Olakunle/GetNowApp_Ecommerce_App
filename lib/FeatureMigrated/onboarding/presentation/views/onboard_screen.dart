import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/onboarding_provider.dart';

class OnBoardScreen extends ConsumerStatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends ConsumerState<OnBoardScreen> {
  double value = 1 / 4;
  int? ind;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ind = 0;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    final onboardInfo = ref.read(onboardingProvider).value;
    void _nextPage() {
      if (ind! < onboardInfo!.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    void _previousPage() {
      if (ind! > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      final prefAccess = await SharedPreferences.getInstance();
                      prefAccess.setBool("isFirstTimeUser", false);
                      context.go("/AuthScreen");
                    },
                    child: const Text("Skip"),
                  ),
                ],
              ),
              LinearProgressIndicator(value: value, minHeight: 5),
              const SizedBox(height: 10),
              Expanded(
                flex: 10,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardInfo!.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (pagenum) {
                    setState(() {
                      ind = pagenum;
                      value = pagenum / (onboardInfo.length - 1);
                    });
                  },
                  itemBuilder:
                      (context, index) => Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: FlutterCarousel(
                              options: FlutterCarouselOptions(
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration: const Duration(
                                  seconds: 2,
                                ),
                                viewportFraction: 1,
                                disableCenter: false,
                                clipBehavior: Clip.hardEdge,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                showIndicator: true,
                                slideIndicator: CircularSlideIndicator(),
                              ),
                              items: List.generate(
                                onboardInfo[index].imageSource.length,
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      if (onboardInfo[index].imageSource[i]
                                          .endsWith('.svg')) {
                                        return SizedBox(
                                          height: 1000,
                                          child: SvgPicture.asset(
                                            onboardInfo[index].imageSource[i],
                                          ),
                                        );
                                      } else {
                                        return Image.asset(
                                          onboardInfo[index].imageSource[i],
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  onboardInfo[index].title,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  onboardInfo[index].subTitle,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                ),
              ),
              Expanded(
                flex: 2,
                child:
                    value == 1 || value == 0.25
                        ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (value != 0.25 && value != 1)
                              IconButton(
                                onPressed: _previousPage,
                                icon: const Icon(Icons.arrow_back),
                              ),
                            if (value != 1)
                              IconButton(
                                onPressed: _nextPage,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                          ],
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

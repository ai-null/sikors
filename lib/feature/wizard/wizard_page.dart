import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sikors/core/assets/asset.dart';
import 'package:sikors/core/design/color.dart';
import 'package:sikors/core/design/size.dart';
import 'package:sikors/core/design/typography.dart';
import 'package:sikors/feature/homepage/homepage.dart';

const _stepperLength = 4;
const _scrollableCategoriesLength = 3;

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  late List<AnimationController> _progressBarController;
  late List<ScrollController> _scrollableCategoriesController;

  // STATES
  int _currentProgressIndex = 0;
  late List<List<int>> _scrollableCategoriesContent;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 1);
    _tabController = TabController(length: _stepperLength, vsync: this);

    _scrollableCategoriesContent =
        List.generate(_scrollableCategoriesLength, (index) {
      return List.generate(Random().nextInt(5) + 5,
          (_) => Random().nextInt(DefAsset.values.length - 1));
    });

    // CREATING PROGRESSBAR CONTROLLER
    _progressBarController = List.generate(_stepperLength, (index) {
      final animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 8),
      )
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener(_onStatusListener);
      return animationController;
    });

    // CREATING SCROLLABLE CATEGORIES CONTROLLER
    _scrollableCategoriesController = List.generate(
      _scrollableCategoriesLength,
      (index) {
        return ScrollController();
      },
    );

    // START SCROLLABLE CATEGORIES CONTROLLER
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var controller in _scrollableCategoriesController) {
        final max = controller.position.maxScrollExtent;
        final min = controller.position.minScrollExtent;
        var direction = max;

        _startScrollableCategories(
          max,
          min,
          direction,
          controller,
          Random().nextInt(30) + 5,
        );
      }
    });
    // START ANIMATION
    _progressBarController[_currentProgressIndex].forward();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
    for (var controller in _progressBarController) {
      controller.dispose();
    }

    for (var controller in _scrollableCategoriesController) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefColor.colorRed900,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ==== PROGRESS BAR / STEPPER ====
                      Container(
                        height: 16,
                        width: double.infinity,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: DefColor.colorRed50,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              DefShape.medium,
                            ),
                          ),
                        ),
                        child: Row(
                          children: List.generate(
                            4,
                            (index) {
                              return Expanded(
                                child: LinearProgressIndicator(
                                  color: DefColor.colorRed400,
                                  backgroundColor: DefColor.colorNeutral100,
                                  minHeight: 8,
                                  value: _progressBarController[index].value,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(DefShape.extraSmall),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==== PAGEVIEW ====
              Flexible(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 320,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: DefColor.colorNeutral50,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        DefShape.medium,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // ==== WIZARD CARD ====
                      PageView(
                        controller: _pageViewController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          _stepperLength,
                          (index) {
                            return const _WizardCard();
                          },
                        ),
                      ),

                      // ==== SKIP BUTTON ====
                      Positioned(
                        right: 0,
                        child: Material(
                          child: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Text('Skip'),
                                ),
                                Icon(Icons.chevron_right_rounded)
                              ]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // const Expanded(child: SizedBox()),

              // === AUTOMATED SCROLLING CATEGORIES ===
              Flexible(
                child: Column(
                  children: List.generate(
                    _scrollableCategoriesLength,
                    (index) {
                      return ScrollableCategories(
                        scrollController:
                            _scrollableCategoriesController[index],
                        content: _scrollableCategoriesContent[index],
                      );
                    },
                  ),
                ),
              ),

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }));
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(DefColor.colorBrown50),
                      ),
                      child: Text(
                        'Continue',
                        style: DefTypography.titleLarge
                            .copyWith(color: DefColor.colorRed900),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _startScrollableCategories(double max, double min, double direction,
      ScrollController controller, int duration) {
    controller
        .animateTo(
      direction,
      duration: Duration(seconds: duration),
      curve: Curves.linear,
    )
        .then((value) {
      direction = direction == max ? min : max;
      _startScrollableCategories(max, min, direction, controller, duration);
    });
  }

  void _onStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_currentProgressIndex + 1 > _stepperLength - 1) {
        // RESTART
        for (var element in _progressBarController) {
          element.value = 0;
        }
        _currentProgressIndex = 0;
        _updateCurrentPageIndex(0);
      } else {
        // DO NEXT ANIMATION
        _currentProgressIndex++;
        _updateCurrentPageIndex(_currentProgressIndex);
      }

      _progressBarController[_currentProgressIndex].forward();
    }
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class ScrollableCategories extends StatelessWidget {
  final ScrollController? scrollController;
  final List<int> content;

  const ScrollableCategories({
    super.key,
    this.scrollController,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: content.length,
          itemBuilder: (_, index) {
            final name = DefAsset.values.keys.elementAt(content[index]);
            final value = DefAsset.values.values.elementAt(content[index]);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: DefColor.colorRed200,
                borderRadius: BorderRadius.circular(1000),
              ),
              padding: const EdgeInsets.fromLTRB(10, 8, 32, 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Image.asset(
                        value,
                        height: 32,
                        width: 32,
                      )),
                    ),
                  ),
                  Text(
                    name,
                    style: DefTypography.titleLarge
                        .copyWith(color: DefColor.colorRed900),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WizardCard extends StatelessWidget {
  const _WizardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Stay connected\nwith your ',
              style: DefTypography.headlineLarge
                  .copyWith(color: DefColor.colorBlack),
              children: const [
                TextSpan(
                  text: 'favorite\n',
                  style: TextStyle(
                    color: DefColor.colorRed300,
                  ),
                ),
                TextSpan(text: 'leagues, teams,\nand players.')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 30),
            child: RichText(
              text: TextSpan(
                text: 'Never miss all the updates with\n',
                style: DefTypography.bodyLarge.copyWith(
                  color: DefColor.colorRed900,
                ),
                children: [
                  TextSpan(
                    text: 'Sikors',
                    style: DefTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ', anytime and anywhere.')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

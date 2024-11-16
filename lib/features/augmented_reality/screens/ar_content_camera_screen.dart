import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../navigation_menu.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/popups/custom_alert_dialog.dart';
import '../../museum_visit_login/controllers/qr_code_controller.dart';

class ArContentCameraScreen extends StatefulWidget {
  const ArContentCameraScreen({super.key});

  @override
  State<ArContentCameraScreen> createState() => _ArContentCameraScreenState();
}

class _ArContentCameraScreenState extends State<ArContentCameraScreen> {
  final controller = Get.put(QRCodeController());
  bool? isUnityArSupportedOnDevice;
  bool _isLoading = true;
  bool _displayInstructions = true;
  String arMainStatusMessage = "Loading AR content...";
  String arSubStatusMessage = "";

  Timer? _subtitleTimer;
  int _subtitleIndex = 0;

  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<String> _loadingSubtitles = [
    "This may take a few moments...",
    "Did you know? AR merges digital and physical worlds!",
    "Fun fact: AR can make learning more interactive!",
    "Just a moment, bringing AR to life!",
  ];

  final List<String> _instructionPages = [
    "Aim your camera at museum items to explore AR content.",
    "Tap visible 3D objects or the tap icon to open an information about the museum item.",
    "For the best experience, use headphones or lower your volume to avoid disturbing others."
  ];

  final List<String> _instructionImages = [
    MAppImages.phoneAnimation,
    MAppImages.tapAnimation,
    MAppImages.headphonesAnimation,
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _startSubtitleRotation();
  }

  @override
  void dispose() {
    _subtitleTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startSubtitleRotation() {
    _subtitleTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _subtitleIndex = (_subtitleIndex + 1) % _loadingSubtitles.length;
        arSubStatusMessage = _loadingSubtitles[_subtitleIndex];
      });
    });
  }

  // void _onNextPage() {
  //   if (_currentPageIndex < _instructionPages.length - 1) {
  //     _pageController.nextPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  // void _onPreviousPage() {
  //   if (_currentPageIndex > 0) {
  //     _pageController.previousPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  // // Method to handle navigation if AR is not supported
  // void _handleNotSupported(BuildContext context) {
  //   if (!mounted) return;
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return WillPopScope(
      onWillPop: () async {
        // Define behavior for back button press
        return await showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'Exit AR Camera',
            content: 'Are you sure you want to exit?',
            onConfirm: () {
              // Send time-out to firebase
              controller.updateMuseumVisitTimeOut();
              Get.offAll(() => const NavigationMenu());
            },
          ),
        );
      },
      child: Scaffold(
        backgroundColor: dark ? MAppColors.dark : MAppColors.light,
        body: Stack(
          children: [
            // Unity Embed
            Column(
              children: [
                Expanded(
                  child: EmbedUnity(
                    onMessageFromUnity: (String data) {
                      if (data == "ar:true") {
                        setState(() {
                          isUnityArSupportedOnDevice = true;
                          _isLoading = false;
                        });
                      } else if (data == "ar:false") {
                        setState(() {
                          isUnityArSupportedOnDevice = false;
                          _isLoading = false;
                          Navigator.pop(context);
                        });
                      } else if (data == "scene_loaded") {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            // Loading Screen Overlay
            if (_isLoading)
              Container(
                color: dark ? MAppColors.dark : MAppColors.light,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MAppHelperFunctions.screenWidth() * 0.1,
                      child: Lottie.asset(
                        MAppImages.arLoadingAnimation,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        arMainStatusMessage,
                        style: TextStyle(
                            color: dark ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        arSubStatusMessage,
                        style: TextStyle(
                          color: dark ? Colors.white70 : Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            // Instructions Overlay
            // Instructions Overlay
            if (_isLoading && _displayInstructions)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: dark ? MAppColors.dark : MAppColors.light,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _instructionPages.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Image.asset(
                                          _instructionImages[index],
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _instructionPages[index],
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.white : Colors.black,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            _instructionPages.length,
                            (index) => GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPageIndex == index
                                      ? dark
                                          ? Colors.white
                                          : Colors.black
                                      : dark
                                          ? Colors.white.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // First page, empty prev
                            if (_currentPageIndex == 0)
                              const SizedBox(width: 10),
                            // Show "Previous" button from 2nd page onward
                            if (_currentPageIndex > 0)
                              TextButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: Text(
                                  "Previous",
                                  style: TextStyle(
                                      color:
                                          dark ? Colors.white : Colors.black),
                                ),
                              ),
                            // Conditionally show "Next" or "OK" button on the right side
                            if (_currentPageIndex <
                                _instructionPages.length - 1)
                              TextButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      color:
                                          dark ? Colors.white : Colors.black),
                                ),
                              )
                            else
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _displayInstructions = false;
                                  });
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color:
                                          dark ? Colors.white : Colors.black),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Skip Button
            if (_isLoading && _displayInstructions)
              Positioned(
                top: 20,
                right: 10,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _displayInstructions = false;
                    });
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(color: dark ? Colors.white : Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

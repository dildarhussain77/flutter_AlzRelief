

import 'package:alzrelief/screens/sign%20in%20with%20google/sign_in_with_google_Role.dart';
import 'package:alzrelief/util/onboardingcards.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  static final PageController pageController = PageController(initialPage: 0);
  

  List<Widget> onBoardingPages(BuildContext context) {
    return [      
    OnBoardingCards(
      image: "assets/images/AlzRelief1.jpg",
      title: "You Need To Know",
      description: "Welcome to our Alzheimer's support app, providing tools and guidance for your journey.",
      buttonText: "Next",
      onPressed: () {
        pageController.animateToPage(
          1, 
          duration: Durations.long1, 
          curve: Curves.linear,);
      },
    ),
    OnBoardingCards(
      image: "assets/images/AlzRelief2.png",
      title: "Alzheimer Disease",
      description: "Learn about Alzheimer's disease and how our app can assist in managing its challenges.",
      buttonText: "Next",
      onPressed: () {
        pageController.animateToPage(
          2, 
          duration: Durations.long1, 
          curve: Curves.linear,);
      },
    ),
    OnBoardingCards(
      image: "assets/images/AlzRelief3.jpg",
      title: "Deserve Health",
      description: "Discover how our app empowers you to prioritize and maintain your health amidst Alzheimer's.",
      buttonText: "Done",
      onPressed: () {
        onPressed(context);
      },
    ),
    ];
  }

  void onPressed(BuildContext context) {
  // Navigate to the login page
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInWithGoogleRolePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
      
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  children: onBoardingPages(context),
      
                ),
              ),
              SmoothPageIndicator(
                controller: pageController, 
                count: onBoardingPages(context).length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Color.fromRGBO(95, 37, 133, 1.0),
      
                  dotColor: Color.fromRGBO(95, 37, 133, 1.0),
                
                ),
                onDotClicked: (index){
                  pageController.animateToPage(
                    index, 
                    duration: Durations.long1, 
                    curve: Curves.linear
                  );
                },
              ), 
              
            ],
          ),
        ),
        
      ),
    );
  }
}
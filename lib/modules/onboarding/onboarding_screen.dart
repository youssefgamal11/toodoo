import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:toodoo/layout/home_layout.dart';
import 'package:toodoo/shared/components/components.dart';
import 'package:toodoo/shared/network/local.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  List<PageViewModel> getPages(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return [
      PageViewModel(
          title: 'Organize your tasks easily',
          body:
              'with toodoo you can add elements to find and complete your tasks easily',
          image: Image.asset('assets/images/Multitasking_4.jpg') ,
      decoration: PageDecoration(imagePadding: EdgeInsets.only(top: 60) , imageFlex: 1)),
      PageViewModel(
        title: 'Complete your life goals',
        body: ' toodoo helps you to achive your goals ',
        image: Image.asset('assets/images/Multitasking_1.jpg'),
        decoration: PageDecoration( imagePadding: EdgeInsets.only(top: 60) , imageFlex: 1)
      ),
      PageViewModel(
        title: 'show your achievements',
        body:
            'you should be proud of the goals you have completed that\'s why you can take a look to them ',
        image: Image.asset('assets/images/acheivment.png'),
          decoration: PageDecoration( imagePadding: EdgeInsets.only(top: 60) , imageFlex: 1   ) )

    ];
  }

  @override
  Widget build(BuildContext context) {
    void submit()  {
      CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
        if (value) {
          navigateAndFinish(context, HomeLayout());
        }
      });
    }
    return IntroductionScreen(
      pages: getPages(context),
      done: Text(
        'Done',
        style: TextStyle(fontSize: 20),
      ),
      showNextButton: true,
      next: Icon(Icons.arrow_forward_ios),
      onDone: () {
        submit();
      },
      globalBackgroundColor: Color(0xffFFF2D2),
      color: Colors.black,
    );
  }
}
